install:
	install -m 644 factorio*.service /etc/systemd/system/
	install -m 644 factorio*.timer /etc/systemd/system/
	install -d /usr/local/factorio
	install -m 755 init.sh update.sh /usr/local/factorio/
	ln -sf /usr/local/factorio/update.sh /usr/local/bin/factorio-update
	install -m 755 bin/* /usr/local/bin/
	id -un factorio || useradd -r factorio
	systemctl daemon-reload

uninstall:
	rm -f /etc/systemd/system/factorio*.service
	systemctl daemon-reload
	rm -f /usr/local/factorio/*.sh
	rm -f /usr/local/bin/factorio-update
