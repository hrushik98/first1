sudo docker image build -t gcr.io/gpt-j-and-gpt-neox20b/msmarco_split:latest -f deployment.Dockerfile --build-arg MODEL_NAME=msmarco_split .
sudo docker push gcr.io/gpt-j-and-gpt-neox20b/msmarco_split:latest