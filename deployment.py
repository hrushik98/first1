import os
import json
import torch
import logging
import uvicorn
from datetime import datetime
from time import perf_counter
from fastapi import FastAPI, Request, Response
from transformers import GPTJForCausalLM, AutoTokenizer

logger = logging.getLogger(__name__)
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
logger.info(f"Using device {device}")
print(f"Using device {device}")
[print(torch.cuda.get_device_properties(i)) for i in range(torch.cuda.device_count())] if torch.cuda.is_available() else print('cpu')

model_name = os.environ.get("MODEL_NAME")
model_name_or_path = "EleutherAI/gpt-j-6B"
model_name_or_path = "./model/"
tokenizer_name_or_path = "EleutherAI/gpt-j-6B"

s = perf_counter()
model = GPTJForCausalLM.from_pretrained(model_name_or_path).to(device)
e = perf_counter()
logger.info(f"Model loading completed successfully! Time taken: {e-s:.3f} seconds")
print(f"Model loading completed successfully! Time taken: {e-s:.3f} seconds")

s = perf_counter()
tokenizer = AutoTokenizer.from_pretrained(tokenizer_name_or_path)
e  = perf_counter()
logger.info(f"Tokenizer loading completed successfully! Time taken: {e-s:.3f} seconds")
print(f"Tokenizer loading completed successfully! Time taken: {e-s:.3f} seconds")


async def inference(
        prompt: str, model: GPTJForCausalLM, tokenizer: AutoTokenizer, 
        do_sample: bool = True, num_beam: int = None, temperature: float = None, 
        top_k: int = None, top_p: int = None, max_length: int = 128
    ) -> list:
    s = perf_counter()
    input_ids = tokenizer(prompt, return_tensors="pt").input_ids
    gen_tokens = model.generate(
        input_ids,
        do_sample=do_sample,
        num_beam=num_beam,
        temperature=temperature,
        max_length=max_length,
        top_p=top_p,
        top_k=top_k,
    )
    e = perf_counter()
    print(f"Time taken {e-s} seconds")
    logger.info(f"Time taken {e-s} seconds")
    return tokenizer.batch_decode(gen_tokens)


app = FastAPI()


@app.get("/")
async def index():
    logger.info(f"[{model_name}] Status checked at {datetime.now()}")
    print(f"[{model_name}] Status checked at {datetime.now()}")
    return Response(json.dumps({"status": "ok"}), 200, headers={"Content-Type": "application/json"})


@app.get(f"/{model_name}")
async def status():
    logger.info(f"Status of {model_name} checked at {datetime.now()}")
    print(f"Status of {model_name} checked at {datetime.now()}")
    return Response(json.dumps({"status": "ok"}), 200, headers={"Content-Type": "application/json"})


@app.post(f"/{model_name}/generate")
async def generate(request: Request):
    ip = request.client.host
    try:
        logger.info(f"Started inference at {datetime.now()} by {ip}")
        print(f"Started inference at {datetime.now()} by {ip}")
        data = await request.json()
        if "prompt" not in data:
            return Response(json.dumps({"status": "error", "message": "'prompt' not in json data"}), 400, headers={"Content-Type": "application/json"})
        num_beam = int(data["num_beam"]) if "num_beam" in data else None
        temperature = float(data["temperature"]) if "temperature" in data else None
        top_k = int(data["top_k"]) if "top_k" in data else None
        top_p = float(data["top_p"]) if "top_p" in data else None
        max_length = int(data["max_length"]) if "max_length" in data else 512
        messages = await inference(
            str(data["prompt"]), model, tokenizer, max_length=max_length, 
            temperature=temperature, top_k=top_k, top_p=top_p, num_beam=num_beam
        )
        logger.info(f"Ended inference at {datetime.now()} by {ip}")
        print(f"Ended inference at {datetime.now()} by {ip}")
        return Response(json.dumps({"status": "ok", "message": messages[0]}), 201, headers={"Content-Type": "application/json"})
    except Exception as e:
        return Response(json.dumps({"status": "error", "message": str(e)}), 500, headers={"Content-Type": "application/json"})