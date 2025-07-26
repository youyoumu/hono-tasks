# ---------- Base Dependencies Stage ----------
FROM node:22.14-alpine3.20 AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev

# ---------- Build Stage ----------
FROM node:22.14-alpine3.20 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

#
FROM node:22.14-alpine3.20 AS runner
WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/src ./src
COPY drizzle.config.ts .

EXPOSE 8805
CMD ["sh", "-c", "test -f /app/db/production.db || npx drizzle-kit push; npm start"]





