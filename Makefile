DIR = watch_dir
MALICIOUS_DIR = quarantine_dir
INTERVAL = 5

.PHONY: run restore pre-build

run: pre-build
	./antivirusd.sh $(DIR) $(MALICIOUS_DIR) $(INTERVAL)

restore:
	./restore.sh $(DIR) $(MALICIOUS_DIR)

pre-build:
	mkdir -p $(MALICIOUS_DIR)
