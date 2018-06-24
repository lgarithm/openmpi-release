TAG = openmpi-builder:snapshot


tgz: builder_image openmpi-3.1.0.tar.bz2
	docker run --rm -v$(shell pwd):/host -it $(TAG) sh /host/build-openmpi.sh
	# docker run --rm -v$(shell pwd):/host -it $(TAG)


builder_image:
	docker build --rm -t $(TAG) .


openmpi-3.1.0.tar.bz2:
	curl -vLOJ https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.0.tar.bz2
