directory="marco_wow_win"
bucket="gpt-j-n-gpt-neo-phani"
folder="reddit_marco_wow_win_slim_f16"

if [ ! -d "${directory}" ]; then
  mkdir ${directory}
fi

if [ ! -f "${directory}/config.json" ]; then
  gsutil -m cp "gs://${bucket}/${folder}/hf_weights/config.json" ${directory}/.
fi

if [ ! -f "${directory}/pytorch_model.bin" ]; then
  gsutil -m cp "gs://${bucket}/${folder}/hf_weights/pytorch_model.bin" ${directory}/.
fi

# sudo docker pull gcr.io/gpt-j-and-gpt-neox20b/marco_wow_win:latest
sudo docker container run --name marco_wow_win --restart always -d -p 80:5000 -v $(pwd)/marco_wow_win/:/app/model/ gcr.io/gpt-j-n-gpt-neo-phani/marco_wow_win:latest
watch -n 1 sudo docker container logs --tail 25 marco_wow_win
