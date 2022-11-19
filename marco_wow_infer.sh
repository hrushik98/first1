directory="marco_wow"
bucket="gptjax_model_weights"
folder="reddit_marco_wow_slim_f16"

if [ ! -d "${directory}" ]; then
  mkdir ${directory}
fi

if [ ! -f "${directory}/config.json" ]; then
  gsutil -m cp "gs://${bucket}/${folder}/hf_weights/config.json" ${directory}/.
fi

if [ ! -f "${directory}/pytorch_model.bin" ]; then
  gsutil -m cp "gs://${bucket}/${folder}/hf_weights/pytorch_model.bin" ${directory}/.
fi

# sudo docker pull gcr.io/gpt-j-and-gpt-neox20b/marco_wow:latest
sudo docker container run --name marco_wow --restart always -d -p 90:5000 -v $(pwd)/marco_wow/:/app/model/ gcr.io/gpt-j-and-gpt-neox20b/marco_wow:latest
watch -n 1 sudo docker container logs --tail 25 marco_wow