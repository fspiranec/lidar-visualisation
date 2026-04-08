FROM nginx:1.27-alpine

WORKDIR /usr/share/nginx/html

COPY index.html help.html how-to.html version.js ./

EXPOSE 80

