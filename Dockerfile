FROM php:8.1-apache-buster

ENV PATH $PATH:/root/.composer/vendor/bin

# PHP extensions come first, as they are less likely to change between Yii releases
RUN apt-get update \
    && apt-get -y install \
    git \
    g++ \
    libicu-dev \
    zlib1g-dev \
    zip \
    unzip \
    vim \
    python-dev \
    libzip-dev \
    libonig-dev \
    --no-install-recommends \
    # Install pip and awscli
    && curl https://bootstrap.pypa.io/pip/2.7/get-pip.py | python \
    && pip install awscli --upgrade \
    # # Enable mod_rewrite
    && a2enmod rewrite \
    # # Install PHP extensions
    && docker-php-ext-install intl \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install opcache \
    && docker-php-ext-install zip \
    && pecl install apcu-5.1.22 && echo extension=apcu.so > /usr/local/etc/php/conf.d/apcu.ini \
    # # Fix write permissions with shared folders
    && usermod -u 1000 www-data

# Next composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer.phar \
    && export COMPOSER_HOME=/root && /usr/local/bin/composer.phar self-update 1.10.26

# NPM and yarn
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash \
    && export NVM_DIR="$HOME/.nvm" \
    && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
    && nvm install 14 \
    && npm i -g yarn

# Apache config and composer wrapper
COPY apache2.conf /etc/apache2/apache2.conf
COPY composer /usr/local/bin/composer

WORKDIR /var/www/html
