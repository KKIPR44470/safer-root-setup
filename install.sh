#!/bin/bash

# 檢查是否為 root
if [[ $EUID -ne 0 ]]; then
  echo "請以 root 身份執行此腳本"
  exit 1
fi

# 安裝 whiptail
apt update && apt install -y whiptail

# 主選單
OPTION=$(whiptail --title "VPS 一鍵工具" --menu "選擇操作：" 15 60 5 \
"1" "啟用 Root 登入" \
"2" "更新系統" \
"3" "安裝常用工具" \
"4" "重啟系統" \
"0" "退出" 3>&1 1>&2 2>&3)

case $OPTION in
  1)
    echo "正在啟用 Root 登入..."
    sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
    systemctl restart sshd
    echo "✅ Root 登入已啟用"
    ;;
  2)
    echo "正在更新系統..."
    apt update && apt upgrade -y
    echo "✅ 系統已更新"
    ;;
  3)
    echo "正在安裝工具..."
    apt install -y curl wget vim sudo htop
    echo "✅ 常用工具已安裝"
    ;;
  4)
    echo "正在重啟系統..."
    reboot
    ;;
  0)
    echo "已退出"
    exit 0
    ;;
  *)
    echo "無效選項"
    ;;
esac
