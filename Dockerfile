FROM golang:1.23 as base

WORKDIR /app
# go.mod stores depandencies in go.mod
COPY go.mod . 
#This will download all the dependencies mentioned in go.mod
RUN go mod download
#Copy all source code to the container
COPY . .
#Build the go code
RUN go build -o main . 


#Stage 2 -Use distroless image to reduce the size of the image and incret the security
FROM gcr.io/distroless/base

#Copy the binary from the base image to the distroless image in default directory
COPY --from=base /app/main .

#Copy the static files from the base image to the distroless image in /static directory
#Because the static files are not part of the binary and we need html files 
COPY --from=base /app/static ./static

#Expose the port 8080 for the application   
EXPOSE 8080

#Run the binary
CMD [ "./main" ]