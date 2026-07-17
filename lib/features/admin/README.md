# Admin Feature (Trang quản trị Admin)

## Developer Information
- **Assignee**: Member 4
- **Template Reference**: Reference `lib/features/auth/` for clean architecture implementation.

## Purpose
- FR-12, FR-13, FR-14, FR-15: Provide administrator tools to CRUD products/categories, manage order statuses, create vouchers, and view reports/sales statistics.
- UC-14: Quản lý sản phẩm (CRUD).
- UC-15: Quản lý đơn hàng.
- UC-16: Quản lý khuyến mãi / voucher.
- UC-17: Xem báo cáo / thống kê.

## REST Endpoints
- `POST /products` - Create new product with variants (✅ Admin).
- `PUT /products/{id}` - Edit product information and stock quantity (✅ Admin).
- `DELETE /products/{id}` - Archive or delete a product (✅ Admin).
- `GET /admin/orders` - View list of all orders from all users (✅ Admin).
- `PATCH /admin/orders/{id}` - Approve order packaging, shipment, or verify payment (✅ Admin).
- `GET /admin/vouchers` - List all vouchers (✅ Admin).
- `POST /admin/vouchers` - Create a voucher code (✅ Admin).
- `PUT/DELETE /admin/vouchers/{id}` - Edit or delete voucher (✅ Admin).
- `GET /admin/reports/summary` - Retrieve dashboard analytics, revenue, orders, and cancelled ratios (✅ Admin).

## Dependencies
- `core/network`
- `shared/models/` (`Product`, `ProductVariant`, `Order`, `Voucher`, `Payment`)

## Recommended Core Entities & Models
- `ReportsSummary` (freezed model mapping analytics counts and charts lists)

## Recommended Usecases
- `AdminCreateProduct`
- `AdminEditProduct`
- `AdminGetOrders`
- `AdminUpdateOrderStatus`
- `AdminManageVouchers`
- `AdminGetStats`

## Recommended Repositories
- `AdminRepository`

## Pending Tasks
- [ ] Implement data layer `AdminRemoteDataSource` and `AdminRepositoryImpl`.
- [ ] Setup Usecases and state management (`adminDashboardProvider`, `adminOrdersProvider`).
- [ ] Build Admin Dashboard interface showing basic stats charts.
- [ ] Build product list management UI with create/edit forms.
- [ ] Build orders dashboard filtering by status and updating order milestones.
- [ ] Build vouchers management forms listing active coupons.
