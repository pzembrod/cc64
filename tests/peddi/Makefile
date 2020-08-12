
test_names = $(patsubst %.golden, %, $(wildcard *.golden))
test_results_c64 = $(patsubst %, %-c64-result.txt, $(test_names))
test_results_c16 = $(patsubst %, %-c16-result.txt, $(test_names))
pe_test_results_c64 = $(patsubst %, %-c64-result-pe.txt, $(test_names))
pe_test_results_c16 = $(patsubst %, %-c16-result-pe.txt, $(test_names))

tests: tests64 tests16

tests64: separate-tests-c64.result separate-pe-tests-c64.result

tests16: separate-tests-c16.result separate-pe-tests-c16.result

separate-tests-c64.result: $(test_results_c64)
	cat $^ >$@

separate-tests-c16.result: $(test_results_c16)
	cat $^ >$@

separate-pe-tests-c64.result: $(pe_test_results_c64)
	cat $^ >$@

separate-pe-tests-c16.result: $(pe_test_results_c16)
	cat $^ >$@

$(test_results_c64): ../../autostart-c64/peddi.T64 *.sh

$(test_results_c16): ../../autostart-c16/peddi.T64 *.sh

$(pe_test_results_c64): ../../autostart-c64/cc64pe.T64 *.sh

$(pe_test_results_c16): ../../autostart-c16/cc64pe.T64 *.sh

$(test_results_c64): %-c64-result.txt: %.keybuf %.golden
	./run-test.sh peddi $* c64

$(test_results_c16): %-c16-result.txt: %.keybuf %.golden
	./run-test.sh peddi $* c16

$(pe_test_results_c64): %-c64-result-pe.txt: %.keybuf %.golden
	./run-test.sh cc64pe $* c64
	mv $*-c64-result.txt $*-c64-result-pe.txt

$(pe_test_results_c16): %-c16-result-pe.txt: %.keybuf %.golden
	./run-test.sh cc64pe $* c16
	mv $*-c16-result.txt $*-c16-result-pe.txt

clean:
	rm -f c64files/* c64files/.??* c16files/* c16files/.??*
	rm -f separate-tests.result separate-pe-tests.result tmp.result
	rm -f *.out *-result.txt *-result-pe.txt
