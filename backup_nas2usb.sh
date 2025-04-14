#!/bin/bash

# -------------------------------------------
# - backup_nas2usb.sh v0.1 - (c) 2025 suuhm -
# -   Terminal notifier and backup tool     -
# -------------------------------------------

# === CONFIGURATION ===
NAS_SMB_SHARE="//nas/BACKUP"
NAS_MOUNT_POINT="/mnt/nas_backup"
USB_DEVICE="/dev/sdb1"
USB_MOUNT_POINT="/mnt/usb_backup"
LOG_FILE="/var/log/backup_nas_to_usb.log"
if [ -z "$DISCORD_WEBHOOK_URL" ]; then
  DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/1"  # Default Webhook URL
fi

# === FUNCTION: Send Discord Notification ===
send_discord_message() {
  curl -H "Content-Type: application/json" \
       -X POST \
       -d "{\"content\": \"$1\"}" \
       "$DISCORD_WEBHOOK_URL"
}

# === PREPARATION ===
total_size=$(du -sh "$NAS_MOUNT_POINT" | cut -f1)
echo "[INFO] Starting backup: $(date)" | tee -a "$LOG_FILE"
send_discord_message "📦 Backup started: $(date).  
🗂️ Total data to backup: $total_size"

# Mount NAS
mkdir -p "$NAS_MOUNT_POINT"
mount -t cifs "$NAS_SMB_SHARE" "$NAS_MOUNT_POINT" -o username=YOURUSER,password=YOURPASS,vers=1.0 || {
  echo "[ERROR] Failed to mount NAS!" | tee -a "$LOG_FILE"
  send_discord_message "❌ Failed to mount NAS!"
  exit 1
}

# Mount USB
mkdir -p "$USB_MOUNT_POINT"
mount "$USB_DEVICE" "$USB_MOUNT_POINT" || {
  echo "[ERROR] Failed to mount USB drive!" | tee -a "$LOG_FILE"
  send_discord_message "❌ Failed to mount USB drive!"
  umount "$NAS_MOUNT_POINT"
  exit 1
}

# === BACKUP ===
start_time=$(date +%s)
echo "[INFO] Starting rsync..." | tee -a "$LOG_FILE"
rsync -ah --delete --info=progress2 "$NAS_MOUNT_POINT/" "$USB_MOUNT_POINT/" | tee -a "$LOG_FILE"

# === CLEANUP ===
umount "$NAS_MOUNT_POINT"
umount "$USB_MOUNT_POINT"
end_time=$(date +%s)
duration=$((end_time - start_time))

echo "[INFO] Backup completed: $(date)" | tee -a "$LOG_FILE"
send_discord_message "✅ Backup completed: $(date).  
📊 Duration: $((duration / 3600))h $(((duration % 3600) / 60))m"

exit 0;

