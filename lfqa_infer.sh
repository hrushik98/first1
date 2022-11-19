directory="lfqa"
bucket="gptjax_model_weights"
folder="reddit_lfqa_slim_f16"

if [ ! -d "${directory}" ]; then
  mkdir ${directory}
fi

if [ ! -f "${directory}/config.json" ]; then
  gsutil -m cp "gs://${bucket}/${folder}/hf_weights/config.json" ${directory}/.
fi

if [ ! -f "${directory}/pytorch_model.bin" ]; then
  gsutil -m cp "gs://${bucket}/${folder}/hf_weights/pytorch_model.bin" ${directory}/.
fi

# sudo docker pull gcr.io/gpt-j-and-gpt-neox20b/lfqa:latest
sudo docker container run --name lfqa --restart always -d -p 80:5000 -v $(pwd)/lfqa/:/app/model/ gcr.io/gpt-j-and-gpt-neox20b/lfqa:latest
watch -n 1 sudo docker container logs --tail 25 lfqa