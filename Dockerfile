FROM golang:latest

RUN apt-get update -y
RUN apt-get install -y wget unzip cmake g++

RUN mkdir -p /home/bin /home/pkg /home/src/github.com/harrydrippin/brusta-go-ainize/launcher
WORKDIR /home/src
ENV GOPATH=/home

RUN wget https://download.pytorch.org/libtorch/cpu/libtorch-shared-with-deps-1.3.1%2Bcpu.zip -O /home/src/github.com/harrydrippin/brusta-go-ainize/libtorch.zip
RUN unzip /home/src/github.com/harrydrippin/brusta-go-ainize/libtorch.zip -d /home/src/github.com/harrydrippin/brusta-go-ainize/
RUN rm /home/src/github.com/harrydrippin/brusta-go-ainize/libtorch.zip

WORKDIR /home/src/github.com/harrydrippin/brusta-go-ainize

RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

ADD . /home/src/github.com/harrydrippin/brusta-go-ainize

RUN cd launcher && \
    CMAKE_PREFIX_PATH=../libtorch/share/cmake/Torch cmake CMakeLists.txt && \
    make && cp libmodel.so /usr/lib

RUN cp -r ./libtorch/include/**/* /usr/include
RUN cp -r ./libtorch/lib/* /usr/lib
RUN cp -r ./libtorch/share/**/* /usr/share

RUN /home/bin/dep ensure

RUN go build -o ./brusta-go

RUN ls -al

EXPOSE 8080
CMD ["./brusta-go"]