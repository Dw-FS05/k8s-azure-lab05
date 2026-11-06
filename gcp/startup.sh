#!/bin/bash
set -eu

# Script de arranque para la VM en Google Cloud
echo "Iniciando instalacion de K3s..."
curl -fsSL https://get.k3s.io -o /tmp/install-k3s.sh
INSTALL_K3S_VERSION='v1.35.2+k3s1' sh /tmp/install-k3s.sh

# Esperar a que K3s este activo
until systemctl is-active --quiet k3s; do
  echo "Esperando que el servicio k3s este activo..."
  sleep 2
done

echo "K3s instalado y activo exitosamente."
