sudo docker image build -t gcr.io/neuralsearch-350415/marco_wow_win:latest -f deployment.Dockerfile --build-arg MODEL_NAME=marco_wow_win .
sudo docker push gcr.io/neuralsearch-350415/marco_wow_win:latest
