# Hướng dẫn triển khai HRBP – TNA AI Application

Folder này chứa toàn bộ file tĩnh cần thiết để có: (1) link web chuyên nghiệp không hiện tên Claude, và (2) bảng "Kết quả trực tiếp" tự cập nhật khi có người nộp khảo sát.

Có 2 bước, làm theo thứ tự: **Bước A (Supabase)** trước, rồi **Bước B (Vercel)**.

---

## Bước A — Tạo nơi lưu trữ câu trả lời (Supabase, miễn phí)

1. Vào **https://supabase.com** → **Start your project** → đăng nhập bằng Google hoặc GitHub.
2. Bấm **New project**. Đặt tên tuỳ ý (vd `hrbp-tna`), chọn mật khẩu database bất kỳ, chọn vùng gần (Singapore), bấm **Create project**. Chờ khoảng 1–2 phút để project khởi tạo xong.
3. Vào menu bên trái → **SQL Editor** → **New query**. Mở file `supabase_schema.sql` (đi kèm trong folder này), copy toàn bộ nội dung, dán vào, bấm **Run**. Việc này tạo bảng `tna_responses` để lưu câu trả lời.
4. Vào menu bên trái → **Project Settings** (biểu tượng bánh răng) → **API**. Bạn sẽ thấy 2 giá trị cần copy:
   - **Project URL** — dạng `https://xxxxxxxxxxxx.supabase.co`
   - **anon public** key — một chuỗi ký tự dài (API keys section)
5. Mở file `config.js` trong folder này, thay 2 dòng:
   ```js
   window.TNA_SUPABASE_URL = "https://xxxxxxxxxxxx.supabase.co";
   window.TNA_SUPABASE_ANON_KEY = "dán-anon-key-vào-đây";
   ```
6. Lưu file lại. Xong Bước A.

> **Lưu ý bảo mật:** `anon key` được thiết kế để công khai trong code phía trình duyệt (đây là cách Supabase hoạt động bình thường), nhưng vì Bước A cho phép đọc/ghi công khai vào bảng, chỉ nên chia sẻ link khảo sát/kết quả trong nội bộ đội ngũ dự kiến — không đăng công khai rộng rãi.

---

## Bước B — Đưa lên Vercel để có link web riêng

1. Vào **https://vercel.com** → **Sign Up** → đăng nhập bằng Google hoặc GitHub (không cần thẻ tín dụng, gói miễn phí là đủ dùng).
2. Sau khi vào Dashboard, bấm **Add New...** → **Project**.
3. Chọn tab **Deploy without Git** / kéo-thả cả **folder `vercel-deploy` này** (chứa `index.html`, `survey-vi.html`, `survey-en.html`, `results.html`, `config.js`) vào khung upload. (Nếu Vercel yêu cầu nén file, hãy nén cả folder thành `.zip` rồi tải lên.)
4. Đặt **Project Name** thành `hrbp-tna-ai-application` (hoặc tên bạn muốn) — đây sẽ là tên hiển thị trong URL.
5. Bấm **Deploy**. Chờ khoảng 30 giây.
6. Xong! Link của bạn sẽ có dạng:
   ```
   https://hrbp-tna-ai-application.vercel.app
   ```
   (nếu tên đã có người dùng, Vercel sẽ tự thêm hậu tố, bạn có thể đổi tên project trong **Settings → General → Project Name** để chỉnh lại domain.)

7. Gửi link này cho HRBP team là xong. Trang chủ (`index.html`) sẽ có 3 lựa chọn: khảo sát tiếng Việt, khảo sát tiếng Anh, và kết quả trực tiếp.

---

## Cập nhật sau này

Mỗi khi bạn sửa nội dung khảo sát (thêm câu hỏi, đổi wording...), chỉ cần vào lại Vercel Dashboard → project này → **Deployments** → **Redeploy**, rồi tải lại folder đã cập nhật (hoặc kết nối với GitHub để tự động deploy mỗi lần đổi file — nâng cao hơn, có thể làm sau).

## Nếu trang "Kết quả trực tiếp" báo lỗi chưa kết nối

- Kiểm tra lại `config.js` đã điền đúng URL + anon key chưa (không còn chữ `YOUR-PROJECT-REF`).
- Kiểm tra đã chạy `supabase_schema.sql` trong SQL Editor chưa (bảng `tna_responses` phải tồn tại trong **Table Editor**).
- Thử nộp thử 1 câu trả lời từ `survey-vi.html`, sau đó mở `results.html` — số "Tổng phản hồi" phải tăng lên trong vòng 6 giây.
