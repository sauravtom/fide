#!/bin/sh
set -eux

# This script is written to be as POSIX as possible
# so it works fine for all Unix-like operating systems

test_cmd() {
  command -v "$1" >/dev/null
}

# proxy version
fide_new_ver="${1}"
# proxy directory
# eval to resolve '~' into proper user dir
eval fide_dir="'${2}'"

case "${fide_new_ver}" in
  v*)
    fide_new_version=$(echo "${fide_new_ver}" | cut -d'v' -f2)
    fide_new_ver_tag="${fide_new_ver}"
  ;;
  nightly*)
    fide_new_version="${fide_new_ver}"
    fide_new_ver_tag=$(echo ${fide_new_ver} | cut -d '-' -f1)
  ;;
  *)
    printf 'Unknown version\n'
    exit 1
  ;;
esac

if [ -e "${fide_dir}/fide" ]; then
  fide_installed_ver=$("${fide_dir}/fide" --version | cut -d' ' -f2)

  printf '[DEBUG]: Current proxy version: %s\n' "${fide_installed_ver}"
  printf '[DEBUG]: New proxy version: %s\n' "${fide_new_version}"
  if [ "${fide_installed_ver}" = "${fide_new_version}" ]; then
    printf 'Proxy already exists\n'
    exit 0
  else
    printf 'Proxy outdated. Replacing proxy\n'
    rm "${fide_dir}/fide"
  fi
fi

for _cmd in tar gzip uname; do
  if ! test_cmd "${_cmd}"; then
    printf 'Missing required command: %s\n' "${_cmd}"
    exit 1
  fi
done

# Currently only linux/darwin are supported
case $(uname -s) in
  Linux) os_name=linux ;;
  Darwin) os_name=darwin ;;
  *)
    printf '[ERROR] unsupported os\n'
    exit 1
  ;;
esac

# Currently only amd64/arm64 are supported
case $(uname -m) in
  x86_64|amd64|x64) arch_name=x86_64 ;;
  arm64|aarch64) arch_name=aarch64 ;;
  # riscv64) arch_name=riscv64 ;;
  *)
    printf '[ERROR] unsupported arch\n'
    exit 1
  ;;
esac

fide_download_url="https://github.com/fide/fide/releases/download/${fide_new_ver_tag}/fide-proxy-${os_name}-${arch_name}.gz"

printf 'Creating "%s"\n' "${fide_dir}"
mkdir -p "${fide_dir}"
cd "${fide_dir}"

if test_cmd 'curl'; then
  # How old curl has these options? we'll find out
  printf 'Downloading using curl\n'
  curl --proto '=https' --tlsv1.2 -LfS -O "${fide_download_url}"
  # curl --proto '=https' --tlsv1.2 -LZfS -o "${tmp_dir}/fide-proxy-${os_name}-${arch_name}.gz" "${fide_download_url}"
elif test_cmd 'wget'; then
  printf 'Downloading using wget\n'
  wget "${fide_download_url}"
else
  printf 'curl/wget not found, failed to download proxy\n'
  exit 1
fi

printf 'Decompressing gzip\n'
gzip -df "${fide_dir}/fide-proxy-${os_name}-${arch_name}.gz"

printf 'Renaming proxy \n'
mv -v "${fide_dir}/fide-proxy-${os_name}-${arch_name}" "${fide_dir}/fide"

printf 'Making it executable\n'
chmod +x "${fide_dir}/fide"

printf 'fide-proxy installed\n'

exit 0
