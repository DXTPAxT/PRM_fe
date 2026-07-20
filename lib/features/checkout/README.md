# Checkout Feature (Thanh toán)

## Developer Information
- **Assignee**: Member 3
- **Template Reference**: Reference `lib/features/auth/` for clean architecture implementation.

## Purpose
- FR-06, FR-07: Configure addresses, select transport methods, enter voucher codes, and trigger payment callbacks/webviews.
- UC-09: Đặt hàng (Checkout).
- UC-10: Thanh toán (COD & Online VNPay/Momo/ZaloPay via WebView).

## REST Endpoints
- `POST /payments/{orderId}` - Initialize online payment transaction (✅ JWT).
- `POST /payments/webhook` - Webhook callback from payment gateway (🔑 Signature).

## Dependencies
- `core/network`
- `features/orders`
- `shared/models/` (`Payment`, `Voucher`, `Address`)

## Recommended Core Entities & Models
- `Voucher`
- `Payment`

## Recommended Usecases
- `InitiatePayment`
- `VerifyCoupon`

## Recommended Repositories
- `CheckoutRepository`

## Pending Tasks
- [x] Implement data layer `CheckoutRemoteDataSource` (tạo đơn tái dùng `OrdersRepository`).
- [x] Integrate usecases and state management (`checkoutProvider`).
- [x] Build Checkout details selection form (delivery address, payment method).
- [x] Handle online payment result via simulate-callback dialog.

## Ghi chú triển khai

- Endpoint thanh toán thực tế của BE: `POST /payments/orders/:orderId/simulate-callback`
  — dùng cho MỌI phương thức online (VNPay/MoMo/ZaloPay), không chỉ MoMo/ZaloPay
  như dự kiến ban đầu.
- Luồng: `POST /orders` tạo đơn trước → sau đó mới xử lý thanh toán theo
  `paymentMethod`. COD thì vào thẳng chi tiết đơn.
- **VNPay webview thật đã bị bỏ** (từng dùng `webview_flutter` + endpoint
  `POST /payments/orders/:orderId/vnpay-url`). Lý do: VNPay sandbox gọi IPN/
  Return URL server-to-server, nên backend cần địa chỉ truy cập được từ
  internet — không khả thi khi chạy backend local (`localhost`), kể cả qua
  ngrok free (ngrok chèn trang cảnh báo interstitial trước khi tới backend,
  cả VNPay lẫn webview trong app đều không vượt qua được). Toàn bộ thanh
  toán online giờ dùng `simulate-callback` để demo — xem dialog "Giả lập
  thanh toán" ở `checkout_screen.dart` và `order_detail_screen.dart`.
- Địa chỉ giao hàng tái dùng `addressProvider` của `features/profile`
  (Member 1 sở hữu; M3 chỉ đọc).

## Ngoài phạm vi bản này

- **Voucher**: BE chưa có API list/verify voucher (chỉ có `/vouchers/ping`),
  nên form checkout chưa có ô nhập voucher. Thêm lại khi Member 4 xong.
- **Phí ship GHN**: chưa gửi `toDistrictId`/`toWardCode` vì cần UI dropdown
  tỉnh/quận/phường của GHN. BE fallback `shippingFee = 0` khi thiếu.
