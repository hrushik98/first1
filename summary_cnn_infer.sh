directory="summary_cnn"
bucket="gptjax_model_weights"
folder="summary_cnn_slim_f16"

if [ ! -d "${directory}" ]; then
  mkdir ${directory}
fi

if [ ! -f "${directory}/config.json" ]; then
  gsutil -m cp "gs://${bucket}/${folder}/hf_weights/config.json" ${directory}/.
fi

if [ ! -f "${directory}/pytorch_model.bin" ]; then
  gsutil -m cp "gs://${bucket}/${folder}/hf_weights/pytorch_model.bin" ${directory}/.
fi

# sudo docker pull gcr.io/gpt-j-and-gpt-neox20b/summary_cnn:latest
sudo docker container run --name summary_cnn --restart always -d -p 75:5000 -v $(pwd)/summary_cnn/:/app/model/ gcr.io/gpt-j-and-gpt-neox20b/summary_cnn:latest
watch -n 1 sudo docker container logs --tail 25 summary_cnn