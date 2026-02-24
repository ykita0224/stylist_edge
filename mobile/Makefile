.PHONY: help install run run-iphone16pro clean build-android build-ios test format doctor docker-build docker-run docker-shell docker-clean

IPHONE16PRO_UDID := 3A868914-13C0-42FA-8A43-C7FF1245C715

help:
	@echo "Stylist Edge - Flutter App Makefile"
	@echo ""
	@echo "Available commands:"
	@echo "  make install       - Install Flutter dependencies"
	@echo "  make run          - Run the app on connected device"
	@echo "  make run-android  - Run the app on Android device/emulator"
	@echo "  make run-ios          - Run the app on iOS simulator/device"
	@echo "  make run-iphone16pro  - Boot iPhone 16 Pro simulator and run the app"
	@echo "  make clean        - Clean Flutter build files"
	@echo "  make build-android - Build APK for Android"
	@echo "  make build-ios    - Build IPA for iOS"
	@echo "  make test         - Run tests"
	@echo "  make format       - Format code"
	@echo "  make doctor       - Check Flutter installation"
	@echo ""
	@echo "Docker commands:"
	@echo "  make docker-build  - Build Docker image"
	@echo "  make docker-run    - Run app in Docker container"
	@echo "  make docker-shell  - Open shell in Docker container"
	@echo "  make docker-clean  - Remove Docker image"

install:
	@echo "Installing Flutter dependencies..."
	flutter pub get

run:
	@echo "Running Stylist Edge..."
	flutter run

run-android:
	@echo "Running on Android..."
	flutter run -d android

run-ios:
	@echo "Running on iOS..."
	flutter run -d ios

run-iphone16pro:
	@echo "Booting iPhone 16 Pro simulator..."
	open -a Simulator
	xcrun simctl boot $(IPHONE16PRO_UDID) 2>/dev/null || true
	@echo "Running on iPhone 16 Pro..."
	flutter run -d $(IPHONE16PRO_UDID)

clean:
	@echo "Cleaning build files..."
	flutter clean
	flutter pub get

build-android:
	@echo "Building APK for Android..."
	flutter build apk --release

build-ios:
	@echo "Building for iOS..."
	flutter build ios --release

test:
	@echo "Running tests..."
	flutter test

format:
	@echo "Formatting code..."
	dart format lib/

doctor:
	@echo "Checking Flutter installation..."
	flutter doctor -v

# Docker commands
docker-build:
	@echo "Building Docker image..."
	docker build -t stylist-edge:latest .

docker-run:
	@echo "Running in Docker container..."
	docker run -it --rm -v $(PWD):/app stylist-edge:latest flutter doctor

docker-shell:
	@echo "Opening shell in Docker container..."
	docker run -it --rm -v $(PWD):/app stylist-edge:latest /bin/bash

docker-build-apk:
	@echo "Building APK in Docker container..."
	docker run -it --rm -v $(PWD):/app stylist-edge:latest flutter build apk --release

docker-clean:
	@echo "Removing Docker image..."
	docker rmi stylist-edge:latest
