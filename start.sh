#!/bin/bash
set -euo pipefail

# Default values (bisa dioverride lewat environment variable)
: "${PEAK_URL:=https://github.com/kryptex-miners-org/kryptex-miners/releases/download/peakminer-2-18-3/peakminer-2.18.3.tar.gz}"
: "${TARNAME:=peakminer-2.18.3.tar.gz}"
: "${BINNAME:=peakminer}"
: "${COIN:=pearl}"
: "${POOL:=stratum+tcp://prl.kryptex.network:7048}"
: "${WALLET:=prl1pjp3jd7ue653f6zyrn9ewwu7lalw538kn5w2l4lekv0g3nxqlj23qnwg6g0/ikuk}"
: "${EXTRA_ARGS:=}"

cd "${WORKDIR}"

# Download only if not present
if [ ! -f "${TARNAME}" ] && [ ! -x "./${BINNAME}" ]; then
  echo "Mengunduh ${PEAK_URL} ..."
  wget -q --show-progress "${PEAK_URL}" -O "${TARNAME}"
fi

# Extract if binary not present
if [ ! -x "./${BINNAME}" ]; then
  echo "Mengekstrak ${TARNAME} ..."
  tar xzf "${TARNAME}"
  # Pastikan executable
  if [ -f "./${BINNAME}" ]; then
    chmod +x "./${BINNAME}"
  else
    echo "Error: binary ${BINNAME} tidak ditemukan setelah ekstraksi" >&2
    ls -la
    exit 1
  fi
fi

echo "Menjalankan ${BINNAME} untuk coin=${COIN}, pool=${POOL}"
# Exec agar menerima sinyal dari Docker / RunPod dan proses utama menjadi binary
exec ./peakminer --coin "${COIN}" -o "${POOL}" -u "${WALLET}" ${EXTRA_ARGS}
