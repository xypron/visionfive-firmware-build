all:
	docker build -t visionfiverecovery:latest .
	docker run --cidfile=visionfiverecovery.pid -td visionfiverecovery:latest
	export cid=${shell cat visionfiverecovery.pid} && \
		docker cp $$cid:/home/user/artifacts/jh7100_recovery_boot.bin .
	export cid=${shell cat visionfiverecovery.pid} && \
		docker cp $$cid:/home/user/artifacts/bootloader-JH7100.bin.out .
	export cid=${shell cat visionfiverecovery.pid} && \
		docker stop $$cid
	rm visionfiverecovery.pid
