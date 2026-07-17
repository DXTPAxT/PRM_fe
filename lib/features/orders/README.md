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
- [ ] Implement data layer `OrderRemoteDataSource` and `OrderRepositoryImpl`.
- [ ] Implement usecases and state management (`ordersProvider`, `orderDetailProvider`).
- [ ] Build Order History tabs UI (Pending, Delivering, Completed, Cancelled).
- [ ] Build Order detail timeline tracking view.
- [ ] Build Review form dialog (stars input, comments input).
