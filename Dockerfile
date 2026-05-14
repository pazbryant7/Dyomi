FROM eclipse-temurin:17-jdk-jammy

RUN apt-get update && apt-get install -y \
  wget \
  unzip \
  git \
  && rm -rf /var/lib/apt/lists/*

ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

RUN mkdir -p $ANDROID_HOME/cmdline-tools

RUN wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O /tmp/cmdline-tools.zip \
  && unzip -q /tmp/cmdline-tools.zip -d /tmp/cmdline-tools \
  && mv /tmp/cmdline-tools/cmdline-tools $ANDROID_HOME/cmdline-tools/latest \
  && rm -rf /tmp/cmdline-tools.zip /tmp/cmdline-tools

RUN yes | sdkmanager --licenses > /dev/null 2>&1 \
  && sdkmanager \
  "build-tools;35.0.0" \
  "platforms;android-36"

ENV GRADLE_USER_HOME=/root/.gradle

ARG PROJ_DIR=/project

WORKDIR ${PROJ_DIR}

RUN git config --global --add safe.directory ${PROJ_DIR}
