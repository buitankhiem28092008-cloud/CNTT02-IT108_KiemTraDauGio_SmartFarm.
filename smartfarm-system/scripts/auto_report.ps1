# AUDIT: xac nhan da tham dinh script - khong chua lenh xoa hang loat.
# Chay tu thu muc scripts/ :  .\auto_report.ps1
# Neu bi chan boi ExecutionPolicy: powershell -ExecutionPolicy Bypass -File .\auto_report.ps1

$log    = "..\data\log-he-thong.log"
$report = "..\backup\bao-cao-su-co.txt"

# 1. Tieu de bao cao (ghi moi file)
Write-Output "==========================================" > $report
Write-Output "   BAO CAO SU CO - SMARTFARM"               >> $report
Write-Output ("   Ngay gio: " + (Get-Date -Format "dd/MM/yyyy HH:mm")) >> $report
Write-Output "==========================================" >> $report

# 2. Loc cac dong CRITICAL hoac ERROR bang Pipeline roi chen noi vao bao cao
Get-Content $log | Select-String -Pattern "CRITICAL|ERROR" >> $report

# 3. Dem so su co bang Pipeline
$tong = Get-Content $log | Select-String -Pattern "CRITICAL|ERROR" | Measure-Object | Select-Object -ExpandProperty Count
Write-Output "------------------------------------------" >> $report
Write-Output "TONG SO SU CO:" >> $report
Write-Output $tong >> $report
