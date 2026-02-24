.PHONY: help \
        backend-up backend-down backend-logs backend-shell backend-restart \
        mobile-install mobile-run mobile-run-iphone16pro mobile-run-ios mobile-run-android \
        db-shell

IPHONE16PRO_UDID := 3A868914-13C0-42FA-8A43-C7FF1245C715

help:
	@echo ""
	@echo "=============================="
	@echo " Stylist Edge - Project Make  "
	@echo "=============================="
	@echo ""
	@echo "Backend (FastAPI + PostgreSQL via Docker):"
	@echo "  make backend-up        - Start backend + DB (docker-compose)"
	@echo "  make backend-down      - Stop backend + DB"
	@echo "  make backend-logs      - Tail backend logs"
	@echo "  make backend-restart   - Restart backend service"
	@echo "  make backend-shell     - Open shell inside backend container"
	@echo "  make db-shell          - Open psql inside DB container"
	@echo ""
	@echo "Mobile (Flutter):"
	@echo "  make mobile-install        - Install Flutter dependencies"
	@echo "  make mobile-run            - Run on any connected device"
	@echo "  make mobile-run-iphone16pro - Boot iPhone 16 Pro & run app"
	@echo "  make mobile-run-ios        - Run on iOS simulator"
	@echo "  make mobile-run-android    - Run on Android emulator"
	@echo ""

# ── Backend ──────────────────────────────────────────────────────────────────

backend-up:
	@echo "Starting backend and database..."
	docker compose up --build -d

backend-down:
	@echo "Stopping services..."
	docker compose down

backend-logs:
	docker compose logs -f backend

backend-restart:
	docker compose restart backend

backend-shell:
	docker compose exec backend /bin/bash

db-shell:
	docker compose exec db psql -U stylist_user -d stylist_edge

# ── Mobile ───────────────────────────────────────────────────────────────────

mobile-install:
	@echo "Installing Flutter dependencies..."
	cd mobile && flutter pub get

mobile-run:
	@echo "Running Stylist Edge..."
	cd mobile && flutter run

mobile-run-iphone16pro:
	@echo "Booting iPhone 16 Pro simulator..."
	open -a Simulator
	xcrun simctl boot $(IPHONE16PRO_UDID) 2>/dev/null || true
	@echo "Running on iPhone 16 Pro..."
	cd mobile && flutter run -d $(IPHONE16PRO_UDID)

mobile-run-ios:
	@echo "Running on iOS simulator..."
	cd mobile && flutter run -d ios

mobile-run-android:
	@echo "Running on Android emulator..."
	cd mobile && flutter run -d android
