#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# Menu Auto Hide
#
# This snippet depends on 10_reset_boot_success and needs to be kept in sync.
#
# Disable / skip generating menu-auto-hide config parts on serial terminals
for x in ${GRUB_TERMINAL_INPUT} ${GRUB_TERMINAL_OUTPUT}; do
  case "$x" in
    serial*)
      exit 0
      ;;
  esac
done

cat << EOF
if [ x\$feature_timeout_style = xy ] ; then
  if [ "\${menu_show_once}" ]; then
    unset menu_show_once
    save_env menu_show_once
    set timeout_style=menu
    set timeout=60
  elif [ "\${menu_auto_hide}" -a "\${menu_hide_ok}" = "1" ]; then
    set orig_timeout_style=\${timeout_style}
    set orig_timeout=\${timeout}
    if [ "\${fastboot}" = "1" ]; then
      # timeout_style=menu + timeout=0 avoids the countdown code keypress check
      set timeout_style=menu
      set timeout=0
    else
      set timeout_style=hidden
      set timeout=1
    fi
  fi
fi
EOF
