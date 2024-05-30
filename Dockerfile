FROM node:20-slim as builder
WORKDIR /usr/src/app
COPY package.json .
COPY package-lock.json* .
RUN npm ci

FROM alpine/git:latest as content-grabber
# example: 
#  - for a private repo: "myuser:mypassword"
#  - for a public repo: just "git"
ARG BITBUCKET_APP_CREDENTIALS
ENV BITBUCKET_APP_CREDENTIALS=$BITBUCKET_APP_CREDENTIALS
WORKDIR /
RUN git clone "https://$BITBUCKET_APP_CREDENTIALS@bitbucket.org/volabit/dev-docs.git" content


FROM node:20-slim
WORKDIR /usr/src/app
COPY --from=builder /usr/src/app/ /usr/src/app/
COPY --from=content-grabber /content /usr/src/app/content
COPY . .
CMD ["npx", "quartz", "build", "--serve"]
