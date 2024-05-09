@echo off
for /f "tokens=3" %%i in ('netsh wlan show interface ^| findstr /i "SSID"') do set "myssid=%%i" & goto next
:next
set "myssid=%myssid: =%"
if /i "%myssid%"=="SSID-string-goes-here" (
  netsh interface ipv4 set dns "Wi-Fi" static 8.8.8.8
  netsh interface ipv4 add dns "Wi-Fi" 8.8.4.4 index=2
  ipconfig /flushdns
) else (
    netsh interface ipv4 set dns "Wi-Fi" dhcp
    ipconfig /flushdns
)