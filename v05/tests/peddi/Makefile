
test_results = $(patsubst %.golden, %-result.txt,$(wildcard *.golden))
pe_test_results = $(patsubst %.golden, %-result-pe.txt,$(wildcard *.golden))

tests: separate-tests.result separate-pe-tests.result

separate-tests.result: $(test_results)
	cat $^ >$@

separate-pe-tests.result: $(pe_test_results)
	cat $^ >$@

$(test_results) suite.result: ../../peddi03.T64 *.sh

$(test_results): %-result.txt: %.keybuf %.golden
	./run-test.sh $*

$(pe_test_results): %-result-pe.txt: %.keybuf %.golden
	./run-test.sh $* cc64v05pe
	mv $*-result.txt $*-result-pe.txt

clean:
	rm -f c64files/* c64files/.??*
	rm -f separate-tests.result separate-pe-tests.result tmp.result
	rm -f *.out *-result.txt *-result-pe.txt
