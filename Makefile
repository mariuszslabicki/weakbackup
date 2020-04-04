COMPOSE_FILE_PATH := -f docker-compose.yml 
ARCH := $(shell uname -m)

ifeq ($(ARCH), x86_64)
PLATFORM_MAKE := amd64
endif
ifeq ($(ARCH), aarch64)
PLATFORM_MAKE := arm64
endif

build:
	@docker-compose build --build-arg PLATFORM=${PLATFORM_MAKE}
 
start:
	$(info Make: Starting environment containers.)
	@docker-compose -f docker-compose.yml -f backup-dirs.yml up -d
 
stop:
	$(info Make: Stopping environment containers.)
	@docker-compose stop

backup_now:
	$(info Make: I am starting backup now.)
	@docker start WB-restic
 
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
	@docker-compose run restic bash

logs:
	@docker-compose logs
