.DEFAULT_GOAL := all

strategies/test4.only_5b/simple/status:
	@echo "Running strategy 'simple' on 'test4.only_5b'.."
	@bash -c "cd strategies/test4.only_5b/simple; source run.sh"

strategies/test4.dataout.5/simple/status:
	@echo "Running strategy 'simple' on 'test4.dataout.5'.."
	@bash -c "cd strategies/test4.dataout.5/simple; source run.sh"

strategies/test4.dataout.4/simple/status:
	@echo "Running strategy 'simple' on 'test4.dataout.4'.."
	@bash -c "cd strategies/test4.dataout.4/simple; source run.sh"

strategies/test4.dataout.3/simple/status:
	@echo "Running strategy 'simple' on 'test4.dataout.3'.."
	@bash -c "cd strategies/test4.dataout.3/simple; source run.sh"

strategies/test4.dataout.2/simple/status:
	@echo "Running strategy 'simple' on 'test4.dataout.2'.."
	@bash -c "cd strategies/test4.dataout.2/simple; source run.sh"

strategies/test4.dataout.1/simple/status:
	@echo "Running strategy 'simple' on 'test4.dataout.1'.."
	@bash -c "cd strategies/test4.dataout.1/simple; source run.sh"

strategies/test4.dataout.0/simple/status:
	@echo "Running strategy 'simple' on 'test4.dataout.0'.."
	@bash -c "cd strategies/test4.dataout.0/simple; source run.sh"

strategies/test4.datain_5bis7/simple/status:
	@echo "Running strategy 'simple' on 'test4.datain_5bis7'.."
	@bash -c "cd strategies/test4.datain_5bis7/simple; source run.sh"

strategies/test4.data_dp/simple/status:
	@echo "Running strategy 'simple' on 'test4.data_dp'.."
	@bash -c "cd strategies/test4.data_dp/simple; source run.sh"

strategies/test4.data_dn/simple/status:
	@echo "Running strategy 'simple' on 'test4.data_dn'.."
	@bash -c "cd strategies/test4.data_dn/simple; source run.sh"

strategies/test4._17_/simple/status:
	@echo "Running strategy 'simple' on 'test4._17_'.."
	@bash -c "cd strategies/test4._17_/simple; source run.sh"

strategies/test4._16_/simple/status:
	@echo "Running strategy 'simple' on 'test4._16_'.."
	@bash -c "cd strategies/test4._16_/simple; source run.sh"

strategies/test4._15_/simple/status:
	@echo "Running strategy 'simple' on 'test4._15_'.."
	@bash -c "cd strategies/test4._15_/simple; source run.sh"

strategies/test4._14_/simple/status:
	@echo "Running strategy 'simple' on 'test4._14_'.."
	@bash -c "cd strategies/test4._14_/simple; source run.sh"

strategies/test4._13_/simple/status:
	@echo "Running strategy 'simple' on 'test4._13_'.."
	@bash -c "cd strategies/test4._13_/simple; source run.sh"

strategies/test4._12_/simple/status:
	@echo "Running strategy 'simple' on 'test4._12_'.."
	@bash -c "cd strategies/test4._12_/simple; source run.sh"

strategies/test4._11_/simple/status:
	@echo "Running strategy 'simple' on 'test4._11_'.."
	@bash -c "cd strategies/test4._11_/simple; source run.sh"

strategies/test4._10_/simple/status:
	@echo "Running strategy 'simple' on 'test4._10_'.."
	@bash -c "cd strategies/test4._10_/simple; source run.sh"

strategies/test4._09_/simple/status:
	@echo "Running strategy 'simple' on 'test4._09_'.."
	@bash -c "cd strategies/test4._09_/simple; source run.sh"

strategies/test4._08_/simple/status:
	@echo "Running strategy 'simple' on 'test4._08_'.."
	@bash -c "cd strategies/test4._08_/simple; source run.sh"

strategies/test4._07_/simple/status:
	@echo "Running strategy 'simple' on 'test4._07_'.."
	@bash -c "cd strategies/test4._07_/simple; source run.sh"

strategies/test4._06_/simple/status:
	@echo "Running strategy 'simple' on 'test4._06_'.."
	@bash -c "cd strategies/test4._06_/simple; source run.sh"

strategies/test4._05_/simple/status:
	@echo "Running strategy 'simple' on 'test4._05_'.."
	@bash -c "cd strategies/test4._05_/simple; source run.sh"

strategies/test4._04_/simple/status:
	@echo "Running strategy 'simple' on 'test4._04_'.."
	@bash -c "cd strategies/test4._04_/simple; source run.sh"

strategies/test4._03_/simple/status:
	@echo "Running strategy 'simple' on 'test4._03_'.."
	@bash -c "cd strategies/test4._03_/simple; source run.sh"

strategies/test4._02_.5/simple/status:
	@echo "Running strategy 'simple' on 'test4._02_.5'.."
	@bash -c "cd strategies/test4._02_.5/simple; source run.sh"

strategies/test4._02_.4/simple/status:
	@echo "Running strategy 'simple' on 'test4._02_.4'.."
	@bash -c "cd strategies/test4._02_.4/simple; source run.sh"

strategies/test4._02_.3/simple/status:
	@echo "Running strategy 'simple' on 'test4._02_.3'.."
	@bash -c "cd strategies/test4._02_.3/simple; source run.sh"

strategies/test4._02_.2/simple/status:
	@echo "Running strategy 'simple' on 'test4._02_.2'.."
	@bash -c "cd strategies/test4._02_.2/simple; source run.sh"

strategies/test4._02_.1/simple/status:
	@echo "Running strategy 'simple' on 'test4._02_.1'.."
	@bash -c "cd strategies/test4._02_.1/simple; source run.sh"

strategies/test4._02_.0/simple/status:
	@echo "Running strategy 'simple' on 'test4._02_.0'.."
	@bash -c "cd strategies/test4._02_.0/simple; source run.sh"

strategies/test4._01_/simple/status:
	@echo "Running strategy 'simple' on 'test4._01_'.."
	@bash -c "cd strategies/test4._01_/simple; source run.sh"

strategies/test4._00_/simple/status:
	@echo "Running strategy 'simple' on 'test4._00_'.."
	@bash -c "cd strategies/test4._00_/simple; source run.sh"

.PHONY: all summary
all: strategies/test4._00_/simple/status strategies/test4._01_/simple/status strategies/test4._02_.0/simple/status strategies/test4._02_.1/simple/status strategies/test4._02_.2/simple/status strategies/test4._02_.3/simple/status strategies/test4._02_.4/simple/status strategies/test4._02_.5/simple/status strategies/test4._03_/simple/status strategies/test4._04_/simple/status strategies/test4._05_/simple/status strategies/test4._06_/simple/status strategies/test4._07_/simple/status strategies/test4._08_/simple/status strategies/test4._09_/simple/status strategies/test4._10_/simple/status strategies/test4._11_/simple/status strategies/test4._12_/simple/status strategies/test4._13_/simple/status strategies/test4._14_/simple/status strategies/test4._15_/simple/status strategies/test4._16_/simple/status strategies/test4._17_/simple/status strategies/test4.data_dn/simple/status strategies/test4.data_dp/simple/status strategies/test4.datain_5bis7/simple/status strategies/test4.dataout.0/simple/status strategies/test4.dataout.1/simple/status strategies/test4.dataout.2/simple/status strategies/test4.dataout.3/simple/status strategies/test4.dataout.4/simple/status strategies/test4.dataout.5/simple/status strategies/test4.only_5b/simple/status
	$(MAKE) -f strategies.mk summary
summary:
	@rc=0 ; \
	while read f; do \
		p=$${f#strategies/} ; p=$${p%/*/status} ; \
		if grep -q "PASS" $$f ; then \
			echo "* Successfully proved equivalence of partition $$p" ; \
		else \
			echo "* Failed to prove equivalence of partition $$p" ; rc=1 ; \
		fi ; \
	done < summary_targets.list ; \
	if [ "$$rc" -eq 0 ] ; then \
		echo "* Successfully proved designs equivalent" ; \
	fi
