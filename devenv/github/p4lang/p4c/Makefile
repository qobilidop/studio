# Reference:
# - https://github.com/p4lang/p4c/blob/main/.github/workflows/ci-test.yml
# - https://github.com/p4lang/p4c/blob/main/tools/ci-build.sh

TEST_P4_PROGRAM = testdata/p4_16_samples/parser-non-field-lhs-bmv2.p4
TEST_TARGET = bmv2
TEST_ARCH = v1model
TEST_NAME = bmv2/testdata/p4_16_samples/parser-non-field-lhs-bmv2.p4

.PHONY: build
build: export IMAGE_TYPE = test
build: export CMAKE_UNITY_BUILD = ON
build: export ENABLE_TEST_TOOLS = ON
build: export INSTALL_BMV2 = ON
build: export INSTALL_EBPF = OFF
build: export INSTALL_DPDK = OFF
build:
	./fork/tools/ci-build.sh

.PHONY: make
make:
	cd fork/build && \
	make && \
	sudo make install

# ctest commands

CTEST_OPTIONS = --output-on-failure --schedule-random

.PHONY: ctest
ctest:
	cd fork/build && \
	sudo -E ctest $(CTEST_OPTIONS)

.PHONY: ctest-testgen
ctest-testgen:
	cd fork/build && \
	sudo -E ctest -R testgen-p4c-bmv2-metadata/parser $(CTEST_OPTIONS)

.PHONY: ctest-single
ctest-single:
	cd fork/build && \
	sudo -E ctest -R $(TEST_NAME) $(CTEST_OPTIONS) -VV

.PHONY: p4testgen-test
p4testgen-test:
	cd fork/build && \
	p4testgen --target $(TEST_TARGET) --arch $(TEST_ARCH) --test-backend METADATA \
	../$(TEST_P4_PROGRAM)

.PHONY: check
check:
	cd fork/build && \
	make check

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

.PHONY: test-single-with-rt
test-single-with-rt:
	cd fork/build && \
	../backends/p4test/run-p4-sample.py . -f --p4runtime ../$(TEST_P4_PROGRAM)

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
