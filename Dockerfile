FROM nginx:1.27-alpine

COPY ./frontend/dist /usr/share/nginx/html

EXPOSE 80
