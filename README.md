# change-dns-bat-script
Short .bat script that I use with Windows Task Scheduler to quickly change DNS settings when my machine connects to office WiFi.

If WiFi SSID matches `myssid`, set primary IPv4 DNS to 8.8.8.8 (or whatever setting you want) and secondary IPv4 DNS to 8.8.4.4. (or whatever setting you want) Flush DNS cache afterwards for changes to take effect.

Otherwise, if WiFi SSID does not match `myssid`, set DNS settings to whatever DHCP gives me (or whatever setting you want). Flush DNS cache afterwards for changes to take effect.

Example usage, given:
- Office WiFi SSID is "OfficeWifi123"
- I want 0.0.0.0 as primary DNS
- I want 0.0.1.1 as secondary DNS
- I don't care for any DNS setting when connected to home WiFi

```
@echo off
for /f "tokens=3" %%i in ('netsh wlan show interface ^| findstr /i "SSID"') do set "myssid=%%i" & goto next
:next
set "myssid=%myssid: =%"
if /i "%myssid%"=="OfficeWifi123" (
  netsh interface ipv4 set dns "Wi-Fi" static 0.0.0.0
  netsh interface ipv4 add dns "Wi-Fi" 0.0.1.1 index=2
  ipconfig /flushdns
) else (
    netsh interface ipv4 set dns "Wi-Fi" dhcp
    ipconfig /flushdns
)
```

When used with Windows Task Scheduler, I just set the script to run when the event Microsoft-Windows-NetworkProfile/Operational Event ID 10000 fires, which is when the Windows machine connects to a network.

[Image depicts a screenshot of my trigger edit, where the trigger listens to log "Microsoft-Windows-NetworkProfile/Operational", with the Event ID 10000](dns-script-img.png "dns-script-img")