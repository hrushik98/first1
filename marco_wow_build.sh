sudo docker image build -t gcr.io/gpt-j-and-gpt-neox20b/marco_wow:latest -f deployment.Dockerfile --build-arg MODEL_NAME=marco_wow .
sudo docker push gcr.io/gpt-j-and-gpt-neox20b/marco_wow:latest