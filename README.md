# setup project

- Run setup: `npm run setup`
- Start server: `npm run dev:server`
- Login in server: `/auth login device` and follow instructions
- persist credentials: `/auth persistence Encrypted`

# for WSL users:
Download: https://nmap.org/download.html#windows
The exec `scripts/wsl-port-forwarder.ps` on your host system to forward ports from WSL to Windows using: `powershell -NoProfile -ExecutionPolicy Bypass -File "F:\Downloads\wsl-port-forwarder.ps1"`