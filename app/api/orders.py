from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from datetime import datetime
from ..core.database import get_db
from ..models import schemas as models

router = APIRouter()

@router.get("/")
def read_orders(db: Session = Depends(get_db)):
    # 주문 내역 전체 조회
    orders = db.query(models.Order).all()
    return orders

@router.post("/")
def create_order(item_id: int, customer_id: str, count: int, db: Session = Depends(get_db)):
    # 1. 해당 상품 재고 조회
    item = db.query(models.Inventory).filter(models.Inventory.item_id == item_id).first()
    
    if not item:
        raise HTTPException(status_code=404, detail="상품 정보를 찾을 수 없습니다.")
    
    # 2. 재고 수량 검증 (주문하려는 수량보다 재고가 적은지 확인)
    if item.quantity < count:
        raise HTTPException(status_code=400, detail=f"재고가 부족합니다. (현재 재고: {item.quantity})")
    
    # [핵심] 3. 재고 차감 실행
    # SQLAlchemy의 객체는 값을 변경하고 commit하면 DB에 반영됩니다.
    item.quantity -= count 
    
    # 4. 주문 데이터 생성
    new_order = models.Order(
        item_id=item_id,
        customer_id=customer_id,
        order_quantity=count,  # 컬럼명이 schemas.py와 일치하는지 확인 필요
        order_time=datetime.now()
    )
    
    try:
        # 5. DB 트랜잭션 처리
        db.add(new_order)
        db.commit()   # 재고 차감과 주문 생성이 동시에 DB에 반영됩니다.
        db.refresh(new_order)
        return {
            "status": "success",
            "message": f"{item.item_name} 상품 {count}개 주문 완료!",
            "remaining_quantity": item.quantity
        }
    except Exception as e:
        db.rollback() # 에러 발생 시 진행했던 모든 작업을 취소(롤백)
        raise HTTPException(status_code=500, detail="주문 처리 중 오류가 발생했습니다.")