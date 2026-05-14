set export

APK_DIR := "app/build/outputs/apk/dev/debug/"

default: assemble

setup:
    docker compose build

build: _image-exists
    docker compose run --rm dyomisy ./gradlew spotlessCheck assembleDevDebug
    @echo ""
    @echo "✅ APK → {{ APK_DIR }}"

assemble: _image-exists
    docker compose run --rm dyomisy ./gradlew assembleDevDebug
    @echo ""
    @echo "✅ APK → {{ APK_DIR }}"

fix: _image-exists
    docker compose run --rm dyomisy ./gradlew spotlessApply

clean: _image-exists
    docker compose run --rm dyomisy ./gradlew clean

nuke:
    docker compose down --rmi all --volumes
    @echo "✅ Image and gradle cache removed."

_image-exists:
    #!/usr/bin/env sh
    if ! docker image inspect dyomisy-builder:latest > /dev/null 2>&1; then
        echo "✗ Docker image not found. Run 'just setup' first."
        exit 1
    fi
