# Orders Feature (Đơn hàng & Đánh giá)

## Developer Information
- **Assignee**: Member 3
- **Template Reference**: Reference `lib/features/auth/` for clean architecture implementation.

## Purpose
- FR-08, FR-09: Create orders, browse order lists, track status timeline, cancel order (if eligible), and submit review ratings.
- UC-11: Theo dõi & hủy đơn hàng.
- UC-12: Đánh giá sản phẩm.

## REST Endpoints
- `POST /orders` - Create order (✅ JWT).
- `GET /orders` - List of user's orders (✅ JWT).
- `GET /orders/{id}` - Details of a specific order (✅ JWT).
- `PATCH /orders/{id}/cancel` - Cancel a pending or confirmed order (✅ JWT).
- `POST /reviews` - Create rating/review for a purchased item (✅ JWT).

## Dependencies
- `core/network`
- `shared/models/` (`Order`, `OrderItem`, `Review`)

## Recommended Core Entities & Models
- `Order`
- `OrderItem`
- `Review`

## Recommended Usecases
- `CreateOrder`
- `GetOrdersList`
- `GetOrderDetail`
- `CancelOrder`
- `SubmitReview`

## Recommended Repositories
- `OrderRepository`

## Pending Tasks
- [x] Implement data layer `OrderRemoteDataSource` and `OrderRepositoryImpl`.
- [x] Implement usecases and state management (`ordersProvider`, `orderDetailProvider`).
- [x] Build Order History tabs UI (Pending, Delivering, Completed, Cancelled).
- [x] Build Order detail timeline tracking view.
- [x] Build Review form dialog (stars input, comments input).

## Ghi chú triển khai

- Endpoint hủy đơn thực tế là `PATCH /orders/:id/cancel` (không phải
  `PATCH /orders/{id}/cancel` như README gốc ghi — đã khớp với BE).
- Model đặt trong `data/models/order_detail.dart`, mirror `ORDER_DETAIL_SELECT`
  của BE (có `subtotal`, `discount`, `shippingFee`, `shippingCode`, `address`,
  `payment`). KHÔNG dùng `shared/models/order.dart` vì model đó thiếu field.
- `domain/order_status_info.dart` giữ nhãn/màu/icon cho từng trạng thái và
  `isOrderCancellable()` khớp `isCancellable` của BE (pending_payment, confirmed).
- Timeline theo state machine BE: pending_payment → confirmed → packed →
  shipping → delivered → completed; `cancelled` hiển thị banner riêng.
- Review viết riêng trong feature này (không phụ thuộc `catalog`), gọi
  `POST /reviews`. Nút đánh giá chỉ hiện khi đơn ở trạng thái `completed`.
