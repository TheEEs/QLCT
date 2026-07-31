# 💸 QLCT — Ứng dụng Quản lý Chi tiêu & Thu nhập Thông minh
> **QLCT (Quản lý Chi tiêu)** là một ứng dụng web hiện đại, tinh gọn và tuyệt đẹp giúp người dùng kiểm soát hoàn toàn tài chính cá nhân. Dự án được phát triển trên nền tảng **Ruby on Rails 8.1**, **Tailwind CSS v4** và **DaisyUI v5** mang lại trải nghiệm mượt mà, phản hồi tức thì như một ứng dụng đơn trang (SPA).

---

## 🌟 Tính năng Nổi bật (Key Features)

### 1. Quản lý Giao dịch Đa năng (Income & Expense Management)
* Cho phép ghi chép nhanh chóng cả **Chi tiêu (Tiền ra 💸)** và **Thu nhập (Tiền vào 💰)**.
* Giao diện form thông minh với bộ chọn phân loại loại giao dịch trực quan, tối ưu cho cả máy tính lẫn điện thoại.
* Tự động gán nhãn, lưu trữ lý do/mục đích giao dịch và thời gian thực hiện chính xác.

### 2. Bảng điều khiển Tài chính Chuyên nghiệp (Interactive Dashboard)
* **Thẻ thống kê tài chính trực quan (3-Column Grid)**: 
  * **Số dư khả dụng (Ước tính)**: Tự động cộng tổng thu nhập, trừ tổng chi tiêu dựa trên hạn mức mặc định.
  * **Tổng thu nhập**: Tổng hợp toàn bộ số tiền thu vào từ trước tới nay.
  * **Tổng chi tiêu**: Thống kê số tiền đã chi ra thời gian thực.
* **Ngân sách tháng (Progress Bars)**: Thanh tiến độ sinh động minh họa rõ nét mức độ sử dụng ngân sách cho từng danh mục (Ăn uống, Di chuyển, Mua sắm).
* **Danh sách giao dịch gần đây**: Hiển thị nhanh 5 giao dịch mới nhất với icon phân loại động và màu sắc sinh động (Xanh cho Thu nhập `+`, Đỏ cho Chi tiêu `-`).

### 3. Phân trang & Sắp xếp Tốc độ cao (Pagy & Turbo Pagination)
* Tích hợp công cụ phân trang siêu nhẹ **Pagy** kết hợp Hotwire **Turbo Frames**. Việc chuyển trang, đổi số lượng hiển thị trên trang (`5, 10, 20, 50, 100` dòng) hay thay đổi tiêu chí sắp xếp (theo ngày, theo số tiền, tăng/giảm dần) đều diễn ra **tức thì mà không cần tải lại toàn bộ trang**.
* **Xử lý tràn trang tự động (Overflow Fallback)**: Ngăn chặn lỗi máy chủ 500 khi người dùng truy cập trang phân trang không tồn tại bằng cách tự động chuyển hướng về trang cuối cùng một cách mượt mà.

### 4. Đa ngôn ngữ Hoàn chỉnh (Bilingual Support - i18n)
* Hỗ trợ đầy đủ song ngữ **Tiếng Việt (🇻🇳)** và **English (🇬🇧)**.
* Giao diện chọn ngôn ngữ tinh tế trên thanh Navbar. Lựa chọn ngôn ngữ được lưu đồng thời trong `local-storage` của trình duyệt và Cookie để đảm bảo trang hiển thị đúng ngôn ngữ ngay từ lần tải đầu tiên (triệt tiêu hiện tượng nhấp nháy dịch thuật).

### 5. Giao diện Sáng/Tối linh hoạt (Light/Dark Theme Persistence)
* Tích hợp bộ chuyển đổi giao diện Sáng/Tối (Light/Dark Theme) của DaisyUI thông qua thư viện `theme-change`.
* Trạng thái giao diện được ghi nhớ tại `local-storage`. Tích hợp mã script chống nhấp nháy sáng (Anti-Flash) trong thẻ `<head>` cho trải nghiệm đồng nhất và dịu mắt.

### 6. Bảo mật & Xác thực Toàn diện (Security & Authentication)
* Cơ chế đăng ký, đăng nhập và quản lý phiên an toàn dựa trên cookie.
* Bảo mật mã hóa mật khẩu một chiều bằng `bcrypt` và cơ chế phân quyền chặt chẽ với `Pundit`.
* Cho phép người dùng đổi mật khẩu an toàn hoặc yêu cầu khôi phục mật khẩu khi quên qua Email.

---

## 🛠️ Công nghệ Sử dụng (Tech Stack)

### Backend
* **Ruby on Rails 8.1.x** (Bản phát hành mới nhất hỗ trợ cấu hình hiện đại).
* **Active Record** kết hợp cơ sở dữ liệu **SQLite** gọn nhẹ, tối ưu.
* **Pundit** (Phân quyền người dùng) & **bcrypt** (Mã hóa bảo mật mật khẩu).
* **Pagy** (Bộ thư viện phân trang hiệu năng cao).

### Frontend
* **Tailwind CSS v4** (Framework CSS tiện ích thế hệ mới nhất).
* **DaisyUI v5** (Thư viện thành phần UI dựa trên Tailwind mang lại giao diện hiện đại và sinh động).
* **Hotwire (Turbo & Stimulus)** (Mang lại trải nghiệm ứng dụng đơn trang SPA mượt mà mà không cần React/Vue phức tạp).
* **propshaft** & **Importmaps** (Hệ thống quản lý asset hiện đại, không cần biên dịch Node.js nặng nề).
* **theme-change** (Thư viện JS quản lý và áp dụng theme).

---

## ⚙️ Hướng dẫn Khởi chạy (Getting Started)

### Yêu cầu hệ thống (System Dependencies)
* **Ruby version**: `>= 3.2.0` (Khuyến nghị sử dụng version chỉ định trong tệp `.ruby-version`).
* **SQLite3** cài đặt sẵn trên hệ điều hành.

### Các bước cài đặt (Setup Instructions)

1. **Tải mã nguồn và cài đặt các thư viện (Gems)**:
   ```bash
   git clone <repo-url>
   cd qlct
   bundle install
   ```

2. **Khởi tạo và thiết lập Cơ sở dữ liệu**:
   *Ứng dụng được tích hợp sẵn tính năng tự động chạy Migrate khi boot (`config/initializers/auto_migrate.rb`), tuy nhiên bạn nên thiết lập ban đầu:*
   ```bash
   bin/rails db:setup
   ```

3. **Chạy ứng dụng trong môi trường phát triển (Development)**:
   Sử dụng lệnh khởi chạy quy trình giám sát CSS Tailwind và khởi động máy chủ Web Puma:
   ```bash
   bin/dev
   ```
   *Truy cập ứng dụng tại địa chỉ: [http://localhost:3000](http://localhost:3000)*

---

## 🧪 Chạy bộ Kiểm thử (How to run the test suite)

Ứng dụng đi kèm bộ kiểm thử tự động toàn diện kiểm tra cả tính đúng đắn của Model lẫn Controller/Integration:
```bash
bin/rails test
```

---

## 📂 Tổ chức Thư mục & Mã nguồn (Architecture & Highlights)

* **`config/initializers/auto_migrate.rb`**: Đảm bảo ứng dụng tự động đồng bộ cấu trúc cơ sở dữ liệu ngay khi khởi chạy mà không cần gọi lệnh terminal thủ công.
* **`app/javascript/controllers/locale_controller.js`**: Stimulus controller chịu trách nhiệm lưu trữ và đồng bộ trạng thái ngôn ngữ qua `localStorage` và `cookies`.
* **`app/views/layouts/application.html.erb`**: Chứa thẻ `<head>` tối ưu hóa SEO và mã script ngăn ngừa "nhấp nháy giao diện" khi tải lại trang cho cả ngôn ngữ lẫn theme sáng tối.
* **`config/locales/`**: Chứa hai tệp từ điển bản địa hóa chuẩn mực song ngữ `vi.yml` và `en.yml` tổ chức theo cấu trúc hình cây phân cấp rõ ràng.

---

## 📝 Bản quyền & Giấy phép (License)
Dự án được phân phối dưới giấy phép **MIT**. Bảo lưu mọi quyền © 2026 QLCT.
