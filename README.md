# CalcuCPD

Calculadora web para descuento de cheques.

## Stack
- Python + Flask
- Gunicorn
- Nginx (reverse proxy)
- Systemd (servicio `calcucpd`)

## URL actual
- `http://138.197.9.164/`

## Estructura esperada en VPS
- Proyecto: `/opt/calcucpd`
- Virtualenv: `/opt/calcucpd/.venv`
- Servicio: `/etc/systemd/system/calcucpd.service`
- Nginx site: `/etc/nginx/sites-available/calcucpd`

## Deploy manual rapido
Desde tu PC:

```bash
ssh mi-vps
```

En el VPS:

```bash
cd /opt/calcucpd
git pull
source .venv/bin/activate
pip install -r requirements.txt
sudo systemctl restart calcucpd
```

## Deploy con script (recomendado)
El repo incluye `deploy.sh`.

Uso en VPS:

```bash
cd /opt/calcucpd
chmod +x deploy.sh
./deploy.sh
```

Que hace:
1. Hace `git pull --ff-only` de `origin/main`
2. Activa `.venv`
3. Instala `requirements.txt`
4. Reinicia `calcucpd`
5. Muestra estado del servicio

## Comandos utiles
Estado del servicio:

```bash
sudo systemctl status calcucpd --no-pager
```

Logs en vivo:

```bash
sudo journalctl -u calcucpd -f
```

Reiniciar Nginx:

```bash
sudo nginx -t
sudo systemctl reload nginx
```

Puertos en escucha:

```bash
sudo ss -tulpn | grep -E ':80|:443|:5001|:8000'
```

## Notas de seguridad
- Gunicorn debe escuchar solo en `127.0.0.1:5001`.
- Nginx publica la app por `:80`.
- UFW habilitado con reglas `OpenSSH` y `Nginx Full`.

## Futuro: dominio y HTTPS
Cuando compres dominio:
1. Crear registro `A` apuntando a `138.197.9.164`.
2. Actualizar `server_name` en Nginx.
3. Instalar TLS con Certbot (Let's Encrypt).
