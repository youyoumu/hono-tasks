FROM node:22.14-alpine3.20

WORKDIR /app

COPY . .

EXPOSE 8805

CMD ["sh", "-c", "test -f /app/db/production.db || npx drizzle-kit push && npm start"]



