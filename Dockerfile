FROM node:24.15.0-bookworm

ARG OPENCODE_VERSION=latest

WORKDIR /app

RUN uname -m

RUN apt-get update && apt-get install -y curl git socat && rm -rf /var/lib/apt/lists/*


RUN npm i -g "opencode-ai@${OPENCODE_VERSION}" && \
  installed_version_raw="$(opencode --version)" && \
  installed_version="${installed_version_raw#v}" && \
  echo "Installed opencode version: ${installed_version}" && \
  if [ "${OPENCODE_VERSION}" != "latest" ] && [ "${installed_version}" != "${OPENCODE_VERSION}" ]; then \
    echo "Expected opencode version ${OPENCODE_VERSION}, got ${installed_version}" >&2; \
    exit 1; \
  fi

RUN curl -fsSL https://raw.githubusercontent.com/DeusData/codebase-memory-mcp/main/install.sh | bash -s -- --ui --skip-config && \
    mv /root/.local/bin/codebase-memory-mcp /usr/local/bin/codebase-memory-mcp



ARG USER_UID=1000
ARG USER_GID=1000

RUN if getent group ${USER_GID} >/dev/null; then \
      existing_group=$(getent group ${USER_GID} | cut -d: -f1); \
      echo "Group with GID ${USER_GID} already exists: ${existing_group}"; \
      if [ "${existing_group}" != "opencode" ]; then \
        groupmod -n opencode ${existing_group}; \
      fi; \
    else \
      groupadd -g ${USER_GID} opencode; \
    fi && \
    if getent passwd ${USER_UID} >/dev/null; then \
      existing_user=$(getent passwd ${USER_UID} | cut -d: -f1); \
      echo "User with UID ${USER_UID} already exists: ${existing_user}"; \
      if [ "${existing_user}" != "opencode" ]; then \
        usermod -l opencode -d /home/opencode -m ${existing_user}; \
      fi; \
    else \
      useradd -u ${USER_UID} -g opencode -m -s /bin/bash opencode; \
    fi




RUN mkdir -p /home/opencode/.local/share/opencode/ && \
  mkdir -p /home/opencode/.local/state/opencode && \
  mkdir -p /home/opencode/.config/opencode/ && \
  mkdir -p /home/opencode/workspace && \
  mkdir -p /home/opencode/.local/rules/opencode && \
  mkdir -p /home/opencode/.cache/codebase-memory-mcp && \
  chown -R opencode:opencode /home/opencode




USER opencode
