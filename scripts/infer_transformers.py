#!/usr/bin/env python3
"""Генерация ответа моделью qwen3-0.6b-russian-dialogues через transformers.

Веса подтягиваются с Hugging Face при первом запуске.

Пример:
    python scripts/infer_transformers.py "Привет, как дела?"
"""

import argparse

import torch
from transformers import AutoModelForCausalLM, AutoTokenizer

MODEL_ID = "ya-yje-krasni/qwen3-0.6b-russian-dialogues"
PROMPT_TEMPLATE = "{text}\n### Ответ:"


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("text", help="Реплика или вопрос к модели")
    parser.add_argument("--model", default=MODEL_ID, help="ID модели на Hugging Face или локальный путь")
    parser.add_argument("--max-new-tokens", type=int, default=128)
    parser.add_argument("--temperature", type=float, default=0.7)
    parser.add_argument("--top-p", type=float, default=0.9)
    args = parser.parse_args()

    device = "cuda" if torch.cuda.is_available() else "cpu"
    dtype = torch.float16 if device == "cuda" else torch.float32

    tokenizer = AutoTokenizer.from_pretrained(args.model)
    model = AutoModelForCausalLM.from_pretrained(args.model, dtype=dtype).to(device)
    model.eval()

    prompt = PROMPT_TEMPLATE.format(text=args.text)
    inputs = tokenizer(prompt, return_tensors="pt").to(device)

    with torch.inference_mode():
        output = model.generate(
            **inputs,
            max_new_tokens=args.max_new_tokens,
            temperature=args.temperature,
            top_p=args.top_p,
            do_sample=True,
            pad_token_id=tokenizer.pad_token_id,
        )

    generated = output[0][inputs["input_ids"].shape[-1]:]
    print(tokenizer.decode(generated, skip_special_tokens=True).strip())


if __name__ == "__main__":
    main()
