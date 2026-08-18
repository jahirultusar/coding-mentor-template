#!/bin/bash
set -e
# Create a user matching the host UID/GID so tools have a proper /etc/passwd
# entry, a home directory, and correct ownership.
USER_ID="${LOCAL_UID:-1000}"
GROUP_ID="${LOCAL_GID:-1000}"

if ! getent group "$GROUP_ID" > /dev/null 2>&1; then
    groupadd --gid "$GROUP_ID" mentor
fi

if ! getent passwd "$USER_ID" > /dev/null 2>&1; then
    useradd --uid "$USER_ID" --gid "$GROUP_ID" \
        --create-home --shell /bin/bash mentor
fi

HOME_DIR="$(getent passwd "$USER_ID" | cut -d: -f6)"
# Ensure the home directory exists and is owned by the target user
mkdir -p "$HOME_DIR"
chown "$USER_ID:$GROUP_ID" "$HOME_DIR"
export HOME="$HOME_DIR"

exec gosu "$USER_ID:$GROUP_ID" "$@"
