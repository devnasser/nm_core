# Zero-Code Workspace

This repository hosts the **Zero-Code Platform** and related resources.

## Quick Start

```bash
# 1. Bootstrap environment (installs PHP, Composer, Node, Docker, RAM-disk cache, etc.)
chmod +x scripts/fast_env_boost.sh
./scripts/fast_env_boost.sh

# 2. Generate a system from schema
cp code/zero-code/demo_schema.json schema.json   # edit as you like
make gen                                          # uses Makefile shortcut

# 3. Run tests (parallel)
make test
```

## Environment Variables
Copy `.env.example` to `.env` and tweak as needed before running the application stack.

```bash
cp .env.example .env
```

## CI / CD (optional)
A GitHub Actions workflow can call `scripts/fast_env_boost.sh` then run `make test` to ensure every push to **main** remains green.