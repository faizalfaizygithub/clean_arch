.PHONY: help setup clean build_runner watch_runner apk apk_dev apk_qa apk_prod aab aab_dev aab_qa aab_prod ios web

# Default target
help:
	@echo "Available commands:"
	@echo "  make setup         - Clean and fetch dependencies"
	@echo "  make clean         - Run flutter clean"
	@echo "  make build_runner  - Run build_runner to generate code"
	@echo "  make watch_runner  - Run build_runner in watch mode"
	@echo "  make apk           - Default APK build (split per ABI)"
	@echo "  make apk_dev       - Build Dev APK"
	@echo "  make apk_qa        - Build QA APK"
	@echo "  make apk_prod      - Build Prod APK"
	@echo "  make aab           - Default AppBundle build"
	@echo "  make aab_dev       - Build Dev AppBundle"
	@echo "  make aab_qa        - Build QA AppBundle"
	@echo "  make aab_prod      - Build Prod AppBundle"

# Setup & Dependencies
setup: clean
	flutter pub get

clean:
	flutter clean

# Code Generation
build_runner:
	dart run build_runner build --delete-conflicting-outputs

watch_runner:
	dart run build_runner watch --delete-conflicting-outputs

asset_gen:
	dart run tools/generate_assets.dart

# APK Builds (split-per-abi to reduce size)
apk:
	flutter build apk --split-per-abi

apk_dev:
	flutter build apk --split-per-abi -t lib/env/main_dev.dart

apk_qa:
	flutter build apk --split-per-abi -t lib/env/main_qa.dart

apk_prod:
	flutter build apk --split-per-abi -t lib/env/main_prod.dart

# AppBundle (AAB) Builds (for Play Store)
aab:
	flutter build appbundle

aab_dev:
	flutter build appbundle -t lib/env/main_dev.dart

aab_qa:
	flutter build appbundle -t lib/env/main_qa.dart

aab_prod:
	flutter build appbundle -t lib/env/main_prod.dart

# Platform specific
ios:
	flutter build ios

web:
	flutter build web
