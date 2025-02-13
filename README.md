Laravel Dockerfile
===

```shell

docker pull sym134/docker-octane:php8.2-alpine
```

docker build \
--build-arg INSTALLER_BASE_URL="https://github.com/mlocati/docker-php-extension-installer/releases" \
--build-arg SCHEDULE_CRONTAB="* * * * * cd /var/www && php artisan schedule:run >> /dev/null 2>&1" \
-t your_image_name:tag .

## 运行
```shell

docker run -d \
  -p 9000:9000 \
  -p 8000:8000 \
  -p 6001:6001 \
  -v /path/to/your/app:/app \
  --name laravel-container \
  your_image_name:tag
```


docker build -t sym134/laravel-octane:php8.2-alpine .

docker login 

docker push sym134/laravel-octane:php8.2-alpine  