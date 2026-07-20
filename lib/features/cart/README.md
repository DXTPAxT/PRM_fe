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
- [x] Create `CartItem` freezed model mapping the cart response.
- [x] Implement data layer `CartRemoteDataSource` and `CartRepositoryImpl`.
- [x] Implement usecases and state notifiers (`cartProvider`).
- [x] Build Cart layout showing item details, totals, and quantity controls.

## Ghi chú triển khai

- Endpoint thực tế của BE khác README gốc: thêm/sửa/xóa item dùng
  `POST /cart/items`, `PATCH /cart/items/:itemId`, `DELETE /cart/items/:itemId`,
  ngoài ra có `DELETE /cart` để xóa sạch giỏ.
- Model đặt trong `data/models/cart_response.dart` (`CartResponse`,
  `CartLineItem`, `CartVariant`, `CartProduct`) — mirror đúng
  `CartService.toResponse()` của BE, gồm cả `lineTotal` và `subtotal` tính sẵn.
- `cartItemCountProvider` cấp số lượng cho badge trên bottom navigation.
- Nút "Thêm vào giỏ" ở `catalog/product_detail_screen.dart` đã được nối vào
  `cartProvider.addItem()` (trước đó Member 2 để disabled).
