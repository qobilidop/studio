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

.PHONY: gen-testdata-out
gen-testdata-out:
	cd fork/build && \
	../backends/p4test/run-p4-sample.py . -f ../testdata/p4_16_samples/parser-assign-lhs-non-field-bmv2.p4

.PHONY: gen-testdata-out-bmv2
gen-testdata-out-bmv2:
	cd fork && \
	backends/bmv2/run-bmv2-test.py . -f testdata/p4_16_samples/parser-assign-lhs-non-field-bmv2.p4

.PHONY: purge-build
purge-build:
	rm -rf fork/build
