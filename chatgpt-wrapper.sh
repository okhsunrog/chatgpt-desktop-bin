#!/bin/sh

has_ozone_platform=false
for arg do
  case $arg in
    --ozone-platform=*) has_ozone_platform=true ;;
  esac
done

if [ -n "${WAYLAND_DISPLAY:-}" ] && [ "$has_ozone_platform" = false ]; then
  set -- --ozone-platform=wayland "$@"
fi

exec /usr/lib/chatgpt/ChatGPT "$@"
