# Clothing Store App (FE - Client)

Ứng dụng di động bán quần áo được xây dựng bằng **Flutter (Material 3)** dành cho cả khách hàng (Customer) và quản trị viên (Admin). Dự án được thiết kế dưới dạng khung sườn (scaffold) chuẩn để hỗ trợ 4 lập trình viên làm việc song song mà không bị xung đột.

---

## 1. Hướng Dẫn Cài Đặt & Chạy Dự Án

### Bước 1: Tải các gói thư viện
Chạy lệnh sau tại thư mục gốc của frontend (`FE/`) để cài đặt các package:
```bash
flutter pub get
```

### Bước 2: Sinh mã tự động (Code Generation)
Dự án sử dụng thư viện **Freezed** và **JsonSerializable** để tự động tạo các model serialization và immutable entities. Chạy lệnh sau để tạo file:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Bước 3: Chạy ứng dụng trên Emulator / Thiết bị thật
Để ứng dụng kết nối tới Backend, bạn cần truyền biến môi trường qua `--dart-define`.
- **Chạy trên Android Emulator** (Mặc định trỏ về BE local):
  ```bash
  flutter run
  ```
- **Chạy tùy biến URL backend**:
  ```bash
  flutter run --dart-define=API_BASE_URL=http://<YOUR_IP>:3000/api
  ```

---

## 2. Kiến Trúc Dự Án (Clean Architecture)

Mỗi feature được thiết kế độc lập và chia làm 3 tầng:

1. **Data Layer** (`data/`):
   - `models/`: Chứa các Request/Response data model (Immutable bằng Freezed).
   - `datasources/`: Nhận instance của `DioClient` để call HTTP requests.
   - `repositories/`: Triển khai interface repository từ Domain layer và xử lý chuyển đổi lỗi sang `Failure` entity.
2. **Domain Layer** (`domain/`):
   - `entities/`: Chứa core logic models dùng cho Business Rules.
   - `repositories/`: Khai báo interface (contract) của repository.
   - `usecases/`: Mỗi nghiệp vụ cụ thể sẽ là 1 class Usecase riêng (ví dụ: `LoginUseCase`, `ForgotPasswordUseCase`).
3. **Presentation Layer** (`presentation/`):
   - `screens/`: Chứa các UI widget (Screens) dùng Material 3.
   - `providers/`: StateNotifier & Providers của Riverpod chịu trách nhiệm quản lý trạng thái hiển thị UI và gọi Usecases.

---

## 3. Phân Công Thành Viên & Tích Hợp Tab

Ứng dụng sử dụng thanh điều hướng dưới **Bottom Navigation (5 tabs)**, được điều hướng qua `GoRouter` (`lib/core/router/app_router.dart`):

| Tab Index | Tên Tab | Feature Folder | Chức Năng Chính | Người Phụ Trách |
| :--- | :--- | :--- | :--- | :--- |
| **0** | Trang chủ | `features/auth` (Home) | Banner, sản phẩm nổi bật | **Scaffold (Done)** |
| **1** | Danh mục | `features/catalog` | Duyệt danh mục, Tìm kiếm, Lọc | **Member 2** |
| **2** | Giỏ hàng | `features/cart` | Thêm, sửa, xóa sản phẩm giỏ hàng | **Member 3** |
| **3** | Đơn hàng | `features/orders` | Theo dõi đơn, Timeline, Đánh giá | **Member 3** |
| **4** | Tài khoản | `features/profile` | Sổ địa chỉ, Wishlist, Đăng xuất | **Member 1** |

> [!IMPORTANT]
> **Admin Panel**: Màn hình quản lý cho người bán nằm trong `features/admin/`. Lối vào (Admin Panel Entrypoint) chỉ hiển thị trên Tab **Tài khoản** nếu user đăng nhập có `role == 'admin'` (đã cấu hình mẫu trong `ProfileScreen`). Trách nhiệm phát triển thuộc về **Member 4**.

---

## 4. Quy Ước Viết Code & Quy Trình Tạo Feature Mới

Để tạo một feature mới, hãy làm theo các bước sau dựa trên khuôn mẫu **Auth** (`lib/features/auth`):

1. **Tạo cấu trúc thư mục**: Tạo đầy đủ folder `data`, `domain`, `presentation` trong feature của bạn.
2. **Khai báo model**: Tạo các model request/response trong folder `data/models/` với cú pháp Freezed.
3. **Chạy build_runner**: Để tự động biên dịch sinh file `.freezed.dart` và `.g.dart`.
4. **Viết Data Source & Repository**: Thực hiện gọi API thông qua `DioClient` (nằm trong `core/network/`). Gắn Bearer Token tự động thông qua Interceptor.
5. **Viết Usecases**: Tách biệt logic nghiệp vụ khỏi UI.
6. **Quản lý State**: Khai báo Provider dùng Riverpod để giữ trạng thái màn hình.
7. **Tích hợp Route**: Mở `lib/core/router/app_router.dart` để thay thế màn hình placeholder sang màn hình chính thức của bạn.
