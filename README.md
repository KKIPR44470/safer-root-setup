# safer-root-setup

🛡️ 安全啟用 VPS 的 root 登入與基本設置腳本。

---

## 🚀功能特點

- 啟用 SSH Root 登入
- 移除潛在安全風險配置
- 清理無用帳號與歷史紀錄
- 支援 Debian 系統（建議使用 Debian 11+）

📁檔案說明

檔案名稱	說明

install.sh	可作為主安裝入口腳本
safer-root.sh	執行實際的 root 安全設置操作

---

🔒注意事項

請在 全新安裝的 VPS 上使用。

腳本會修改 /etc/ssh/sshd_config，請確認你能透過控制台進行救援以防 SSH 無法連接。

所有操作會要求你具備 root 權限（請使用 sudo 或直接以 root 執行）。



---

🧊支援系統

Debian 11（建議） / Debian 12

Ubuntu 暫未完全測試不保證相容

## 📦一鍵安裝

使用下列指令在你的 VPS 上執行：

```bash
bash <(curl -Ls https://raw.githubusercontent.com/KKIPR44470/safer-root-setup/main/safer-root.sh)
