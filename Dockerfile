FROM php:8.0-fpm

COPY composer.* /var/www/laravel-telescope/
WORKDIR /var/www/laravel-telescope

RUN apt-get update && apt-get install -y \
    build-essential \
    libmcrypt-dev \
    mariadb-client \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    libzip-dev \
    zip \
    unixodbc-dev \
    gnupg \
    gpg

# Tambah repo Microsoft untuk Debian 12
RUN curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft-prod.gpg
RUN curl https://packages.microsoft.com/config/debian/12/prod.list | tee /etc/apt/sources.list.d/mssql-release.list

# Install ODBC Driver 18 (karena msodbcsql17 tidak ada di Debian 12)
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql18 mssql-tools18

# Install SQLSRV & PDO_SQLSRV
RUN pecl install sqlsrv-5.11.1 && pecl install pdo_sqlsrv-5.11.1
RUN docker-php-ext-enable sqlsrv pdo_sqlsrv

# Bersih-bersih
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install ekstensi lain
RUN docker-php-ext-install pdo pdo_mysql gd zip bcmath sockets

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Tambah user www
RUN groupadd -g 1000 www && useradd -u 1000 -ms /bin/bash -g www www

COPY . .
COPY --chown=www:www . .

USER www
EXPOSE 9000
CMD ["php-fpm"]