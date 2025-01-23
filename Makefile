# Copy .zshrc and .p10k.zsh from home directory into this directory

.PHONY: build-work build-sat-extention

build-work:
	@echo "Building..."
	@docker build -t jacobs-ubuntu -f Dockerfile.ubuntu-work .

build-sat-extention:
	@echo "Building..."
	@docker build -t jacobs-ubuntu-sat-extention -f Dockerfile.sat-personal-extension .
