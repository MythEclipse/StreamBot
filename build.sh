#!/bin/bash

# Fungsi untuk menampilkan pesan log
log() {
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Fungsi untuk memeriksa apakah Docker berjalan
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        log "❌ Docker tidak berjalan. Silakan jalankan Docker terlebih dahulu."
        exit 1
    fi
}

# Fungsi untuk memeriksa apakah Docker Compose tersedia
check_docker_compose() {
    if ! command -v docker compose > /dev/null 2>&1; then
        log "❌ Docker Compose tidak ditemukan. Pastikan Docker Compose terinstal di sistem Anda."
        exit 1
    fi
}

# Fungsi untuk menghapus layanan sebelumnya
remove_old_services() {
    log "🗑️ Menghapus layanan Docker Compose yang lama (container, volume, dan jaringan)..."
    docker compose down -v --remove-orphans
    if [ $? -eq 0 ]; then
        log "✅ Layanan lama berhasil dihapus!"
    else
        log "❌ Gagal menghapus layanan lama."
        exit 1
    fi
}

# Fungsi untuk menghapus image yang tidak digunakan
remove_unused_images() {
    log "🗑️ Menghapus image Docker yang tidak digunakan..."
    docker image prune -a -f
    if [ $? -eq 0 ]; then
        log "✅ Image yang tidak digunakan berhasil dihapus!"
    else
        log "❌ Gagal menghapus image yang tidak digunakan."
        exit 1
    fi
}

# Fungsi untuk memulai layanan dengan rebuild dan memaksa recreate tanpa cache
start_services() {
    log "🚀 Memulai layanan Docker Compose (dengan build ulang, recreate, dan tanpa cache)..."
    docker compose build --no-cache
    docker compose up -d --force-recreate
    if [ $? -eq 0 ]; then
        log "✅ Layanan Docker Compose berhasil dimulai!"
    else
        log "❌ Gagal memulai layanan Docker Compose."
        exit 1
    fi
}

# Main script
main() {
    check_docker
    check_docker_compose
    remove_old_services  # Menambahkan langkah untuk menghapus layanan lama
    remove_unused_images # Menambahkan langkah untuk menghapus image yang tidak digunakan
    start_services
}

main
