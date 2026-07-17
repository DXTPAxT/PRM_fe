# Wishlist Feature (Danh sách yêu thích)

## Developer Information
- **Assignee**: Member 1
- **Template Reference**: Reference `lib/features/auth/` for clean architecture implementation.

## Purpose
- FR-05: Save favorite clothing items for future purchases.
- UC-08: Quản lý danh sách yêu thích (Wishlist).

## REST Endpoints
- `GET /wishlist` - Get wishlist items (✅ JWT).
- `POST /wishlist` - Add a product to wishlist (✅ JWT).
- `DELETE /wishlist/{productId}` - Remove a product from wishlist (✅ JWT).

## Dependencies
- `core/network`
- `shared/models/` (`Product`)

## Recommended Core Entities & Models
- `Product` (reused from catalog)

## Recommended Usecases
- `GetWishlist`
- `ToggleFavorite`

## Recommended Repositories
- `WishlistRepository`

## Pending Tasks
- [ ] Implement data layer `WishlistRemoteDataSource` and `WishlistRepositoryImpl`.
- [ ] Implement usecases and state notifiers (`wishlistProvider`).
- [ ] Build Favorite Grid UI layout.
