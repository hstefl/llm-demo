from transformers import AutoTokenizer, AutoModelForCausalLM, pipeline
import torch

model_id = "meta-llama/Llama-3.1-8B-Instruct"

print("🔄 Loading tokenizer...")
tokenizer = AutoTokenizer.from_pretrained(model_id, use_auth_token=True)

print("🧠 Loading model...")
model = AutoModelForCausalLM.from_pretrained(
    model_id,
    device_map="auto",
    torch_dtype=torch.bfloat16 if torch.cuda.is_bf16_supported() else torch.float16
)

pipe = pipeline("text-generation", model=model, tokenizer=tokenizer)

print("✅ LLaMA 3.1 loaded! Start chatting.\n")

# Stateless chat loop
while True:
    user_input = input("You: ")
    if user_input.lower().strip() in {"exit", "quit"}:
        break

    prompt = f"<|begin_of_text|><|start_header_id|>user<|end_header_id|>\n{user_input}\n<|start_header_id|>assistant<|end_header_id|>\n"
    output = pipe(prompt, max_new_tokens=512, do_sample=True, temperature=0.7)[0]["generated_text"]
    response = output.replace(prompt, "").strip()

    print("LLaMA:", response)
