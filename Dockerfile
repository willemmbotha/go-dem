FROM golang:1.24.0

WORKDIR /space-invaders

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=1 GOOS=linux GOARCH=arm64 go build -o go-demo-backend .

EXPOSE 80

CMD ["./go-demo-backend"]