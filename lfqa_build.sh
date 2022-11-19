sudo docker image build -t gcr.io/gpt-j-and-gpt-neox20b/lfqa:latest -f deployment.Dockerfile --build-arg MODEL_NAME=lfqa .
sudo docker push gcr.io/gpt-j-and-gpt-neox20b/lfqa:latest