FROM nginx:alpine
RUN echo "<h1>Success! My ECS Cluster is running by github action!</h1>" > /usr/share/nginx/html/index.html
EXPOSE 80
