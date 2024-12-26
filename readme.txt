Nhóm 12:
- 21520932 Phạm Phước Huy
- 21521411 Trần Văn Thanh Tâm

Chủ đề: Ứng dụng review nhà hàng

Các bước cài đặt:
1. Tạo project Supabase tại trang supabase.com
2. Tạo các bảng chứa dữ liệu bằng cách chạy file Restaurant-Review/backend/SQL/create_table.sql
3. Tạo các hàm xử lí bằng cách chạy các file basic_query_tabe.sql complex_queries.sql remove_functions.sql upsert_functions.sql trong thư mục Restaurant-Review/backend/SQL/
4. Tạo ảnh mẫu bằng cách upload các ảnh trong brands, menus, posts, restaurants thuộc folder Restaurant-Review/backend/Sample
5. Tạo dữ liệu mẫu trong các bảng bằng cách chạy câu lệnh trong file Restaurant-Review/backend/Sample/sample_data.sql
6. Lấy Api key ở trang cài đặt project của Supabase và thay vào trong file .env với các biến: URL, ANON_KEY, BASE_IMAGE_URL, DEEP_LINK_URL
7. Cài đặt các thư viện của chương trình Flutter bằng cách chạy câu lệnh flutter pub get
8. Tiến hành chạy chương trình trên các thiết bị Android bằng cách bấm nút run trên code editor.