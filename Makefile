.PHONY: update
update:
	git pull

.PHONY: install
install:
	ln -s ~/.configsync/ca.oakham.geoff.guistart.plist ~/Library/LaunchAgents/
	launchctl load ~/Library/LaunchAgents/ca.oakham.geoff.guistart.plist

.PHONY: uninstall
uninstall:
	launchctl unload ~/Library/LaunchAgents/ca.oakham.geoff.guistart.plist
	rm  ~/Library/LaunchAgents/ca.oakham.geoff.guistart.plist


