include $(PQ_FACTORY)/factory.mk

pq_part_name := guile-2.0.11
pq_part_file := $(pq_part_name).tar.gz

pq_configure_args += --with-libgmp-prefix=$(pq-gmp-dir)
pq_configure_args += --with-libltdl-prefix=$(pq-libtool-dir)
pq_configure_args += --with-libiconv-prefix=$(pq-libiconv-dir)
pq_configure_args += --with-libreadline-prefix=$(pq-readline-dir)
pq_configure_args += --with-libunistring-prefix=$(pq-libunistring-dir)
pq_configure_args += --prefix=$(part_dir)
pq_configure_args += --with-threads

build-stamp: stage-stamp
	$(MAKE) -C $(pq_part_name)
	$(MAKE) -C $(pq_part_name) install install-info DESTDIR=$(stage_dir)
	touch $@

stage-stamp: configure-stamp

configure-stamp: patch-stamp
	cd $(pq_part_name) && ./configure $(pq_configure_args)
	touch $@

patch-stamp: unpack-stamp
	patch -p0 < $(source_dir)/fix-guile-config.patch
	patch -p1 -d $(pq_part_name) < $(source_dir)/0002-Add-colorized-REPL.patch
	patch -p0 < $(source_dir)/fix-guile-texinfo-for-colorized-section.patch
	patch -p0 < $(source_dir)/add-colorized-to-makefile.patch
	patch -p0 < $(source_dir)/add-oop-goops-save-exports.patch
	patch -p0 < $(source_dir)/add-oop-goops-save-srfi-19-date-time.patch
	patch -p0 < $(source_dir)/fix-web-uri-decode-plus-to-space.patch
	touch $@

unpack-stamp: $(pq_part_file)
	tar -xf $(source_dir)/$(pq_part_file)
	touch $@

