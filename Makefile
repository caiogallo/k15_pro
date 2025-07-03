IMAGE_NAME:=qmk_builder
DOCKER_RUN:=docker run --rm -it -v .:/home/builder $(IMAGE_NAME)
INSTALL_PYTHON_DEPS:=python3 -m pip install --user -r requirements.txt --break-system-packages
KEYBOARD_MODEL:=keychron/k15_max/ansi_encoder/rgb
KEYBOARD_KEYMAP:=default

default: help

build-dockerfile:
	docker build . -t $(IMAGE_NAME)

update-git-submodule:
	git submodule update --init --recursive

interactive-container:
	$(DOCKER_RUN) bash -c "$(INSTALL_PYTHON_DEPS) && bash"

list-keyboards:
	$(DOCKER_RUN) bash -c "$(INSTALL_PYTHON_DEPS) && make list-keyboards | tr ' ' '\n'"

build-firmware:
	$(DOCKER_RUN) bash -c "$(INSTALL_PYTHON_DEPS) && qmk clean && qmk compile -kb $(KEYBOARD_MODEL) -km $(KEYBOARD_KEYMAP)"

flash-firmware:
	$(DOCKER_RUN) bash -c "$(INSTALL_PYTHON_DEPS) && qmk flash -kb $(KEYBOARD_MODEL) -km $(KEYBOARD_KEYMAP)"

clean:
	@rm -rf qmk_firmware/.build
	@rm -rf qmk_firmware/*bin
	$(DOCKER_RUN) bash -c "$(INSTALL_PYTHON_DEPS) && qmk clean"
	@docker image rm $(IMAGE_NAME)

help:
	@echo 
	@echo "Makefile to help building Keychron K15 PRO"
	@echo
	@echo "To avoid installing all tools, you can use a docker image. To build this docker image use"
	@echo "   make build-docker-file"
	@echo
	@echo "After this, to update all submodules from qmk_firmware and avoid dependency errors, use the command"
	@echo "   make update-git-submodule"
	@echo
	@echo "Finally, to build the firmware run "
	@echo "   make build-firmware"
	@echo
	@echo
	@echo "Optional steps"
	@echo "You can easily connect to the container using make interactive-container and list all supported keyboards using make list-keyboards"
