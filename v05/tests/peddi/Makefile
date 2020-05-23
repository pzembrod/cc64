
test_results = $(patsubst %.golden, %-result.txt,$(wildcard *.golden))

tests: separate-tests.result

separate-tests.result: $(test_results)
	cat $^ >$@

$(test_results) suite.result: ../../peddi03.T64 *.sh

$(test_results): %-result.txt: %.in %.golden
	./run-test.sh $*

clean:
	rm -f c64files/* separate-tests.result tmp.result
	rm -f *.out *-result.txt
