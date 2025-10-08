#!/bin/bash

SOFTWARE_DIR="$1"      # 暗号化したい対象
CONTAINER_SIZE="$2"    # コンテナサイズ (例: 1G, 500M)
CONTAINER_PATH="/opt/encrypted_software.luks"
KEY_FILE="/root/.luks-keys/software.key"

if [ -z "$SOFTWARE_DIR" ] || [ -z "$CONTAINER_SIZE" ]; then
    echo "使用法: $0 <ソフトウェアディレクトリ> <サイズ>"
    echo "例: $0 /path/to/software 500M"
    exit 1
fi

# キーファイル生成
sudo mkdir -p /root/.luks-keys
sudo dd if=/dev/urandom of="$KEY_FILE" bs=32 count=1
sudo chmod 600 "$KEY_FILE"

# 暗号化コンテナ作成
sudo fallocate -l "$CONTAINER_SIZE" "$CONTAINER_PATH"
sudo cryptsetup luksFormat "$CONTAINER_PATH" "$KEY_FILE"

# コンテナをオープン・フォーマット
sudo cryptsetup luksOpen "$CONTAINER_PATH" encrypted-software --key-file="$KEY_FILE"
sudo mkfs.ext4 /dev/mapper/encrypted-software

# 一時マウントしてソフトウェアコピー
sudo mkdir -p /tmp/mount-temp
sudo mount /dev/mapper/encrypted-software /tmp/mount-temp
sudo cp -r "$SOFTWARE_DIR"/* /tmp/mount-temp/

# 元ディレクトリの自動削除
sudo rm -rf "$SOFTWARE_DIR"

# クリーンアップ
sudo umount /tmp/mount-temp
sudo cryptsetup luksClose encrypted-software
sudo rmdir /tmp/mount-temp

echo "暗号化完了: $CONTAINER_PATH"
echo "キーファイル: $KEY_FILE"
