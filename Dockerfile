# ---- Build: compile the Astro site to static files ----
FROM node:24-alpine AS build
WORKDIR /app
COPY package.json package-lock.json .npmrc ./
# Exact versions from the lockfile, no install scripts, then fail the build on known vulnerabilities
RUN npm ci --ignore-scripts --no-fund \
 && npm audit --audit-level=moderate
COPY . .
RUN npm run build

# ---- Serve: nginx running as a non-root user ----
FROM nginxinc/nginx-unprivileged:stable-alpine
COPY --chown=root:root nginx.conf /etc/nginx/conf.d/default.conf
COPY --chown=root:root --from=build /app/dist /usr/share/nginx/html
USER nginx
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget -q --spider http://127.0.0.1:8080/ || exit 1
