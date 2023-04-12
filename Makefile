.PHONY: update
update:
	git pull

.PHONY: install
install:
	ln -s ~/.configsync/ca.oakham.geoff.guistart.plist ~/Library/LaunchAgents/
	launchctl load ~/Library/LaunchAgents/ca.oakham.geoff.guistart.plist
	ln -s ~/.configsync/ca.oakham.geoff.controlkeyremap.plist ~/Library/LaunchAgents/
	launchctl load ~/.configsync/ca.oakham.geoff.controlkeyremap.plist
	mkdir -p ~/.gnupg

.PHONY: uninstall
uninstall:
	launchctl unload ~/Library/LaunchAgents/ca.oakham.geoff.guistart.plist
	rm  ~/Library/LaunchAgents/ca.oakham.geoff.guistart.plist
	launchctl unload ~/.configsync/ca.oakham.geoff.controlkeyremap.plist
	rm ~/Library/LaunchAgents/ca.oakham.geoff.controlkeyremap.plist

