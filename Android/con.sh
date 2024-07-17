#!/bin/bash

#  กำหนด HOST เปล่าไว้ก่อน 
URL="https://www.google.com" # default url
HOST=$(echo "$URL" | sed -E 's/https?:\/\/(www\.)?//;s/\/.*//') # แยก HOST จาก default URL

# สีสำหรับการแสดงผล
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
WHITE="\033[1;37m"
NC="\033[0m"

# ฟังก์ชั่นสำหรับการแสดงผลลัพธ์
print_status() {
  local ping_color=$1
  local ping_status=$2
  local curl_color=$3
  local curl_status=$4
  clear  # ล้างหน้าจอทุกครั้งที่มีการอัปเดตสถานะ
  echo -e "${WHITE}==============================${NC}"
  echo -e "${ping_color}Ping: ${ping_status}${NC}"
  echo -e "${curl_color}Curl: ${curl_status}${NC}"
  echo -e "${WHITE}==============================${NC}"
  echo -e "Ping Failed: ${PING_FAILED} times"
  echo -e "Curl Failed: ${CURL_FAILED} times"
  echo -e "Ping Success: ${PING_SUCCESS} times" 
  echo -e "Curl Success: ${CURL_SUCCESS} times" 
  echo -e "${WHITE}==============================${NC}"
}

# ฟังก์ชั่นสำหรับตรวจสอบ URL และ HOST
check_url() {
  local url=$1

  # ตรวจสอบว่า URL ขึ้นต้นด้วย http:// หรือ https:// หรือไม่
  if [[ "$url" =~ ^https?:// ]]; then
    HOST=$(echo "$url" | sed -E 's/https?:\/\/(www\.)?//;s/\/.*//')
    URL=$url
  else
    echo "URL ไม่ถูกต้อง กรุณาใส่ URL ที่ขึ้นต้นด้วย http:// หรือ https://"
    exit 1
  fi
}

# รับ URL จากผู้ใช้ (ถ้ามี)
read -p "กรุณาใส่ URL (เช่น https://www.example.com หรือ กด Enter เพื่อใช้ค่าเริ่มต้น): " INPUT_URL

# ถ้าผู้ใช้กรอก URL ให้ใช้ URL นั้น ไม่เช่นนั้นใช้ default URL
if [ -n "$INPUT_URL" ]; then
  check_url "$INPUT_URL"
fi

# ตัวแปรนับจำนวนครั้งที่ Ping และ Curl ไม่สำเร็จ
PING_FAILED=0
CURL_FAILED=0

# ตัวแปรนับจำนวนครั้งที่ Ping และ Curl สำเร็จ
PING_SUCCESS=0
CURL_SUCCESS=0

# UPDATE_INTERVAL
UPDATE_INTERVAL=3 

# ลูปสำหรับ Ping ตรวจสอบการเชื่อมต่อ TCP และ CURL ตรวจสอบ HTTP
while true; do
  # ตรวจสอบการเชื่อมต่อ TCP ping ไปยัง host
  if ping -c 1 $HOST &> /dev/null; then
    ((PING_SUCCESS++))
    PING_STATUS="Active"
    PING_COLOR=$GREEN
  else
    PING_STATUS="Inactive"
    PING_COLOR=$RED
    ((PING_FAILED++))
  fi

  # ใช้ Curl กับตัวเลือก --connect-timeout และ --max-time
  RESPONSE=$(curl -H "Connection: keep-alive" --connect-timeout 10 --max-time 20 -s -o /dev/null -w "%{http_code}" $URL)

  # ตรวจสอบรหัสสถานะ HTTP
  if [ "$RESPONSE" -eq 200 ]; then
    ((CURL_SUCCESS++))
    CURL_STATUS="HTTP status code $RESPONSE"
    CURL_COLOR=$GREEN
  else
    CURL_STATUS="HTTP status code $RESPONSE. Retrying..."
    CURL_COLOR=$RED
    ((CURL_FAILED++))
  fi

  # แสดงผลลัพธ์ทุกครั้ง 
  print_status $PING_COLOR "$PING_STATUS" $CURL_COLOR "$CURL_STATUS"

  # รอเป็นเวลาที่กำหนดก่อนทำการร้องขอครั้งต่อไป
  sleep $UPDATE_INTERVAL
done
