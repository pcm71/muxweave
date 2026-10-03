.DEFAULT_GOAL := all

strategies/test2.out.4/simple/status:
	@echo "Running strategy 'simple' on 'test2.out.4'.."
	@bash -c "cd strategies/test2.out.4/simple; source run.sh"

strategies/test2.out.3/simple/status:
	@echo "Running strategy 'simple' on 'test2.out.3'.."
	@bash -c "cd strategies/test2.out.3/simple; source run.sh"

strategies/test2.out.2/simple/status:
	@echo "Running strategy 'simple' on 'test2.out.2'.."
	@bash -c "cd strategies/test2.out.2/simple; source run.sh"

strategies/test2.out.1/simple/status:
	@echo "Running strategy 'simple' on 'test2.out.1'.."
	@bash -c "cd strategies/test2.out.1/simple; source run.sh"

strategies/test2.out.0/simple/status:
	@echo "Running strategy 'simple' on 'test2.out.0'.."
	@bash -c "cd strategies/test2.out.0/simple; source run.sh"

strategies/test2._09_/simple/status:
	@echo "Running strategy 'simple' on 'test2._09_'.."
	@bash -c "cd strategies/test2._09_/simple; source run.sh"

strategies/test2._08_/simple/status:
	@echo "Running strategy 'simple' on 'test2._08_'.."
	@bash -c "cd strategies/test2._08_/simple; source run.sh"

strategies/test2._07_/simple/status:
	@echo "Running strategy 'simple' on 'test2._07_'.."
	@bash -c "cd strategies/test2._07_/simple; source run.sh"

strategies/test2._06_/simple/status:
	@echo "Running strategy 'simple' on 'test2._06_'.."
	@bash -c "cd strategies/test2._06_/simple; source run.sh"

strategies/test2._05_/simple/status:
	@echo "Running strategy 'simple' on 'test2._05_'.."
	@bash -c "cd strategies/test2._05_/simple; source run.sh"

strategies/test2._04_/simple/status:
	@echo "Running strategy 'simple' on 'test2._04_'.."
	@bash -c "cd strategies/test2._04_/simple; source run.sh"

strategies/test2._03_/simple/status:
	@echo "Running strategy 'simple' on 'test2._03_'.."
	@bash -c "cd strategies/test2._03_/simple; source run.sh"

strategies/test2._02_/simple/status:
	@echo "Running strategy 'simple' on 'test2._02_'.."
	@bash -c "cd strategies/test2._02_/simple; source run.sh"

strategies/test2._01_/simple/status:
	@echo "Running strategy 'simple' on 'test2._01_'.."
	@bash -c "cd strategies/test2._01_/simple; source run.sh"

strategies/test2._00_/simple/status:
	@echo "Running strategy 'simple' on 'test2._00_'.."
	@bash -c "cd strategies/test2._00_/simple; source run.sh"

.PHONY: all summary
all: strategies/test2._00_/simple/status strategies/test2._01_/simple/status strategies/test2._02_/simple/status strategies/test2._03_/simple/status strategies/test2._04_/simple/status strategies/test2._05_/simple/status strategies/test2._06_/simple/status strategies/test2._07_/simple/status strategies/test2._08_/simple/status strategies/test2._09_/simple/status strategies/test2.out.0/simple/status strategies/test2.out.1/simple/status strategies/test2.out.2/simple/status strategies/test2.out.3/simple/status strategies/test2.out.4/simple/status
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
