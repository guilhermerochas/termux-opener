#!/data/data/com.termux/files/usr/bin/env bash

function main() {
  local install_list=""

  if ! [[ "$OSTYPE" =~ "linux-android" ]]; then
    echo "this script is supposed to be run on Termux!"
    return 1
  fi

  for pkg in wget python3 ffmpeg; do
    if ! [[ -x $(command -v $pkg) ]]; then
      install_list="${install_list} ${pkg}"
    fi
  done

  if [[ -n $install_list ]]; then
    apt install ${install_list} -y
  fi

  pip install youtube-dl requests

  mkdir -p "$HOME/.config/youtube-dl"
  cat <<- EOF > $HOME/.config/youtube-dl/config
    --no-mtime
    -o /data/data/com.termux/files/home/storage/dcim/Youtube/%(title)s.%(ext)s
    -f "best[height<=480]"
  EOF

  mkdir -p "$HOME/bin"

  if ! [[ -f "$(pwd)/termux-url-opener" ]]; then
    echo "please make sure to execute the script on the same folder as the git repo!"
    return 1
  fi

  mv "$(pwd)/termux-url-opener" "$HOME/bin"
  chmod +x "$HOME/bin/termux-url-opener"
  termux-setup-storage
  termux-fix-shebang "$HOME/bin/termux-url-opener"

  echo "termux-url-opener ready to use :)"
  echo "you can now share videos and images from the supported list and download them automatically!"
}

main
