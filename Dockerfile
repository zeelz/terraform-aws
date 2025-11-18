FROM node:alpine

WORKDIR /express-app

COPY package*.json ./

RUN npm install

COPY db.ts index.ts tsconfig.json ./

RUN npm run build

CMD ["node", "./build/index.js"]