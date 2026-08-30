#!/usr/bin/env bash
# Одиночная генерация через llama.cpp с локальным GGUF Q4_K_M.
#
#   ./scripts/run_llama_cpp.sh "Привет, как дела?"
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MODEL="${MODEL:-$REPO_ROOT/gguf/qwen3-0.6b-russian-dialogues-q4_k_m.gguf}"
TOKENS="${TOKENS:-128}"

if [ $# -lt 1 ]; then
  echo "Использование: $0 \"текст вопроса\"" >&2
  exit 1
fi

if [ ! -s "$MODEL" ]; then
  echo "Не найден файл модели: $MODEL" >&2
  echo "Убедитесь, что установлен git-lfs и файлы выгружены: git lfs install && git lfs pull" >&2
  exit 1
fi

if ! command -v llama-cli >/dev/null 2>&1; then
  echo "llama-cli не найден. Установите llama.cpp, например: brew install llama.cpp" >&2
  exit 1
fi

llama-cli -m "$MODEL" -p "$1"$'\n### Ответ:' -n "$TOKENS" --no-display-prompt
