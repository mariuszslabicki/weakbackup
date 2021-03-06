COMPOSE_FILE_PATH := -f docker-compose.yml 
PWD := $(shell pwd)

build:
	@docker-compose build --force-rm --no-cache 
 
deploy_systemd_files:
	$(info Make: Copying systemd service files.)
	sudo cp service_files/weakbackup.service /etc/systemd/system/weakbackup.service
	sudo cp service_files/weakbackup.timer /etc/systemd/system/weakbackup.timer
	sudo systemctl daemon-reload
	sudo systemctl restart weakbackup.timer
	sudo systemctl enable weakbackup.timer
	sudo systemctl restart weakbackup.service

deploy:
	$(info Make: Create environment containers.)
	@docker-compose -f docker-compose.yml -f backup-dirs.yml up --no-start 

start:
	$(info Make: Starting environment containers.)
	@docker-compose start

stop:
	$(info Make: Stopping environment containers.)
	@docker-compose stop

backup_now:
	$(info Make: I am starting backup now.)
	docker exec WB-restic bash /restic/backup.sh
 
browse_backup:
	@echo "apt update && apt install fuse screen mc -y"
	@echo "mkdir /mnt/backup"
	@echo "restic -r b2:b2:weaknet-photos mount /mnt/backup"
	@docker run --rm -a stdin -a stdout -i -t --env-file b2credentials.env \
	--device /dev/fuse --cap-add SYS_ADMIN \
	restic /bin/bash

restart:
	$(info Make: Restarting environment containers.)
	@docker-compose stop
	@docker-compose rm -f -v
	@docker-compose -f docker-compose.yml -f backup-dirs.yml up -d

connect:
	docker exec -it WB-restic /bin/bash

clean:
	@docker system prune --volumes --force

run_debug:
	docker run --rm -it --entrypoint /bin/bash restic

logs:
	@docker-compose logs
