# README at: https://github.com/devcontainers/templates/tree/main/src/go
FROM mcr.microsoft.com/devcontainers/go:0-1-bullseye

# Install Just
RUN curl --proto '=https' --tlsv1.3 -sSf https://just.systems/install.sh | bash -s -- --to /usr/local/bin

# Install SQLC
RUN go install github.com/kyleconroy/sqlc/cmd/sqlc@latest