# Catalog Feature (Danh mục & Sản phẩm)

## Developer Information
- **Assignee**: Member 2
- **Template Reference**: Reference the complete implementation of the Auth feature in `lib/features/auth/` for clean architecture layout.

## Purpose
- FR-02, FR-03: Browse categories structure, list products, filter and search products, view details and variants, view reviews.
- UC-04: Duyệt danh mục & sản phẩm.
- UC-05: Tìm kiếm & lọc sản phẩm.
- UC-06: Xem chi tiết sản phẩm.

## REST Endpoints
- `GET /categories` - Get list of product categories (❌ Public).
- `GET /products` - Get paginated list of products with filters, sorting, and search (❌ Public).
- `GET /products/{id}` - Get detailed information of a single product with variants (❌ Public).
- `GET /products/{id}/reviews` - Get reviews list of a product (❌ Public).

## Dependencies
- `core/network` (`DioClient`, `ApiResponse`, `PagedResponse`, `PaginationMeta`)
- `core/storage` (`HiveCache` - to cache categories list and home products list)
- `shared/models/` (`Category`, `Product`, `ProductVariant`, `Review`)

## Recommended Core Entities & Models
- `Category`
- `Product`
- `ProductVariant`
- `Review`

## Recommended Usecases
- `GetCategories`
- `GetProducts`
- `GetProductDetails`
- `SearchProducts`

## Recommended Repositories
- `CatalogRepository`

## Pending Tasks
- [ ] Implement data layer `CatalogRemoteDataSource` and `CatalogRepositoryImpl`.
- [ ] Implement domain layer usecases (`GetCategories`, `GetProducts`, etc.).
- [ ] Setup Riverpod providers (`catalogProvider`, `productDetailsProvider`).
- [ ] Create search and filter bottom sheet inputs.
- [ ] Build product list grid layout & infinite scroll paging.
- [ ] Build product details UI (Variant selector for Size + Color).
