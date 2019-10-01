COMPOSE_FILE_PATH := -f docker-compose.yml 
ARCH := $(shell uname -m)

ifeq ($(ARCH), x86_64)
PLATFORM_MAKE := amd64
endif
ifeq ($(UNAME), aarch64)
PLATFORM_MAKE := arm64
endif

build:
	@docker-compose build --build-arg PLATFORM=${PLATFORM_MAKE}
 
start:
	$(info Make: Starting environment containers.)
	@docker-compose up -d
 
stop:
	$(info Make: Stopping environment containers.)
	@docker-compose stop
 
restart:
	$(info Make: Restarting environment containers.)
	@docker-compose stop
	@docker-compose rm -f -v
	@docker-compose up -d

connect:
	docker exec -it weakbackup_restic_1 /bin/bash

clean:
	@docker system prune --volumes --force

run_debug:
	@docker-compose run restic bash

logs:
	@docker-compose logs
