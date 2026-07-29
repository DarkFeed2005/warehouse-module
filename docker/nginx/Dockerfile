FROM nginx:1.27-alpine

RUN apk add --no-cache curl

COPY default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80 443

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
    CMD curl -f http://localhost:80/ || exit 1
