include $(PQ_FACTORY)/factory.mk

pq_part_name := guile-2.0.11
pq_part_file := $(pq_part_name).tar.gz

build-stamp: stage-stamp
	$(MAKE) -C $(pq_part_name) && \
	$(MAKE) -C $(pq_part_name) install install-info DESTDIR=$(stage_dir) && \
	touch $@

stage-stamp: configure-stamp

configure-stamp: patch-stamp
	( \
		cd $(pq_part_name) && \
		./configure --with-threads \
			    --prefix=$(part_dir) \
			    --with-libgmp-prefix=$(pq-gmp-dir) \
			    --with-libltdl-prefix=$(pq-libtool-dir) \
			    --with-libiconv-prefix=$(pq-libiconv-dir) \
			    --with-libreadline-prefix=$(pq-libreadline-dir) \
			    --with-libunistring-prefix=$(pq-libunistring-dir) \
	) && touch $@

patch-stamp: unpack-stamp
	patch -p0 < ../fix-guile-config.patch
	patch -p1 -d $(pq_part_name) < ../0002-Add-colorized-REPL.patch
	patch -p0 < ../fix-guile-texinfo-for-colorized-section.patch
	patch -p0 < ../add-colorized-to-makefile.patch
	patch -p0 < ../add-oop-goops-save-exports.patch
	patch -p0 < ../add-oop-goops-save-srfi-19-date-time.patch
	patch -p0 < ../fix-web-uri-decode-plus-to-space.patch
	touch $@

unpack-stamp: $(pq_part_file)
	tar -xf $(source_dir)/$(pq_part_file) && touch $@
