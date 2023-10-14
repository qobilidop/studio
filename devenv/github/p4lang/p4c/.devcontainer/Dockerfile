FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive

# Set locale
ENV LANG C.utf8

# Install common packages
RUN apt-get update && apt-get install -y \
    bash \
    build-essential \
    git

# Install some p4c dependencies here to save some time later
RUN apt-get update && apt-get install -y \
    clang \
    curl \
    llvm \
    python-is-python3 \
    python3 \
    python3-pip

# Create and switch to a non-root user
# https://code.visualstudio.com/remote/advancedcontainers/add-nonroot-user#_creating-a-nonroot-user
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
USER $USERNAME

# Switch to use Bash as default shell
ENTRYPOINT ["/bin/bash"]
