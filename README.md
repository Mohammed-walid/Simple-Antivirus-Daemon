**Folder Hierarchy:**
```text
.
├── antivirusd.sh        # The main background monitor
├── restore.sh           # Interactive tool for reviewing quarantined files
├── antivirus-cron.sh    # A standalone version built for cron scheduling (Bonus 1)
├── Makefile             # Shortcuts for running everything with a single command
├── README.md            # Project documentation
├── .whitelist           # Remembers restored files so they aren't flagged again (Bonus 2)
├── directory-info.last  # Background snapshot used to detect folder changes
├── watch_dir/           # The active directory being monitored
└── quarantine_dir/      # The secure vault for isolated files
