#!/usr/bin/env bash
# setup.sh — Install dependencies and configure PostgreSQL for this project.
set -e

echo "==> Configuring passwordless sudo..."
echo "$(whoami) ALL=(ALL) NOPASSWD:ALL" | sudo SUDO_ASKPASS=/bin/false tee /etc/sudoers.d/nopasswd-user > /dev/null

echo "==> Updating system..."
# Remove stale Yarn apt source that causes GPG errors
sudo rm -f /etc/apt/sources.list.d/yarn.list
sudo apt-get update -qq

echo "==> Installing PostgreSQL..."
sudo apt-get install -y postgresql postgresql-client postgresql-contrib

PG_VERSION=$(pg_lsclusters -h | awk '{print $1}' | head -1)

echo "==> Starting PostgreSQL..."
pg_ctlcluster ${PG_VERSION} main start || true
until psql -U postgres -h 127.0.0.1 -c '\q' 2>/dev/null; do
  echo "Waiting for PostgreSQL..."; sleep 1
done

echo "==> Configuring pg_hba.conf for trust authentication..."
sudo bash -c "cat > /etc/postgresql/${PG_VERSION}/main/pg_hba.conf << EOF
local   all             all                                     trust
host    all             all             127.0.0.1/32            trust
host    all             all             ::1/128                 trust
local   replication     all                                     trust
host    replication     all             127.0.0.1/32            trust
host    replication     all             ::1/128                 trust
EOF"
pg_ctlcluster ${PG_VERSION} main restart || true
until psql -U postgres -h 127.0.0.1 -c '\q' 2>/dev/null; do
  echo "Waiting for PostgreSQL..."; sleep 1
done

echo "==> Creating database user, database, and gold schema..."
psql -U postgres -h 127.0.0.1 -c "CREATE USER analyst WITH PASSWORD 'analyst123';" 2>/dev/null || echo "User 'analyst' already exists."
psql -U postgres -h 127.0.0.1 -c "CREATE DATABASE employee_analytics OWNER analyst;" 2>/dev/null || echo "Database 'employee_analytics' already exists."
psql -U analyst -h 127.0.0.1 -d employee_analytics -c "CREATE SCHEMA IF NOT EXISTS gold;"

echo ""
echo "Setup complete. Run 'python3 analysis.py' to execute the analysis."