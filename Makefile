IMAGE_NAME:=qmk_builder
DOCKER_RUN:=docker run --rm -it -v ./qmk_firmware:/home/builder/qmk_firmware $(IMAGE_NAME)
INSTALL_PYTHON_DEPS:=python3 -m pip install --user -r requirements.txt --break-system-packages

build-docker-file:
	docker build . -t $(IMAGE_NAME)

interactive-container:
	$(DOCKER_RUN) bash -c "$(INSTALL_PYTHON_DEPS) && bash"

list-keyboards:
	$(DOCKER_RUN) bash -c "$(INSTALL_PYTHON_DEPS) && make list-keyboards | tr ' ' '\n'"

all: interactive-container
