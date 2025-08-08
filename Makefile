install:
	composer install --no-interaction --prefer-dist --no-progress
	npm ci --prefer-offline --no-audit --progress=false

gen:
	php code/zero-code/bin/zerocode schema.json

test:
	vendor/bin/pest --parallel || vendor/bin/phpunit --colors

up:
	docker compose up -d --build || docker-compose up -d --build
