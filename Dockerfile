#Stage 1 - Install dependencies and build the app in a build environment
FROM node:21.7.3 AS build

# FROM nginx:alpine AS build
# Install flutter dependencies
RUN apt-get update
RUN apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback python3
RUN apt-get clean
# Clone the flutter repo
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Set flutter environment path
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Run flutter doctor
RUN flutter doctor -v
RUN flutter channel master
RUN flutter upgrade

# Copy files to container and build
RUN mkdir /app/
WORKDIR /app/
COPY ./ /app/
RUN flutter clean
# RUN flutter build web --release --base-href "/frontend/"
RUN flutter build web --release
# RUN flutter build web

EXPOSE 8081


FROM nginx
COPY --from=build ./app/build/web ./usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/conf.d/default.conf