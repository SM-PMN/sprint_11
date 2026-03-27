#!/bin/bash
# Автоматическая настройка Yandex Cloud для Terraform
echo "🔄 Настройка Yandex Cloud окружения..."

export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)

echo "✅ Готово! YC_TOKEN=$YC_TOKEN"
echo "   Cloud ID=$YC_CLOUD_ID"
echo "   Folder ID=$YC_FOLDER_ID"
echo ""
