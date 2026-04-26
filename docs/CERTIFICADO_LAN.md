# Configuracion De Certificado HTTPS En LAN

## Objetivo
Dejar frontend y backend funcionando por HTTPS en red local (LAN), usando certificado emitido con `mkcert`.

Este flujo es para red interna. No usarlo para Internet publica.

## Estructura recomendada
En el servidor donde corre app:

```text
C:\apps\desarrollo-megarosita\
  megarositabackend\
  megarositafrontend\
  certs\
    lan-cert.pem
    lan-key.pem
    mkcert-rootCA.crt
```

## 1) Instalar mkcert en servidor LAN
PowerShell (como admin):

```powershell
winget install --id FiloSottile.mkcert -e --accept-package-agreements --accept-source-agreements
mkcert -install
```

## 2) Generar certificado para IP LAN
Reemplaza `192.168.100.1` por la IP real del servidor del cliente.

```powershell
New-Item -ItemType Directory -Path C:\apps\desarrollo-megarosita\certs -Force | Out-Null

mkcert `
  -cert-file C:\apps\desarrollo-megarosita\certs\lan-cert.pem `
  -key-file  C:\apps\desarrollo-megarosita\certs\lan-key.pem `
  192.168.100.1 localhost 127.0.0.1 ::1
```

Exporta CA para instalar en moviles/tablets si aparece advertencia SSL:

```powershell
$caroot = mkcert -CAROOT
Copy-Item "$caroot\rootCA.pem" "C:\apps\desarrollo-megarosita\certs\mkcert-rootCA.crt" -Force
```

## 3) Configurar backend (ASP.NET)
Archivo: `megarositabackend\src\Api\appsettings.Development.json`

```json
{
  "Kestrel": {
    "Endpoints": {
      "Http": { "Url": "http://0.0.0.0:5000" },
      "Https": {
        "Url": "https://0.0.0.0:5001",
        "Certificate": {
          "Path": "..\\..\\..\\certs\\lan-cert.pem",
          "KeyPath": "..\\..\\..\\certs\\lan-key.pem"
        }
      }
    }
  }
}
```

Si despliegas en otra ruta y prefieres variables de entorno:

```powershell
$env:Kestrel__Endpoints__Https__Certificate__Path = "C:\apps\desarrollo-megarosita\certs\lan-cert.pem"
$env:Kestrel__Endpoints__Https__Certificate__KeyPath = "C:\apps\desarrollo-megarosita\certs\lan-key.pem"
```

## 4) Configurar CORS backend
Archivo: `megarositabackend\src\Api\appsettings.json`

```json
"Cors": {
  "AllowedOrigins": [
    "https://192.168.100.1:4173",
    "https://192.168.100.1:5173",
    "https://localhost:4173",
    "http://localhost:4173",
    "https://localhost:5173",
    "http://localhost:5173"
  ]
}
```

Reemplaza IP por la del servidor.

## 5) Configurar frontend (Vite)
Archivo: `megarositafrontend\.env`

```env
VITE_API_BASE_URL=https://192.168.100.1:5001/api/v1
VITE_HTTPS_CERT_PATH=../certs/lan-cert.pem
VITE_HTTPS_KEY_PATH=../certs/lan-key.pem
```

## 6) Levantar servicios
Backend:

```powershell
cd C:\apps\desarrollo-megarosita\megarositabackend
dotnet run --project src\Api\Ecommerce.Api.csproj --launch-profile https-lan
```

Frontend:

```powershell
cd C:\apps\desarrollo-megarosita\megarositafrontend
npm install
npm run build:lan
npm run preview:https
```

## 7) Abrir puertos en firewall
- `4173` (frontend)
- `5001` (backend HTTPS)

## 8) Verificacion rapida
Desde servidor:

```powershell
Invoke-WebRequest https://127.0.0.1:5001/swagger/index.html -UseBasicParsing
Invoke-WebRequest https://127.0.0.1:4173 -UseBasicParsing
```

Desde otro equipo de la LAN:
- `https://192.168.100.1:4173`
- `https://192.168.100.1:5001/swagger/index.html`

## 9) Si moviles/tablets muestran "No es seguro"
Instalar `mkcert-rootCA.crt` en cada dispositivo como certificado de confianza.

## 10) Renovacion de certificado
Cuando cambie IP o antes de vencer:

```powershell
mkcert `
  -cert-file C:\apps\desarrollo-megarosita\certs\lan-cert.pem `
  -key-file  C:\apps\desarrollo-megarosita\certs\lan-key.pem `
  NUEVA_IP localhost 127.0.0.1 ::1
```

Luego reiniciar backend y frontend.
