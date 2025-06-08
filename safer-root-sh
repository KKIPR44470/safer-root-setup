#!/bin/bash

# 檢查是否為 root
[[ $EUID -ne 0 ]] && echo "請以 root 身份執行本腳本！" && exit 1

# 備份 SSH 設定檔
backup_path="/etc/ssh/sshd_config.bak.$(date +%F_%T)"
cp /etc/ssh/sshd_config "$backup_path" && echo "✅ 已備份 SSH 設定到 $backup_path"

# 讀取 SSH port（預設 22）
read -p "請輸入新的 SSH 連接埠 (預設 22): " sshport
sshport=${sshport:-22}

# 讀取 root 密碼（隱藏輸入）
read -s -p "請輸入新的 root 密碼（留空則自動生成）: " rootpwd
echo
if [[ -z "$rootpwd" ]]; then
    rootpwd=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 16)
    echo "⚠️ 未輸入密碼，已自動產生：$rootpwd"
fi

# 暫時解除保護
chattr -i /etc/shadow 2>/dev/null
chattr -i /etc/passwd 2>/dev/null

# 修改 root 密碼
echo "root:$rootpwd" | chpasswd && echo "✅ Root 密碼已設定"

# 還原保護
chattr +i /etc/shadow 2>/dev/null
chattr +i /etc/passwd 2>/dev/null

# 修改 SSH 設定
sed -i "s/^#\?Port .*/Port $sshport/" /etc/ssh/sshd_config
sed -i "s/^#\?PermitRootLogin .*/PermitRootLogin yes/" /etc/ssh/sshd_config
sed -i "s/^#\?PasswordAuthentication .*/PasswordAuthentication yes/" /etc/ssh/sshd_config

# 防火牆處理
if command -v ufw &>/dev/null; then
    ufw allow "$sshport"/tcp && echo "✅ UFW 已放行 $sshport"
elif command -v iptables &>/dev/null; then
    iptables -C INPUT -p tcp --dport "$sshport" -j ACCEPT 2>/dev/null || \
    iptables -I INPUT -p tcp --dport "$sshport" -j ACCEPT && echo "✅ iptables 已放行 $sshport"
else
    echo "⚠️ 未偵測到 ufw 或 iptables，請手動確保 $sshport 已開啟"
fi

# 重新啟動 SSH
systemctl restart ssh || systemctl restart sshd && echo "🔁 SSH 服務已重啟"

# 顯示新登入資訊
ipv4=$(curl -s4 ifconfig.co || hostname -I | awk '{print $1}')
ipv6=$(curl -s6 ifconfig.co 2>/dev/null)

echo -e "\n🧾 登入資訊："
echo "-------------------------"
[[ -n "$ipv4" ]] && echo "🌐 IPv4：$ipv4"
[[ -n "$ipv6" ]] && echo "🌐 IPv6：$ipv6"
echo "📟 Port：$sshport"
echo "👤 User：root"
echo "🔑 Password：$rootpwd"
echo "-------------------------"
