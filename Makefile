obj-m	:= src/facer.o

KERNELDIR ?= /lib/modules/$(shell uname -r)/build
PWD       := $(shell pwd)

all: default

default:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules

install:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules_install

clean:
	rm -rf src/*.o src/*~ src/.*.cmd src/*.ko src/*.mod.c \
		.tmp_versions modules.order Module.symvers

dkmsclean:
	@dkms remove facer/0.1 --all || true
	@dkms remove facer/0.2 --all || true

dkms: dkmsclean
	dkms add .
	dkms install -m facer -v 0.2

onboot:
	echo "facer" > /etc/modules-load.d/facer.conf

noboot:
	rm -f /etc/modules-load.d/facer.conf