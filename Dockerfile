FROM node:20-alpine AS builder

WORKDIR /app/chipotle-llm-provider

COPY package*.json ./
RUN npm install --include=dev

COPY . ./
RUN npm run build && npm prune --omit=dev

FROM node:20-alpine

WORKDIR /app/chipotle-llm-provider

ENV NODE_ENV=production
ENV PORT=3000
ENV MAX_POOL_SIZE=5

COPY --from=builder /app/chipotle-llm-provider/package*.json ./
COPY --from=builder /app/chipotle-llm-provider/node_modules ./node_modules
COPY --from=builder /app/chipotle-llm-provider/dist ./dist

EXPOSE 3000

CMD ["npm", "start"]
