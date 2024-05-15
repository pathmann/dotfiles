#!/usr/bin/env bash
# makepkg wrapper that calls customizepkg first
# credits to: shiraneyo (https://github.com/Jguer/yay/issues/336#issuecomment-813433797)
set -euf -o pipefail +o history

CURRENT_DIR_PATH="$(readlink -f "$(realpath -e "$(pwd)")")"
GLOBAL_CONF_DIR_PATH='/etc/customizepkg.d'
USER_CONF_DIR_PATH="${HOME}/.customizepkg"

pkgbuild_path="${CURRENT_DIR_PATH}/PKGBUILD"
pkgbuild_copy_path="${pkgbuild_path}.original"

function is_readable_file {
  local file_path="${1:-''}"
  local ret=1
  if [[ (-n "$file_path") && (-f "$file_path") && (-r "$file_path") ]];then
    ret=0
  fi
  return $ret
}

if  is_readable_file "$pkgbuild_path" &&
    ! is_readable_file "$pkgbuild_copy_path";then
  source "$pkgbuild_path"
  if [[ -n "${pkgname:-''}" ]];then
    global_conf_path="${GLOBAL_CONF_DIR_PATH}/${pkgname}"
    user_conf_path="${USER_CONF_DIR_PATH}/${pkgname}"
    if  is_readable_file "$global_conf_path" ||
        is_readable_file "$user_conf_path";then
      customizepkg --modify
    fi
  fi
fi

exec /usr/bin/makepkg ${@}
