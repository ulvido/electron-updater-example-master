# Makefile'ın bulunduğu path
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

# docker image için mimari
MIMARI=$(shell uname -m)

# docker permission sorunu yaşamamak için
USER_ID=$(shell id -u)
USER_GROUP=$(shell id -g)
PWD=$(shell pwd)

.PHONY: help

.DEFAULT_GOAL := help

help: ## bu yardımı gösterir
	@printf '\n\e[1;33m%-6s\e[m\n\n' "-- Sıramatik Makefile Yardım Klavuzu --"
	@fgrep -h "##" $(MAKEFILE_LIST) | sort | fgrep -v fgrep | sed -e 's/\\$$//' | awk 'BEGIN {FS = ":.*?## "}; {printf "\x1B[34m%-20s\x1B[36m %s\n", $$1, $$2}' && printf '\n'

docker.run.arm.dev: ## docker ARM development ortamı
	@echo Arm Not Implemented;

docker.run.pclinux.dev: ## docker PC Linux development ortamı
	@docker run --rm -ti \
		--name docker-electronbuilder \
		--env ELECTRON_CACHE="/root/.cache/electron" \
		--env ELECTRON_BUILDER_CACHE="/root/.cache/electron-builder" \
		-v $(PWD):/project \
		-v $(PWD)/node_modules:/project/node_modules \
		-v ~/.cache/electron:/root/.cache/electron \
		-v ~/.cache/electron-builder:/root/.cache/electron-builder \
		-v $(PWD)/.electron-cache:/project/.electron-cache \
		electronuserland/builder:wine;
# daha sonra package.json dan komutlardan birini gir
# ör: windows için build etceksen
# yarn && yarn build:win

dev: ## mimariyi otomatik seç
	@if [ "$(MIMARI)" = "armv7l" ]; then \
		echo Docker Electron Builder, ARM mimarisi için hazırlanıyor...; \
		make -s docker.run.arm.dev; \
	elif [ "$(MIMARI)" = "x86_64" ]; then \
		echo Docker Electron Builder, PCLinux-64Bit mimarisi için hazırlanıyor...; \
		make -s docker.run.pclinux.dev; \
	else \
			echo Cihaz mimarisi tespit edilemedi.; \
			echo Manuel olarak çalıştırmayı deneyebilirsiniz:; \
			echo make docker.run.pclinux.dev veya make docker.run.arm.dev; \
	fi