sudo docker image build -t gcr.io/gpt-j-and-gpt-neox20b/qna:latest -f deployment.Dockerfile --build-arg MODEL_NAME=qna .
sudo docker push gcr.io/gpt-j-and-gpt-neox20b/qna:latest