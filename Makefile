# Copy .zshrc and .p10k.zsh from home directory into this directory

all: setup build

setup:
	@echo "Setting up..."
	@cp ~/.zshrc .
	@cp ~/.p10k.zsh .

build:
	@echo "Building..."
	@docker build -t jacobs-ubuntu .
