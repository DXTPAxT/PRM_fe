# Cart Feature (Giỏ hàng)

## Developer Information
- **Assignee**: Member 3
- **Template Reference**: Reference `lib/features/auth/` for clean architecture implementation.

## Purpose
- FR-04: Manage items, choose variants (size + color), and configure quantity before checkout.
- UC-07: Quản lý giỏ hàng.

## REST Endpoints
- `GET /cart` - Retrieve user's cart (✅ JWT).
- `POST /cart` - Add item to cart (✅ JWT).
- `PUT /cart/{id}` - Update quantity of cart item (✅ JWT).
- `DELETE /cart/{id}` - Remove item from cart (✅ JWT).

## Dependencies
- `core/network`
- `features/auth` (to retrieve current authenticated state)
- `shared/models/` (`ProductVariant`)

## Recommended Core Entities & Models
- `CartItem` (freezed model mirroring cart response)

## Recommended Usecases
- `GetCart`
- `AddToCart`
- `UpdateCartQty`
- `RemoveFromCart`

## Recommended Repositories
- `CartRepository`

## Pending Tasks
- [ ] Create `CartItem` freezed model mapping the cart response.
- [ ] Implement data layer `CartRemoteDataSource` and `CartRepositoryImpl`.
- [ ] Implement usecases and state notifiers (`cartProvider`).
- [ ] Build Cart layout showing item details, totals, and quantity controls.
