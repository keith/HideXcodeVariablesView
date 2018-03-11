PLUGIN_NAME = HideXcodeVariablesView
ARCHIVE_PATH = $(PLUGIN_NAME).tar.gz
INSTALL_PATH = $(HOME)/Library/Application Support/Developer/Shared/Xcode/Plug-ins/$(PLUGIN_NAME).xcplugin

install: uninstall
	xcodebuild -configuration Release

uninstall:
	rm -rf "$(INSTALL_PATH)"

archive: install
	tar -pvczf $(ARCHIVE_PATH) "$(INSTALL_PATH)"
	shasum -a 256 $(ARCHIVE_PATH)
