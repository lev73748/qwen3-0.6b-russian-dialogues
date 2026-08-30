# qwen3-0.6b-russian-dialogues

Полный файнтюнинг [Qwen/Qwen3-0.6B](https://huggingface.co/Qwen/Qwen3-0.6B) для генерации ответов в русских диалогах: обновлялись все веса модели, без LoRA и адаптеров.

Обучена на датасете [Den4ikAI/russian_dialogues](https://huggingface.co/datasets/Den4ikAI/russian_dialogues).

| | |
|---|---|
| Базовая модель | Qwen/Qwen3-0.6B (`unsloth/Qwen3-0.6B-Base`) |
| Тип обучения | full fine-tuning (все параметры) |
| Архитектура | `Qwen3ForCausalLM`, 28 слоёв, hidden 1024, 16 голов внимания |
| Контекст | 32 768 токенов |
| Словарь | 151 936 токенов, `Qwen2Tokenizer` |
| Язык | русский |
| Лицензия | Apache 2.0 |

## Что лежит в репозитории

```
config/    конфигурация модели и токенизатор
gguf/      квантованные веса Q4_K_M (397 МБ, Git LFS)
scripts/   примеры запуска
```

Полные веса в формате `safetensors` (2.4 ГБ, float32) в GitHub не влезают — они лежат на Hugging Face:

- [ya-yje-krasni/qwen3-0.6b-russian-dialogues](https://huggingface.co/ya-yje-krasni/qwen3-0.6b-russian-dialogues) — основная версия, полные веса
- [Lev384501/qwen3-0.6b-russian-dialogues-Q4_K_M-GGUF](https://huggingface.co/Lev384501/qwen3-0.6b-russian-dialogues-Q4_K_M-GGUF) — GGUF Q4_K_M
- [Lev384501/qwen3-0.6b-russian-dialogues-Q8_0-GGUF](https://huggingface.co/Lev384501/qwen3-0.6b-russian-dialogues-Q8_0-GGUF) — GGUF Q8_0

## Формат промпта

Модель обучена на шаблоне с явным маркером ответа:

```
<текст вопроса или реплики>
### Ответ:
```

Генерация продолжает текст после `### Ответ:`.

## Быстрый старт

### llama.cpp с локальным GGUF

```bash
git lfs install
git clone https://github.com/lev73748/qwen3-0.6b-russian-dialogues.git
cd qwen3-0.6b-russian-dialogues

llama-cli -m gguf/qwen3-0.6b-russian-dialogues-q4_k_m.gguf \
  -p $'Привет, как дела?\n### Ответ:' -n 128
```

Или готовым скриптом:

```bash
./scripts/run_llama_cpp.sh "Привет, как дела?"
```

Поднять локальный сервер с OpenAI-совместимым API на порту 8080:

```bash
./scripts/serve_llama_cpp.sh
```

### transformers

```bash
pip install -r requirements.txt
python scripts/infer_transformers.py "Расскажи анекдот про программиста"
```

Скрипт тянет полные веса с Hugging Face, локальный GGUF для этого не нужен.

## Клонирование без больших файлов

Если GGUF на 397 МБ не нужен:

```bash
GIT_LFS_SKIP_SMUDGE=1 git clone https://github.com/lev73748/qwen3-0.6b-russian-dialogues.git
```

## Лицензия

Apache 2.0 — см. [LICENSE](LICENSE). Базовая модель Qwen3 распространяется под той же лицензией.
