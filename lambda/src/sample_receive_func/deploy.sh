aws ecr get-login-password | docker login --username AWS --password-stdin 334574713573.dkr.ecr.ap-northeast-1.amazonaws.com
docker build -t 334574713573.dkr.ecr.ap-northeast-1.amazonaws.com/sample-receive:latest . --no-cache
docker push 334574713573.dkr.ecr.ap-northeast-1.amazonaws.com/sample-receive:latest
aws lambda update-function-code --function-name sample-receive --image-uri 334574713573.dkr.ecr.ap-northeast-1.amazonaws.com/sample-receive:latest