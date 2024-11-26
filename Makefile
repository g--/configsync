.PHONY: update
update:
	git pull

.PHONY: install
install:
	@mkdir -p ~/.gnupg
	@chmod og-rx ~/.gnupg
	@[ -e ~/.gnupg/gpg-agent.conf ] || ln -s ~/.gsync/gpg-agent.conf ~/.gnupg/
	@curl --silent https://github.com/g--.gpg | gpg --quiet --import

	@[ -e ~/.wezterm.lua ] || ln -s ~/.gsync/wezterm.lua ~/.wezterm.lua

	@[ -e ~/.gitconfig ] || (cp git/gitconfig_template ~/.gitconfig && echo "Rememeber to peronsalize ~/.gitconfig")
	@[ -e ~/.bash_local_aliases ] || cp bash_local_aliases_template ~/.bash_local_aliases
	@[ -e ~/.bash_local_aliases ] || cp bash_local_aliases_template ~/.bash_local_aliases
	@[ -e ~/.config/nvim ] || git clone git@github.com:g--/nvim-config.git ~/.config/nvim
	@nvim --headless "+Lazy! install" +qa

.PHONY: install_darwin
install_darwin: install
	@./bin.Darwin/install_dev_tools.sh
	@[ -e ~/.config/karabiner ] || ln -s ~/.gsync/karabiner ~/.config/ .config/karabiner
	@[ -e ~/Library/LaunchAgents/ca.oakham.geoff.guistart.plist ] || ln -s ~/.gsync/ca.oakham.geoff.guistart.plist ~/Library/LaunchAgents/
	@launchctl unload ~/Library/LaunchAgents/ca.oakham.geoff.guistart.plist  > /dev/null 2>&1
	@launchctl load ~/Library/LaunchAgents/ca.oakham.geoff.guistart.plist
	@[ -e ~/Library/LaunchAgents/ca.oakham.geoff.controlkeyremap.plist ] || ln -s ~/.gsync/ca.oakham.geoff.controlkeyremap.plist ~/Library/LaunchAgents/
	@launchctl unload ~/.gsync/ca.oakham.geoff.controlkeyremap.plist  > /dev/null 2>&1
	@launchctl load ~/.gsync/ca.oakham.geoff.controlkeyremap.plist

	@grep -q '.gsync/bashrc' ~/.bash_profile || (cat ~/.gsync/bash_template >> ~/.bash_profile && echo "remember to customize ~/.bash_profile")

	@echo "some apps will need to be allow listed in the security center including: icanhazshortcuts"

.PHONY: install_linux
install_linux: install
	@grep -q '.gsync/bashrc' ~/.bashrc || (cat ~/.gsync/bash_template >> ~/.bashrc && echo "remember to customize ~/.bashrc")
	@./bin.Linux/install_dev_tools.sh


.PHONY: uninstall
uninstall:
	launchctl unload ~/Library/LaunchAgents/ca.oakham.geoff.guistart.plist
	rm  ~/Library/LaunchAgents/ca.oakham.geoff.guistart.plist
	launchctl unload ~/.gsync/ca.oakham.geoff.controlkeyremap.plist
	rm ~/Library/LaunchAgents/ca.oakham.geoff.controlkeyremap.plist

.PHONY: compile
compile: wordlist.en-ca.add.spl

wordlist.en-ca.add.spl: wordlist.en-ca.add
	nvim '+mkspell! wordlist.en-ca.add' +qall



