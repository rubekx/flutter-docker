FROM ubuntu:20.04

# The option 'noninteractive' is set as default value for the build-time only.
ARG DEBIAN_FRONTEND=noninteractive

# Update and upgrade the system
RUN apt-get update && apt-get upgrade -y

# Installing apt-utils
RUN apt-get install -yq apt-utils

# Prerequisites
RUN apt-get update && apt-get install -yq \
    git \
    zip \
    curl \
    nano \
    unzip \
    g++ \
    apt-utils \ 
    xz-utils \
    zip libglu1-mesa \
    openjdk-8-jdk \ 
    wget

# Set up new user
RUN useradd -ms /bin/bash developer
USER developer
WORKDIR /home/developer

# Prepare Android directories and system variables
RUN mkdir -p Android/sdk
ENV ANDROID_SDK_ROOT /home/developer/Android/sdk
RUN mkdir -p .android && touch .android/repositories.cfg

# Set up Android SDK
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
RUN unzip sdk-tools.zip && rm sdk-tools.zip
RUN mv tools Android/sdk/tools
RUN cd Android/sdk/tools/bin && yes | ./sdkmanager --licenses
RUN cd Android/sdk/tools/bin && ./sdkmanager --install "cmdline-tools;latest"
RUN cd Android/sdk/tools/bin && ./sdkmanager "build-tools;29.0.2" "patcher;v4" "platform-tools" "platforms;android-29" "sources;android-29"
ENV PATH "$PATH:/home/developer/Android/sdk/platform-tools"

# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git
ENV PATH "$PATH:/home/developer/flutter/bin"

# Run `flutter doctor --android-licenses` to accept the SDK licenses. 
RUN flutter doctor --android-licenses

# Run basic check to download Dark SDK
RUN flutter doctor
