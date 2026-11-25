FROM public.ecr.aws/docker/library/node:20.18.1-bookworm-slim
WORKDIR /app
COPY package*.json ./
RUN npm install -g npm@10.9.2 && npm ci --omit=dev && npm cache clean --force
COPY . .
USER node
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health',r=>process.exit(r.statusCode===200?0:1)).on('error',()=>process.exit(1))"
CMD ["node", "server.js"]
