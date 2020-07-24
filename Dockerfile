FROM ubuntu:18.04

ARG SONAR_SCANNER_HOME=/opt/sonar-scanner
ENV SONAR_USER_HOME=${SONAR_SCANNER_HOME}/.sonar \
    SONAR_SCANNER_VERSION=4.4.0.2170 \
    ANDROID_HOME="/opt/android-sdk" \
    PATH="/opt/android-sdk/tools/bin:/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:${SONAR_SCANNER_HOME}/bin:$PATH"

RUN apt-get update > /dev/null \
    && apt-get -y install --no-install-recommends curl git lib32stdc++6 openjdk-8-jdk-headless unzip wget > /dev/null \
    && apt-get --purge autoremove > /dev/null \
    && apt-get autoclean > /dev/null \
    && rm -rf /var/lib/apt/lists/*

RUN git clone -b stable https://github.com/flutter/flutter.git /opt/flutter

RUN curl -s -O https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip \
    && mkdir /opt/android-sdk \
    && unzip sdk-tools-linux-4333796.zip -d /opt/android-sdk > /dev/null \
    && rm sdk-tools-linux-4333796.zip

RUN mkdir ~/.android \
    && echo 'count=0' > ~/.android/repositories.cfg \
    && yes | sdkmanager --licenses > /dev/null \
    && sdkmanager "tools" "build-tools;29.0.0" "platforms;android-29" "platform-tools" > /dev/null \
    && yes | sdkmanager --licenses > /dev/null \
    && flutter doctor -v \
    && chown -R root:root /opt

RUN set -ex \
    && curl -s -O https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip \
    && mkdir ${SONAR_SCANNER_HOME} \
    && unzip sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip -d ${SONAR_SCANNER_HOME} > /dev/null \
    && rm sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip \
    && echo `which sonar-scanner`
