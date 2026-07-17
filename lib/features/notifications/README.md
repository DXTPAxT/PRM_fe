# Notifications Feature (Thông báo)

## Developer Information
- **Assignee**: Member 1
- **Template Reference**: Reference `lib/features/auth/` for clean architecture implementation.

## Purpose
- FR-10: Display lists of historical notifications (order changes, promotions).
- Integrate background FCM push notifications configured in the core module.

## REST Endpoints
- None (Push message notifications list is stored locally or fetched from user's logs if any endpoint is added later).

## Dependencies
- `core/notifications` (`NotificationService`)

## Recommended Core Entities & Models
- `NotificationItem` (freezed model tracking fields like id, title, body, timestamp, data)

## Pending Tasks
- [ ] Create `NotificationItem` model.
- [ ] Connect notification clicking routes to GoRouter navigations.
- [ ] Build Notifications listing page UI.
