#!/bin/bash
PATH=$PATH:$GOPATH/bin:/usr/local/go/bin

if [ ! -d /usr/local/go ]; then
    sudo curl -O https://dl.google.com/go/go1.11.1.linux-amd64.tar.gz
    sudo tar -xvf go1.11.1.linux-amd64.tar.gz
    sudo mv go /usr/local
    sudo rm go1.11.1.linux-amd64.tar.gz
    echo "export GOPATH=$GOPATH" >> "$VHOME/.profile"
    echo "export PATH=\$PATH:\$GOPATH/bin:/usr/local/go/bin" >> "$VHOME/.profile"
fi

sudo -u vagrant -H bash -c "
id
source ~/.profile

if ! command -V golint ; then
    go get -u github.com/golang/lint/golint
    go get -u golang.org/x/tools/cmd/cover
    go get -u golang.org/x/tools/cmd/goimports
fi

if ! command -V protoc-gen-go ; then 
    go get -u github.com/golang/protobuf/...
    go get -u github.com/grpc-ecosystem/grpc-gateway/...
fi

if ! command -V glide ; then
    curl https://glide.sh/get | sh
fi

if ! command -V migrate ; then 
    go get -u github.com/golang-migrate/migrate/cli
    cd $GOPATH/src/github.com/golang-migrate/migrate/cli
    go get -u github.com/go-sql-driver/mysql
    go build -tags 'mysql' -o migrate github.com/golang-migrate/migrate/cli
    sudo mv ./migrate /usr/local/bin/migrate
    cd ~/
fi

if ! command -V buildifier ; then
    go get -d -u github.com/bazelbuild/buildifier/buildifier
    # generate step is why this isn't Glide-able
    go generate github.com/bazelbuild/buildifier/core
    go install github.com/bazelbuild/buildifier/buildifier
fi

if ! command -V go-bindata ; then
    go get -u github.com/jteeuwen/go-bindata/...
fi

go get -u github.com/gogo/protobuf/...

# used for local filesystem watching
if ! command -V modd ; then
    go get github.com/cortesi/modd/cmd/modd
fi
"
