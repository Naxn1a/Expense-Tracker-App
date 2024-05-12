FROM golang:1.22.3-alpine3.19

WORKDIR /app

COPY . .

RUN go get -d -v ./...

RUN go build -o /go/bin/api

COPY .env /go/bin

EXPOSE 8080

# CMD ["/go/bin/api"]
ENTRYPOINT [ "/go/bin/api", "/go/bin/.env" ]