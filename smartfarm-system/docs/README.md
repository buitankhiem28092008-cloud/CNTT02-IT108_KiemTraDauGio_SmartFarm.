# SmartFarm Monitor – Hệ thống giám sát trạm cảm biến nông trại

Hệ thống thu thập nhật ký (log) từ các trạm cảm biến ngoài trang trại, tự động lọc sự cố và đối soát danh sách thiết bị.

## Hướng dẫn chạy script

```powershell
# 1. Khởi tạo cây thư mục (01 dòng lệnh duy nhất)
New-Item -ItemType Directory -Path smartfarm-system\docs, smartfarm-system\scripts, smartfarm-system\data, smartfarm-system\backup

# 2. Đứng trong data/, tạo file .env ở thư mục gốc bằng đường dẫn tương đối và đặt thuộc tính Hidden
cd smartfarm-system\data
Set-Content -Path ..\.env -Value "DB_PASSWORD=demo_123456"
Set-ItemProperty -Path ..\.env -Name Attributes -Value Hidden

# 3. Chạy robot lọc log từ thư mục scripts/
cd ..\scripts
.\auto_report.ps1

# Nếu bị chặn bởi ExecutionPolicy:
powershell -ExecutionPolicy Bypass -File .\auto_report.ps1
```

Kết quả được ghi vào `backup/bao-cao-su-co.txt`.

## Checklist kiểm tra thiết bị

- [x] Đã tạo đúng cây thư mục `smartfarm-system/`
- [x] File `.env` đã được đặt thuộc tính Hidden
- [ ] Đã chạy `auto_report.ps1` và kiểm tra `bao-cao-su-co.txt`
- [ ] Đã thay modem trạm sensor-03

## Bảng thông số phần cứng

| Tên thiết bị | Đơn giá (VNĐ) | Loại storage |
|---|---:|---|
| Raspberry Pi 4 Model B | 1.450.000 | SSD |
| Intel NUC i3 | 6.200.000 | SSD |
| Orange Pi 5 | 2.300.000 | SSD |
| Dell Optiplex Micro | 5.400.000 | HDD |
| Mini PC Fanless N100 | 4.200.000 | SSD |
| Synology DS220j NAS | 3.900.000 | HDD |

## Phân tích hệ thống

### Input – Process – Output của chức năng lọc log

| Thành phần | Nội dung |
|---|---|
| **Input** | File nhật ký `data/log-he-thong.log` (các dòng INFO, WARNING, ERROR, CRITICAL) |
| **Process** | `Get-Content` đọc log → Pipeline `\|` → `Select-String` lọc dòng chứa "CRITICAL" hoặc "ERROR" → `Measure-Object` đếm số dòng lỗi |
| **Output** | File `backup/bao-cao-su-co.txt` gồm tiêu đề, danh sách dòng lỗi và dòng "TONG SO SU CO:" |

### Phân loại DIKW

| Phát biểu | Tầng DIKW | Lý do |
|---|---|---|
| (a) "Quyết định thay modem trạm sensor-03 trước thứ Sáu." | **Wisdom** | Là quyết định hành động, dựa trên hiểu biết về nguyên nhân và bối cảnh. |
| (b) "2026-10-12 08:15:01 [ERROR] sensor-03 Connection TIMEOUT after 30s" | **Data** | Một dòng log thô, chưa được xử lý hay giải thích. |
| (c) "Hôm nay hệ thống ghi nhận 8 sự cố, trong đó 4 sự cố đến từ trạm sensor-03." | **Information** | Dữ liệu đã được lọc, đếm và tổng hợp thành thông tin có ý nghĩa. |
| (d) "Trạm sensor-03 hay mất kết nối vào buổi chiều do sóng yếu, nên cần lắp thêm anten." | **Knowledge** | Rút ra quy luật và nguyên nhân từ thông tin (hiểu "vì sao" và "làm thế nào"). |

## Bẫy phần cứng: tải file log 500 MB qua mạng 100 Mbps

- Quy đổi: 100 Mbps ÷ 8 = **12,5 MB/s** (1 byte = 8 bit)
- Thời gian tải: 500 MB ÷ 12,5 MB/s = **40 giây**

(Cách khác: 500 MB × 8 = 4.000 Mb; 4.000 Mb ÷ 100 Mbps = 40 giây. Chưa tính overhead đường truyền.)
