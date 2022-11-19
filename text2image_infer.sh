directory="text2image"
bucket="gptjax_model_weights"
folder="text2image_slim_f16"

if [ ! -d "${directory}" ]; then
  mkdir ${directory}
fi

if [ ! -f "${directory}/config.json" ]; then
  gsutil -m cp "gs://${bucket}/${folder}/hf_weights/config.json" ${directory}/.
fi

if [ ! -f "${directory}/pytorch_model.bin" ]; then
  gsutil -m cp "gs://${bucket}/${folder}/hf_weights/pytorch_model.bin" ${directory}/.
fi

# sudo docker pull gcr.io/gpt-j-and-gpt-neox20b/text2image:latest
sudo docker container run --name text2image --restart always -d -p 80:5000 -v $(pwd)/text2image/:/app/model/ gcr.io/gpt-j-and-gpt-neox20b/text2image:latest
watch -n 1 sudo docker container logs --tail 25 text2image