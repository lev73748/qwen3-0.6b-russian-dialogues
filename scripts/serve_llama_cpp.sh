#!/usr/bin/env bash
# Локальный OpenAI-совместимый сервер на llama.cpp с GGUF Q4_K_M.
#
#   ./scripts/serve_llama_cpp.sh            # порт 8080
#   PORT=9000 ./scripts/serve_llama_cpp.sh
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MODEL="${MODEL:-$REPO_ROOT/gguf/qwen3-0.6b-russian-dialogues-q4_k_m.gguf}"
PORT="${PORT:-8080}"
CTX="${CTX:-4096}"

if [ ! -s "$MODEL" ]; then
  echo "Не найден файл модели: $MODEL" >&2
  echo "Убедитесь, что установлен git-lfs и файлы выгружены: git lfs install && git lfs pull" >&2
  exit 1
fi

if ! command -v llama-server >/dev/null 2>&1; then
  echo "llama-server не найден. Установите llama.cpp, например: brew install llama.cpp" >&2
  exit 1
fi

echo "Сервер запускается на http://localhost:$PORT"
llama-server -m "$MODEL" -c "$CTX" --port "$PORT"
