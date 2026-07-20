# Member 3 Frontend — Cart + Checkout + Order + Payment

Ngày: 2026-07-20 · Người phụ trách: Member 3 · Stack: Flutter (Riverpod, Clean Architecture)

## Mục tiêu

Hoàn thiện frontend cho 3 feature của Member 3, wire vào backend NestJS đã có sẵn (đã kiểm tra đầy đủ, `tsc` sạch):
- **Cart** (Tab 2): quản lý giỏ hàng.
- **Checkout**: đặt hàng + thanh toán.
- **Orders** (Tab 3): lịch sử đơn, chi tiết + timeline, hủy đơn, đánh giá.

Mirror pattern của `features/catalog` (Member 2 đã hoàn thiện).

## Quyết định đã chốt

- **Thanh toán online**: VNPay webview thật (`webview_flutter`). Momo/ZaloPay dùng `simulate-callback` (chưa có cổng thật). COD điều hướng thẳng sang order detail.
- **Review**: viết riêng trong `features/orders`, KHÔNG phụ thuộc chéo sang catalog.
- **Voucher**: BỎ ở bản này (BE chưa có API list/verify voucher — chỉ có `/vouchers/ping`). Thêm lại khi Member 4 có API.
- **Address**: tái dùng `addressProvider` của `features/profile` (Member 1) — M3 chỉ đọc.

## API contract (đã xác minh từ BE)

### Cart
- `GET /cart` → `{ id, updatedAt, items: [{ id, quantity, variant{id,size,color,price,stockQty,sku}, product{id,name,status,image}, lineTotal }], subtotal }`
- `POST /cart/items` body `{ variantId, quantity }` → cart
- `PATCH /cart/items/:itemId` body `{ quantity }` → cart
- `DELETE /cart/items/:itemId` → cart
- `DELETE /cart` → cart (empty)

### Orders
- `POST /orders` body `{ addressId, paymentMethod, voucherId?, toDistrictId?, toWardCode? }` → OrderDetail
- `GET /orders?status=&page=&limit=` → `{ data: OrderDetail[], meta{page,limit,total,totalPages} }`
- `GET /orders/:id` → OrderDetail
- `PATCH /orders/:id/cancel` → OrderDetail
- `POST /reviews` body `{ productId, rating, comment? }` → Review

OrderDetail shape (ORDER_DETAIL_SELECT):
`{ id, userId, addressId, voucherId, subtotal, discount, shippingFee, total, status, shippingCode, createdAt, updatedAt, address{id,fullName,phone,detail}, items:[{id,quantity,unitPrice,variant{id,size,color,sku,product{id,name}}}], payment{id,method,status,amount,paidAt} }`

OrderStatus: `pending_payment → confirmed → packed → shipping → delivered → completed` (rẽ nhánh `cancelled`).
PaymentMethod: `cod | vnpay | momo | zalopay`. PaymentStatus: `pending | paid | failed | refunded`.

### Payments
- `POST /payments/orders/:orderId/vnpay-url` → `{ paymentUrl }`
- `POST /payments/orders/:orderId/simulate-callback` body `{ result: 'paid'|'failed', txnRef? }` → payment
- `GET /payments/orders/:orderId` → payment

## Kiến trúc

Mỗi feature theo 3 tầng (data / domain / presentation), mirror `catalog`.

### features/cart
- `data/models/cart_response.dart` — freezed: CartResponse, CartLineItem, CartVariant, CartProduct.
- `data/datasources/cart_remote_data_source.dart`
- `data/repositories/cart_repository_impl.dart` + `domain/repositories/cart_repository.dart`
- `domain/usecases/`: GetCart, AddToCart, UpdateCartQty, RemoveFromCart, ClearCart
- `presentation/providers/cart_provider.dart` — CartState + CartNotifier, reload sau mỗi mutation
- `presentation/screens/cart_screen.dart` — list + stepper + xoá + subtotal + nút Thanh toán
- `presentation/widgets/cart_item_tile.dart`

### features/orders (data/domain build TRƯỚC checkout vì checkout phụ thuộc)
- `data/models/order_detail.dart` — freezed: OrderDetail, OrderAddress, OrderLineItem, OrderLineVariant, OrderLineProduct, OrderPayment.
- `data/datasources/orders_remote_data_source.dart` — createOrder, getOrders, getOrderDetail, cancelOrder, createReview
- `data/repositories/orders_repository_impl.dart` + `domain/repositories/orders_repository.dart`
- `domain/usecases/`: CreateOrder, GetOrdersList, GetOrderDetail, CancelOrder, SubmitReview
- `presentation/providers/orders_provider.dart` (list theo status + phân trang), `order_detail_provider.dart`
- `presentation/screens/orders_screen.dart` (TabBar 5 tab), `order_detail_screen.dart` (timeline)
- `presentation/widgets/order_card.dart`, `order_status_timeline.dart`, `review_form_dialog.dart`

### features/checkout
- `data/datasources/checkout_remote_data_source.dart` — getVnpayUrl, simulatePayment (createOrder tái dùng ordersRepository)
- `presentation/providers/checkout_provider.dart` — selectedAddressId, paymentMethod, isSubmitting
- `presentation/screens/checkout_screen.dart` — tóm tắt cart + chọn address (addressProvider) + chọn payment + đặt hàng
- `presentation/screens/vnpay_webview_screen.dart` — webview_flutter, bắt Return URL

### Router (app_router.dart)
- `/checkout` (ngoài shell)
- `/orders/:id` (chi tiết đơn, ngoài shell)
- VNPay webview mở bằng Navigator.push trực tiếp.

### Dependency mới
- `webview_flutter`

## Xử lý lỗi
- Repository ném `Exception(message)` (theo pattern catalog); Notifier bắt và set `errorMessage`.
- UI dùng `LoadingIndicator`, `EmptyStateWidget`, `ErrorStateWidget` có sẵn trong core/widgets.
- Cart stepper: kiểm `stockQty` phía FE trước khi gọi API; BE cũng validate lần nữa.

## Thứ tự triển khai
1. Cart (độc lập)
2. Orders data/domain (checkout phụ thuộc)
3. Checkout
4. Orders presentation
5. Router + webview_flutter + build_runner + kiểm thử

## Ngoài phạm vi (ghi rõ)
- Voucher discount (Member 4).
- GHN district/ward dropdown ở checkout — bản này gửi order KHÔNG kèm toDistrictId/toWardCode (shippingFee = 0, BE fallback). Thêm sau khi có UI chọn tỉnh/quận/phường GHN.
- Admin order management (Member 4).
