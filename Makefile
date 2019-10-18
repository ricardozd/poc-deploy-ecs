default: test

GOOS?=linux

clean:
	rm -rf bin/
	rm -f lambda/*.zip

build: clean
	cd cmd/helloworld && GOOS=$(GOOS) GOARCH=amd64 CGO_ENABLED=0 go build -o bin/helloworld -trimpath && mv bin/ ../../

	cd cmd/ping && GOOS=$(GOOS) GOARCH=amd64 CGO_ENABLED=0 go build -o bin/ping -trimpath && cp bin/* ../../bin/ && rm -rf bin/
.PHONY: build

deploy-lambda: clean
	cd lambda/ && zip deploy-ecs.zip deploy-ecs.py
	cd lambda/ && aws s3 cp deploy-ecs.zip s3://tech-artifacters-lambda/deploy-ecs.zip
.PHONY: deploy-lambda
