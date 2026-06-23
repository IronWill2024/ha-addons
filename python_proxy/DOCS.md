# Python HTTP Proxy Add-on

## Giới thiệu
Đây là một HTTP/HTTPS Forward Proxy siêu nhẹ (dựa trên bộ nhân Tinyproxy) dành cho Home Assistant.
Add-on này đặc biệt hữu ích khi bạn có các script Python (hoặc ứng dụng ngoài) chạy ở Serverless/Cloud cần đi vòng qua đường truyền mạng nhà bạn để có địa chỉ IP nội địa, mà không cần cài đặt VPN phức tạp.

## Hướng dẫn kết nối
Sau khi cài đặt và bấm **Start**, proxy sẽ lắng nghe ở cổng `8888`.
Để sử dụng, bạn có thể gọi từ code Python bằng thư viện `requests` như sau:

```python
import requests

# Thay IP_CUA_HA bằng IP nội bộ hoặc Tên miền (duckdns/cloudflare) của Home Assistant.
# Tên đăng nhập và mật khẩu phải khớp với thiết lập ở tab Configuration.
proxy_url = "http://dev_user:Password123_S3cur3@IP_CUA_HA:8888"

proxies = {
    "http": proxy_url,
    "https": proxy_url
}

resp = requests.get("https://api.ipify.org", proxies=proxies)
print("IP trỏ ra internet:", resp.text)
```

## Cấu hình (Configuration)
Bạn có thể tinh chỉnh các thông số trong tab **Configuration** của Add-on:
* **auth_user**: Tên đăng nhập để truy cập proxy.
* **auth_pass**: Mật khẩu truy cập. **(LƯU Ý QUAN TRỌNG: Do giới hạn của bộ nhân Tinyproxy, mật khẩu KHÔNG được chứa ký tự `@` và khoảng trắng)**.
* **log_level**: Mức độ hiển thị chi tiết của Log (tab Log). Chọn `Connect` hoặc `Info` để theo dõi rõ request nào đang đi qua proxy.

## Cảnh báo Bảo mật ⚠️
Nếu bạn cấu hình NAT port 8888 trên Modem ra ngoài Internet, bạn **bắt buộc** phải sử dụng một mật khẩu thật khó đoán. Port proxy rất dễ bị scan tự động bởi các botnet, nếu để mật khẩu yếu hoặc dễ đoán, mạng nhà bạn có thể bị biến thành trạm trung chuyển để kẻ gian đi spam hoặc tấn công mạng.

## Xử lý sự cố (Troubleshooting)
- Nếu Add-on không khởi động và báo lỗi cú pháp dòng `BasicAuth`, hãy kiểm tra lại xem mật khẩu của bạn có chứa dấu cách hay ký tự `@` hay không.
- Chú ý không nên bấm vào nút "Open Web UI" do đây là Forward Proxy chứ không có giao diện web HTML. Nếu bấm vào bạn có thể gặp lỗi 502/504 của NGINX.
