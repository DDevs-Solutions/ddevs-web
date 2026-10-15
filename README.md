# ddevs.cl

Sitio de **DDevs Solutions**, hecho con [Astro](https://astro.build) y servido con nginx detrás de un Cloudflare Tunnel.

## Estructura

```
src/
├── components/   Una sección del sitio por archivo (markup, estilos y lógica juntos)
├── layouts/      Estructura común: <head>, SEO, fuentes
├── pages/        Cada archivo es una ruta (index.astro → /)
├── data/         Contenido editable: servicios, proyectos, datos de contacto
├── scripts/      JavaScript compartido (animaciones al hacer scroll)
└── styles/       tokens.css (colores, tipografía, espaciado) y estilos globales
public/           Archivos estáticos: favicon, imágenes
```

## Desarrollo

```bash
npm install
npm run dev       # http://localhost:4321
npm run build     # genera dist/
```

## Editar contenido

- Servicios: `src/data/services.json`
- Proyectos: `src/data/projects.json`
- Datos de contacto: `src/data/site.json`
- Foto del hero: guárdala en `public/img/dylan.png` (PNG sin fondo) y actívala en `src/pages/index.astro`.

## Animaciones

- La portada usa animaciones CSS en `Hero.astro`.
- Cualquier elemento con `data-reveal="left|right|up"` aparece al hacer scroll. El retraso se ajusta con `style="--delay:120ms"`.
- Respeta la preferencia del sistema de reducir movimiento.

## Despliegue (homelab)

```bash
git pull
docker compose up -d --build
```

El token del túnel va en `.env` (`TUNNEL_TOKEN=...`), que no se sube al repositorio.
En Cloudflare, la ruta del túnel apunta a `http://web:8080`.

## Seguridad

**Dependencias**
- Versiones exactas (`save-exact`) y `npm ci` desde el lockfile.
- Los scripts de instalación de paquetes están desactivados (`ignore-scripts`).
- La imagen de Docker no se construye si `npm audit` encuentra vulnerabilidades.

**Navegador**
- Content-Security-Policy estricta: solo scripts, estilos, fuentes e imágenes del propio dominio. Sin código inline ni recursos de terceros (las fuentes van incluidas en el sitio).
- HSTS, `X-Frame-Options: DENY`, `nosniff`, Permissions-Policy, COOP y CORP.
- Solo se aceptan peticiones `GET` y `HEAD`; los archivos ocultos nunca se sirven.

**Servidor**
- nginx corre sin root (`nginx-unprivileged`) en el puerto 8080.
- Contenedores con sistema de archivos de solo lectura, sin capabilities de Linux y con `no-new-privileges`.
- El contenedor web está en una red interna sin acceso a internet y sin puertos publicados en el host. Solo el túnel tiene salida.
- El tráfico llega cifrado por Cloudflare Tunnel. No hay puertos abiertos en el router.
