.DEFAULT_GOAL := all

strategies/test3.sr_out/simple/status:
	@echo "Running strategy 'simple' on 'test3.sr_out'.."
	@bash -c "cd strategies/test3.sr_out/simple; source run.sh"

strategies/test3.sr/simple/status:
	@echo "Running strategy 'simple' on 'test3.sr'.."
	@bash -c "cd strategies/test3.sr/simple; source run.sh"

strategies/test3.rw/simple/status:
	@echo "Running strategy 'simple' on 'test3.rw'.."
	@bash -c "cd strategies/test3.rw/simple; source run.sh"

strategies/test3.gpioout/simple/status:
	@echo "Running strategy 'simple' on 'test3.gpioout'.."
	@bash -c "cd strategies/test3.gpioout/simple; source run.sh"

.PHONY: all summary
all: strategies/test3.gpioout/simple/status strategies/test3.rw/simple/status strategies/test3.sr/simple/status strategies/test3.sr_out/simple/status
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
