# Reference:
# - https://github.com/p4lang/p4c/blob/main/.github/workflows/ci-test.yml
# - https://github.com/p4lang/p4c/blob/main/tools/ci-build.sh

.PHONY: build
build: export IMAGE_TYPE = test
build: export INSTALL_BMV2 = ON
build: export INSTALL_EBPF = OFF
build: export INSTALL_DPDK = OFF
build:
	./fork/tools/ci-build.sh

.PHONY: rebuild
rebuild:
	cd fork/build && \
	make && \
	sudo make install

.PHONY: test-all
test-all:
	cd fork/build && \
	sudo -E ctest --output-on-failure --schedule-random
