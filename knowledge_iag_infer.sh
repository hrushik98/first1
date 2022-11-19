directory="wow_knowledge_iag"
bucket="gptjax_model_weights"
folder="knowledge_iag_weights_slim_f16"

if [ ! -d "${directory}" ]; then
  mkdir ${directory}
fi

if [ ! -f "${directory}/config.json" ]; then
  gsutil -m cp "gs://${bucket}/${folder}/hf_weights/config.json" ${directory}/.
fi

if [ ! -f "${directory}/pytorch_model.bin" ]; then
  gsutil -m cp "gs://${bucket}/${folder}/hf_weights/pytorch_model.bin" ${directory}/.
fi

# sudo docker pull gcr.io/gpt-j-and-gpt-neox20b/wow_knowledge_iag:latest
sudo docker container run --name wow_knowledge_iag --restart always -d -p 80:5000 -v $(pwd)/wow_knowledge_iag/:/app/model/ gcr.io/gpt-j-and-gpt-neox20b/wow_knowledge_iag:latest
watch -n 1 sudo docker container logs --tail 25 wow_knowledge_iag