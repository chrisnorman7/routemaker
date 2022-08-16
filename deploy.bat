@echo off
flutter build web --base-href /routemaker/ --release & scp -Cr build\web\* root@backstreets.site:/var/www/html/routemaker
