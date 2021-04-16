FROM php:7.4-apache

# Install Some Additional Packages
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    unzip \
    libaio1 \
    jpegoptim optipng pngquant gifsicle \
    curl \
    wget

# Remove Cache
RUN apt-get clean && rm -rf /var/lib/apt/lists*

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Prepare for OCI
RUN mkdir /opt/oracle \
    && cd /opt/oracle

# Download Oracle 21.1
RUN wget https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-basiclite-linux.x64-21.1.0.0.0.zip
RUN wget https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-sqlplus-linux.x64-21.1.0.0.0.zip
RUN wget https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-sdk-linux.x64-21.1.0.0.0.zip

# Install Oracle Instant Client 21.1
RUN unzip instantclient-basiclite-linux.x64-21.1.0.0.0.zip -d /opt/oracle \
    && unzip instantclient-sqlplus-linux.x64-21.1.0.0.0.zip -d /opt/oracle \
    && unzip instantclient-sdk-linux.x64-21.1.0.0.0.zip -d /opt/oracle \
    && rm -rf /opt/oracle/*.zip

# Setup Environment Variables
ENV LD_LIBRARY_PATH /opt/oracle/instantclient_21_1:${LD_LIBRARY_PATH}
ENV PATH /opt/oracle/instantclient_21_1:$PATH
ENV ORACLE_HOME instantclient,/opt/oracle/instantclient_21_1

RUN echo 'instantclient,/opt/oracle/instantclient_21_1/' | pecl install oci8 \
    && docker-php-ext enable oci8 \
    && docker-php-ext-configure pdo-oci --with-pdo-oci=instantclient,/opt/oracle/instantclient_21_1 \
    & docker-php-ext-install pdo_oci

