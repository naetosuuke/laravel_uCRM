# ベースイメージとしてPHP 8.1を使用
FROM php:8.1-fpm

# Node.js と npm をインストール
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs

# Composerと必要なパッケージをインストール
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install zip pdo pdo_mysql

# Composerのインストール
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 作業ディレクトリを設定
WORKDIR /var/www/html

# コンテナ内の作業ディレクトリにプロジェクトをコピー
COPY . .

# 依存パッケージをインストール
RUN composer install

# npm installを実行
RUN npm install

# 権限を変更
RUN chown -R www-data:www-data /var/www/html

# アプリケーションを起動するコマンド
CMD ["php-fpm"]
