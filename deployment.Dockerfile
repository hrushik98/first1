FROM python:3.10
RUN python3 -m pip install --upgrade pip setuptools --no-warn-script-location
RUN python3 -m pip install torch torchvision torchaudio transformers --extra-index-url https://download.pytorch.org/whl/cu116 --no-warn-script-location
RUN python3 -c 'from transformers import AutoTokenizer; AutoTokenizer.from_pretrained("EleutherAI/gpt-j-6B")'

WORKDIR /app
VOLUME /app/model/

COPY requirements.txt requirements.txt
RUN pip3 install --upgrade -r requirements.txt
COPY deployment.py deployment.py

ARG MODEL_NAME
ENV MODEL_NAME=${MODEL_NAME}
EXPOSE 5000

CMD [ "uvicorn", "deployment:app", "--host", "0.0.0.0", "--port", "5000" ]