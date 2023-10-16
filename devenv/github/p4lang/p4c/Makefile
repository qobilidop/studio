# Reference:
# - https://github.com/p4lang/p4c/blob/main/.github/workflows/ci-test.yml
# - https://github.com/p4lang/p4c/blob/main/tools/ci-build.sh

TEST_P4_PROGRAM = testdata/p4_16_samples/parser-non-field-lhs-bmv2.p4
TEST_TARGET = bmv2
TEST_ARCH = v1model

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

.PHONY: check-bmv2
check-bmv2:
	cd fork/build && \
	make check-bmv2

.PHONY: check-bmv2-and-update
check-bmv2-and-update: export P4TEST_REPLACE = True
check-bmv2-and-update:
	cd fork/build && \
	make check-bmv2

.PHONY: test-single
test-single:
	cd fork/build && \
	../backends/p4test/run-p4-sample.py . -f ../$(TEST_P4_PROGRAM)

.PHONY: test-single-bmv2
test-single-bmv2:
	cd fork && \
	backends/bmv2/run-bmv2-test.py . -f $(TEST_P4_PROGRAM)

.PHONY: debug-single
debug-single:
	p4test \
		-v --top4 MidEndLast \
		--target $(TEST_TARGET) --arch $(TEST_ARCH) fork/$(TEST_P4_PROGRAM)
	p4c --target $(TEST_TARGET) --arch $(TEST_ARCH) fork/$(TEST_P4_PROGRAM)

.PHONY: purge-build
purge-build:
	rm -rf fork/build
