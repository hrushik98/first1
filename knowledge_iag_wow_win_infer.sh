directory="knowledge_iag_wow_win"
bucket="gptjax_model_weights"
folder="knowledge_iag_wow_win_slim_f16"

if [ ! -d "${directory}" ]; then
  mkdir ${directory}
fi

if [ ! -f "${directory}/config.json" ]; then
  gsutil -m cp "gs://${bucket}/${folder}/hf_weights/config.json" ${directory}/.
fi

if [ ! -f "${directory}/pytorch_model.bin" ]; then
  gsutil -m cp "gs://${bucket}/${folder}/hf_weights/pytorch_model.bin" ${directory}/.
fi

# sudo docker pull gcr.io/gpt-j-and-gpt-neox20b/knowledge_iag_wow_win:latest
sudo docker container run --name knowledge_iag_wow_win --restart always -d -p 75:5000 -v $(pwd)/knowledge_iag_wow_win/:/app/model/ gcr.io/gpt-j-and-gpt-neox20b/knowledge_iag_wow_win:latest
watch -n 1 sudo docker container logs --tail 25 knowledge_iag_wow_win