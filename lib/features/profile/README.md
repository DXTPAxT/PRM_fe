# Profile Feature (Hồ sơ & Địa chỉ)

## Developer Information
- **Assignee**: Member 1
- **Template Reference**: Reference `lib/features/auth/` for clean architecture implementation.

## Purpose
- FR-11: Manage user details, update profile information, change passwords, and configure delivery address books.
- UC-13: Quản lý hồ sơ & địa chỉ.

## REST Endpoints
- `GET /profile` - Retrieve user profile details (✅ JWT).
- `PUT /profile` - Update profile information (✅ JWT).
- `GET /addresses` - Get address book entries (✅ JWT).
- `POST /addresses` - Create a delivery address (✅ JWT).
- `PUT /addresses/{id}` - Edit a delivery address (✅ JWT).
- `DELETE /addresses/{id}` - Delete a delivery address (✅ JWT).

## Dependencies
- `core/network`
- `core/storage` (Hive cache for profile display offline)
- `shared/models/` (`User`, `Address`)

## Recommended Core Entities & Models
- `User`
- `Address`

## Recommended Usecases
- `GetAddresses`
- `SaveAddress`
- `DeleteAddress`
- `GetProfile`
- `UpdateProfile`

## Recommended Repositories
- `ProfileRepository`

## Pending Tasks
- [ ] Implement data layer `ProfileRemoteDataSource` and `ProfileRepositoryImpl`.
- [ ] Implement usecases and state management (`profileProvider`, `addressBookProvider`).
- [ ] Build Profile screen layouts (showing edit profile, password resets).
- [ ] Build Address Book CRUD forms list.
