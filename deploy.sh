#!/usr/bin/env bash
set -euo pipefail

APP_DIR="/opt/calcucpd"
SERVICE_NAME="calcucpd"
BRANCH="main"

log() {
  echo "[deploy] $1"
}

if [[ ! -d "$APP_DIR" ]]; then
  echo "Error: no existe $APP_DIR"
  exit 1
fi

cd "$APP_DIR"

if ! command -v git >/dev/null 2>&1; then
  echo "Error: git no esta instalado"
  exit 1
fi

if ! command -v sudo >/dev/null 2>&1; then
  echo "Error: sudo no esta disponible"
  exit 1
fi

log "Repositorio: $(pwd)"
log "Branch objetivo: $BRANCH"

CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$CURRENT_BRANCH" != "$BRANCH" ]]; then
  log "Cambiando branch de $CURRENT_BRANCH a $BRANCH"
  git checkout "$BRANCH"
fi

log "Traiendo cambios desde origin/$BRANCH"
git pull --ff-only origin "$BRANCH"

if [[ ! -f ".venv/bin/activate" ]]; then
  echo "Error: no existe .venv. Crea el entorno con: python3 -m venv .venv"
  exit 1
fi

log "Activando virtualenv"
source .venv/bin/activate

log "Instalando dependencias"
pip install -r requirements.txt

log "Reiniciando servicio $SERVICE_NAME"
sudo systemctl restart "$SERVICE_NAME"

log "Estado del servicio"
sudo systemctl status "$SERVICE_NAME" --no-pager

log "Deploy finalizado"
