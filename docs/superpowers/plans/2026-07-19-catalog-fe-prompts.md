# Prompt theo session — Catalog Frontend

Chia plan `2026-07-19-catalog-fe.md` thành **6 session**. Mỗi session là một đoạn chat mới với agent.

**Cách dùng:** mở session mới → copy nguyên khối prompt (phần trong khung) → dán vào → để agent chạy tới khi xong → kiểm tra mục "Nghiệm thu" → sang session tiếp theo.

> ⚠️ **Điều kiện tiên quyết:** backend phải chạy xong và có đủ 10 endpoint. Kiểm tra trước bằng:
> ```bash
> curl "http://localhost:3000/api/products?limit=1"
> ```
> Nếu chưa có, làm xong plan BE trước đã.

**Thứ tự bắt buộc.** Session sau phụ thuộc kết quả session trước.

| Session | Task | Nội dung | Ước lượng |
|---|---|---|---|
| 1 | 1 | Sửa model shared sang camelCase | ~20 phút |
| 2 | 2-3 | Data layer + usecases + catalog provider | ~45 phút |
| 3 | 4 | Màn lưới sản phẩm + infinite scroll | ~40 phút |
| 4 | 5 | Bộ lọc + tìm kiếm có debounce | ~40 phút |
| 5 | 6 | Chi tiết sản phẩm + chọn biến thể | ~45 phút |
| 6 | 7 | Đánh giá sản phẩm + nghiệm thu | ~40 phút |

---

## Session 1 — Sửa model

```
Bạn đang làm app Flutter (Riverpod, Clean Architecture) cho đồ án bán quần áo. Tôi là Member 2, phụ trách Product + Search + Review.

Hãy đọc file docs/superpowers/plans/2026-07-19-catalog-fe.md và thực hiện ĐÚNG Task 1, theo từng step một.

Vấn đề đang có: 4 model trong lib/shared/models/ (product, category, product_variant, review) dùng @JsonKey snake_case như 'category_id', 'base_price', 'stock_qty'. Nhưng backend trả camelCase. Không sửa thì mọi lời gọi API đều parse fail.

Member 1 đã sửa user.dart và address.dart sang camelCase rồi — làm theo đúng kiểu đó.

Đã kiểm tra: chưa file nào import 4 model này, nên sửa an toàn.

Ràng buộc:
- KHÔNG sửa lib/features/auth/, lib/features/profile/ — của Member 1
- KHÔNG thêm dependency vào pubspec.yaml
- Sau khi sửa model PHẢI chạy: dart run build_runner build --delete-conflicting-outputs

Xong thì chạy flutter analyze lib/shared/models và báo cáo kết quả.
```

**Nghiệm thu session 1:**
- `dart run build_runner build --delete-conflicting-outputs` chạy xong, không có dòng `[SEVERE]`
- `flutter analyze lib/shared/models` → `No issues found!`
- File `lib/shared/models/product_image.dart` đã được tạo
- Grep `@JsonKey` trong 4 file model đó → không còn kết quả nào

---

## Session 2 — Data layer + provider

```
Tiếp tục app Flutter cho đồ án bán quần áo. Tôi là Member 2.

Session trước đã sửa xong model trong lib/shared/models/ sang camelCase và chạy build_runner.

Hãy đọc docs/superpowers/plans/2026-07-19-catalog-fe.md và thực hiện ĐÚNG Task 2 và Task 3, theo từng step một.

Task 2: tầng data — ProductQuery (object lọc bất biến), CatalogRemoteDataSource, CatalogRepository + implementation.
Task 3: 5 usecase + catalog_provider.dart (state danh sách sản phẩm, lọc, phân trang).

Bám đúng khuôn mẫu có sẵn của Member 1:
- lib/features/auth/data/repositories/auth_repository_impl.dart — repository ném Exception(message), KHÔNG dùng Either hay dartz
- lib/features/profile/presentation/providers/address_provider.dart — StateNotifier + State class tự viết có copyWith, KHÔNG dùng AsyncNotifier, KHÔNG dùng codegen Riverpod

Ràng buộc:
- KHÔNG sửa lib/features/auth/, lib/features/profile/ — chỉ được ĐỌC dioClientProvider từ auth_provider.dart
- KHÔNG gọi API /cart, /wishlist, /orders — không thuộc phần của tôi
- KHÔNG thêm dependency vào pubspec.yaml
- ProductQuery.toQueryParameters() phải bỏ hẳn key có giá trị null, vì backend bật forbidNonWhitelisted sẽ trả 400 nếu nhận key rỗng

Xong thì chạy flutter analyze lib/features/catalog và báo cáo.
```

**Nghiệm thu session 2:**
- `flutter analyze lib/features/catalog` → `No issues found!`
- Có đủ file: `product_query.dart`, `catalog_remote_data_source.dart`, `catalog_repository.dart`, `catalog_repository_impl.dart`, 5 usecase, `catalog_provider.dart`
- Grep `dartz` hoặc `Either` trong `lib/features/catalog/` → không có kết quả

---

## Session 3 — Màn lưới sản phẩm

```
Tiếp tục app Flutter cho đồ án bán quần áo. Tôi là Member 2.

Đã xong: model camelCase (Task 1), tầng data + catalogProvider (Task 2-3).

Hãy đọc docs/superpowers/plans/2026-07-19-catalog-fe.md và thực hiện ĐÚNG Task 4, theo từng step một.

Task 4: widget ProductCard và thay toàn bộ catalog_screen.dart (hiện đang là màn "Coming Soon") bằng lưới 2 cột có infinite scroll và pull-to-refresh.

Ràng buộc:
- KHÔNG thêm dependency vào pubspec.yaml. Dự án KHÔNG có cached_network_image — dùng Image.network kèm loadingBuilder và errorBuilder.
- Tái sử dụng widget có sẵn ở lib/core/widgets/common_widgets.dart: LoadingIndicator, EmptyStateWidget, ErrorStateWidget. Đừng viết lại.
- Khoảng cách dùng hằng AppTheme.spaceS / spaceM / spaceL từ lib/core/theme/app_theme.dart
- KHÔNG sửa lib/core/ ở task này
- Text hiển thị viết tiếng Việt có dấu

Backend phải đang chạy. Ở Step 3 hãy chạy app thật trên emulator và mô tả cho tôi những gì bạn thấy trên màn hình. Nếu lưới trống mà log Dio báo lỗi parse thì quay lại kiểm tra model ở Task 1.
```

**Nghiệm thu session 3:**
- Chạy app, mở tab "Danh mục" → hiện lưới 2 cột với **4 sản phẩm seed**, có ảnh
- Giá hiển thị dạng `250.000 ₫`
- Hàng chip danh mục ở trên, bấm chip lọc được
- `flutter analyze lib/features/catalog` → `No issues found!`

---

## Session 4 — Bộ lọc + tìm kiếm

```
Tiếp tục app Flutter cho đồ án bán quần áo. Tôi là Member 2.

Đã xong Task 1 đến Task 4 — màn lưới sản phẩm đã chạy và hiện đủ 4 sản phẩm seed.

Hãy đọc docs/superpowers/plans/2026-07-19-catalog-fe.md và thực hiện ĐÚNG Task 5, theo từng step một.

Task 5: filter_bottom_sheet.dart (khoảng giá, size, màu, sắp xếp) và search_screen.dart (tìm kiếm có debounce 400ms), rồi nối 2 nút vào AppBar của catalog_screen.

Lưu ý: danh sách size và màu HARDCODE thành hằng số trong file filter_bottom_sheet.dart. Backend không có endpoint trả danh sách size/màu đang tồn tại, và tôi không muốn thêm endpoint đó. Đừng tự ý gọi API để lấy.

Debounce phải dùng Timer từ dart:async, hủy timer cũ mỗi lần gõ. Không được bắn request theo từng ký tự.

Ràng buộc:
- KHÔNG thêm dependency vào pubspec.yaml
- KHÔNG sửa lib/core/ ở task này
- Màn search mở bằng Navigator.push với MaterialPageRoute, KHÔNG thêm route vào go_router

Ở Step 4 hãy chạy app thật và kiểm tra đủ 4 tình huống trong plan, rồi mô tả kết quả cho tôi.
```

**Nghiệm thu session 4:**
- Bấm icon lọc → đặt giá `200000`–`400000` → Áp dụng → lưới lọc lại, icon lọc có **chấm đỏ**
- Bấm "Xóa lọc" → về đủ 4 sản phẩm, chấm đỏ biến mất
- Bấm icon search → gõ `áo` → kết quả hiện sau ~0.4 giây
- Log Dio cho thấy **một** request sau khi gõ xong, không phải mỗi ký tự một request

---

## Session 5 — Chi tiết sản phẩm

```
Tiếp tục app Flutter cho đồ án bán quần áo. Tôi là Member 2.

Đã xong Task 1 đến Task 5 — lưới sản phẩm, bộ lọc và tìm kiếm đều chạy.

Hãy đọc docs/superpowers/plans/2026-07-19-catalog-fe.md và thực hiện ĐÚNG Task 6, theo từng step một.

Task 6: product_detail_provider, variant_selector, product_detail_screen, thêm route và nối điều hướng từ card.

ĐÂY LÀ TASK DUY NHẤT ĐƯỢC SỬA lib/core/ — chỉ thêm route '/products/:id' vào app_router.dart, đặt ở cấp top-level NGAY TRƯỚC StatefulShellRoute (để màn chi tiết che bottom nav). Không được sửa gì khác trong core/.

Logic chọn biến thể:
- Chọn size trước, danh sách màu lọc lại theo size đó
- Đổi size thì phải BỎ CHỌN màu đang chọn, vì màu cũ có thể không tồn tại với size mới
- Chỉ khi chọn đủ cả size và màu mới hiện khối giá + tồn kho + SKU

Nút "Thêm vào giỏ" phải để onPressed: null (disabled) kèm Tooltip ghi rõ đây là chức năng của Member 3. Giỏ hàng KHÔNG thuộc phần của tôi — tuyệt đối không gọi API /cart.

Ràng buộc:
- KHÔNG thêm dependency vào pubspec.yaml
- KHÔNG sửa lib/features/auth/, lib/features/profile/, lib/features/cart/

Ở Step 6 hãy chạy app thật, kiểm tra đủ 5 tình huống trong plan và mô tả kết quả.
```

**Nghiệm thu session 5:**
- Bấm sản phẩm → mở chi tiết full màn, **không thấy bottom nav**
- Chọn size `M` → danh sách màu lọc lại
- Chọn màu → hiện giá, tồn kho, SKU của đúng biến thể
- Đổi sang size khác → màu bị bỏ chọn, khối giá biến mất
- Nút "Thêm vào giỏ" xám, giữ lâu hiện tooltip
- `git diff lib/core/` chỉ cho thấy route `/products/:id` được thêm

> Sau session này nhớ **báo Member 1 và leader** rằng bạn đã thêm route vào `core/router/app_router.dart` — theo quy ước mục 7 của CONTRIBUTING.

---

## Session 6 — Đánh giá sản phẩm

```
Tiếp tục app Flutter cho đồ án bán quần áo. Tôi là Member 2. Đây là session cuối.

Đã xong Task 1 đến Task 6 — lưới, lọc, tìm kiếm, chi tiết sản phẩm đều chạy.

Hãy đọc docs/superpowers/plans/2026-07-19-catalog-fe.md và thực hiện ĐÚNG Task 7, theo từng step một.

Task 7: review_provider, review_list, review_form_sheet, và gắn khu đánh giá vào cuối màn chi tiết sản phẩm.

Luồng quan trọng: backend có ràng buộc mỗi user chỉ đánh giá một sản phẩm một lần. Khi tải danh sách đánh giá, tìm xem có review nào của user hiện tại không (so userId với authProvider.user.id) và lưu vào myReview. Nếu có thì nút đổi từ "Viết đánh giá" thành "Sửa đánh giá", và form gọi PATCH thay vì POST.

Ràng buộc:
- KHÔNG sửa lib/features/auth/ — chỉ ĐỌC authProvider để lấy user.id
- KHÔNG thêm dependency vào pubspec.yaml
- KHÔNG sửa lib/core/ ở task này

Ở Step 5 hãy chạy app thật và kiểm tra đủ 4 tình huống trong plan.

Cuối cùng chạy hết checklist "Nghiệm thu cuối" ở cuối file plan và báo cáo từng mục đạt hay không đạt. Nếu mục nào không đạt thì nói rõ, đừng bỏ qua và đừng báo cáo là xong khi chưa thật sự xong.
```

**Nghiệm thu session 6 (cũng là nghiệm thu toàn bộ FE):**
- `flutter analyze` toàn bộ `lib/` không lỗi
- Gửi đánh giá 4 sao → hiện trong danh sách, nút đổi thành "Sửa đánh giá"
- Bấm "Sửa đánh giá" → form hiện lại đúng 4 sao và nhận xét cũ
- Đổi thành 5 sao → Cập nhật → danh sách cập nhật
- `git diff lib/core/` chỉ có route `/products/:id`

---

## Session 8 — Dọn lint và commit test còn sót (sau khi Session 6 "xong")

> Review lại toàn bộ code Task 1-7: không có bug logic, `lib/core/` chỉ đổi đúng 7 dòng, không đụng phần của M1/M3/M4. Agent tự thêm 3 file test Flutter (task5/6/7_test.dart) ngoài kế hoạch — đã kiểm tra chất lượng tốt (test thật qua UI, không phải test rác), quyết định giữ lại. Còn 2 việc lặt vặt: 1 file test chưa commit, 3 lỗi lint nhỏ.

```
Tiếp tục app Flutter cho đồ án bán quần áo. Tôi là Member 2. Review lại code đã xong, còn 2 việc dọn dẹp nhỏ.

Việc 1 — Sửa 3 lỗi lint trong test/features/catalog/task7_test.dart:
- Dòng 4: import review_provider.dart không dùng tới — xóa dòng import đó
- Dòng 6: import review_form_sheet.dart không dùng tới — xóa dòng import đó
- Dòng 157: biến final có thể khai báo const — đổi `final fakeUser = const User(...)` thành `const fakeUser = User(...)`

Chạy: flutter analyze
Expected: No issues found!

Việc 2 — Commit file test còn sót: test/features/catalog/task5_test.dart hiện đang untracked (chưa commit).

Chạy:
flutter test
Expected: tất cả pass, không lỗi.

git add test/features/catalog/task5_test.dart test/features/catalog/task7_test.dart
git commit -m "test(catalog): fix lint issues and commit filter/search tests"

Báo cáo cho tôi: flutter analyze có sạch không, flutter test có pass hết không, và git log --oneline -3 để xác nhận commit.
```

**Nghiệm thu session 8:**
- `flutter analyze` → `No issues found!`
- `flutter test` → tất cả pass
- `git status` → sạch, không còn file untracked trong `test/`

---

## Khi agent làm sai

| Triệu chứng | Nguyên nhân thường gặp | Cách sửa |
|---|---|---|
| Lưới trống, log Dio báo lỗi parse | Model còn `@JsonKey` snake_case | Quay lại Task 1, chạy lại build_runner |
| Lỗi build về file `.freezed.dart` | Quên chạy build_runner sau khi sửa model | `dart run build_runner build --delete-conflicting-outputs` |
| API trả 400 khi lọc | `toQueryParameters()` gửi key có giá trị null | Kiểm tra các mệnh đề `if (x != null)` |
| Agent thêm `cached_network_image` | Tự ý thêm dependency | Hoàn tác `pubspec.yaml`, dùng `Image.network` |
| Agent dùng `AsyncNotifier` hoặc codegen | Không bám khuôn mẫu M1 | Bắt viết lại theo `address_provider.dart` |
| Màn chi tiết vẫn thấy bottom nav | Route đặt bên trong `StatefulShellRoute` | Chuyển ra cấp top-level |
| Agent tự làm thêm giỏ hàng | Lấn phần Member 3 | Hoàn tác, nút "Thêm vào giỏ" phải disabled |
| Đổi size mà màu vẫn giữ nguyên | Quên `clearColor: true` trong `selectSize` | Sửa `product_detail_provider.dart` |
