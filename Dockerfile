# syntax=docker/dockerfile:1.6

FROM golang:1.24.0 AS builder

WORKDIR /app

# Cache deps
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest
COPY . .

# Use build cache
RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg/mod \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -buildvcs=false -o go-demo-backend .

FROM gcr.io/distroless/base-debian12

WORKDIR /app

COPY --from=builder /app/go-demo-backend .

EXPOSE 80

CMD ["./go-demo-backend"]