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
- WebView package (e.g., `webview_flutter` if doing online redirects)

## Recommended Core Entities & Models
- `Voucher`
- `Payment`

## Recommended Usecases
- `InitiatePayment`
- `VerifyCoupon`

## Recommended Repositories
- `CheckoutRepository`

## Pending Tasks
- [ ] Implement data layer `CheckoutRemoteDataSource` and `CheckoutRepositoryImpl`.
- [ ] Integrate usecases and state management (`checkoutProvider`).
- [ ] Build Checkout details selection form (delivery address, shipment method, voucher input).
- [ ] Integrate payment web view for redirection to VNPAY/Momo/etc.
