FROM node:23-alpine AS base

RUN apk add --no-cache sqlite

WORKDIR /app

RUN mkdir -p /app/db
RUN sqlite3 /app/db/database.db "VACUUM;"

COPY ./yarn.lock ./package.json ./

RUN yarn install

COPY ./prisma ./prisma/

ENV DATABASE_URL=file:/app/db/database.db

RUN npx prisma migrate dev --name init

COPY ./ ./

FROM node:23-alpine

WORKDIR /app

COPY --from=base ./app ./

ENV DATABASE_URL=file:/app/db/database.db

CMD ["yarn", "dev"]
