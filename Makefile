all:
	docker build -t visionfiverecovery:latest .
	docker run --cidfile=visionfiverecovery.pid -td visionfiverecovery:latest
	cid=$$(./pidcat.sh) && \
		docker cp $$cid:/home/user/artifacts/jh7100_recovery_boot.bin .
	cid=$$(./pidcat.sh) && \
		docker cp $$cid:/home/user/artifacts/bootloader-JH7100.bin.out .
	cid=$$(./pidcat.sh) && \
		docker stop $$cid
	rm visionfiverecovery.pid
