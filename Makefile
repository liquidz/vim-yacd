VITAL_MODULES = System.Filepath

.PHONY: all
all:
	vim -c "Vitalize . --name=yacd $(VITAL_MODULES)" -c q

.PHONY: doc
doc:
	vimdoc .
