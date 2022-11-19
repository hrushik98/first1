sudo docker image build -t gcr.io/gpt-j-and-gpt-neox20b/text2image:latest -f deployment.Dockerfile --build-arg MODEL_NAME=text2image .
sudo docker push gcr.io/gpt-j-and-gpt-neox20b/text2image:latest