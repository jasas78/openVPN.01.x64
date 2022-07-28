
# https://swupdate.openvpn.org/community/releases/openvpn-2.4.1.tar.xz
# https://openvpn.net/index.php/open-source/downloads.html

ifneq ($(USER),dyn)
$(info   )
$(info "the user must be 'dyn' , now : $(USER)" )
$(info   )
$(error exit)
endif

time_called:=$(shell date +"%Y_%m%d__%H%M%P")
dir_called=$(shell basename `pwd`)
dir_called_full=$(shell pwd)

define EOL


endef


name:=openvpn
#ver:=2.3.8
#ver:=2.3.9
#ver:=2.3.10
ver:=2.3.11
ver:=2.4.1
ver:=2.5.7
ext:=tar.xz

build_dir:=1

dir01:=$(shell realpath `pwd`)
dir02:=$(dir01)/$(ver)

srcN:=$(name)-$(ver)
srcA:=srcOPENVPN/$(srcN).$(ext)

dir09:=$(build_dir)/$(name)-$(ver)
dir08:=$(dir09).bak01

src:=$(srcA)
src_Makefile:=$(srcN)/Makefile

x86sign:=$(shell uname -a |grep -q x86_64 && echo 1 || echo 2)

all :
	@echo ; echo ; echo
	@echo ' b    : build '
	@echo ' c    : clean '
	@echo ' e    : extract '
	@echo ' xp   : xor_patch  '
	@echo ' xd   : xor_diff  '
	@echo ' sqs  : gen_mksquashfs_server '
	@echo ' sqc  : gen_mksquashfs_client '
	@echo ' aaa  : clean extract xor_patch xor_diff build regen_lib '
	@echo 
#	@echo ' if need gen ld_libs , use : '
#	@echo '        sh ./test_lib.sh2 > 1.txt '
#	@echo '        cat 1.txt |xargs -n 1 -I '{}' cp '{}' lib/ '
	@echo ; echo ; echo

export nobody:=nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin$(EOL)dyn:x:500:500:dyn,,,:/home/dyn:/bin/bash
export nogroup:=nogroup:x:65534:dyn
ldlib:=/lib64/ld-linux-x86-64.so.2
rlib regen_lib:
	test ! -d sq_common/ || chmod -R u+w sq_common/
	rm -fr sq_common/
	test ! -d sq_common/ 
	mkdir sq_common/ sq_common/lib/
	cp $(ldlib) sq_common/lib/
	$(ldlib)     --list     $(ver)/sbin/openvpn	> sq_common/1.txt
	$(ldlib)     --list     /bin/bash          >> sq_common/1.txt
	$(ldlib)     --list     /bin/ls	           >> sq_common/1.txt
	cat sq_common/1.txt |awk '{print $$3}' |sort -u |grep -v ^$$ > sq_common/2.txt
	cat sq_common/2.txt |awk '{print "cp " $$1 " sq_common/lib/"}' > sq_common/3.txt
	mkdir -p 			sq_common/bin/ 
	cp /bin/bash 		sq_common/bin/ 
	cp /bin/ls 			sq_common/bin/ 
	mkdir -p            sq_common/ch2/tmp    # for the openvpn Chroot
	echo                sq_common/ch2/tmp/_
	mkdir -p            sq_common/etc
	echo "$${nobody}" >  sq_common/etc/passwd
	chmod 644           sq_common/etc/passwd
	echo "$${nogroup}" > sq_common/etc/group
	chmod 644           sq_common/etc/group
	bash sq_common/3.txt
	ls sq_common/lib/l* |xargs -n 1 strip --strip-unneeded
	@echo

sqs:=sq_server
export sqs
sqs : rlib 
	test ! -d $($@) || chmod -R u+w $($@)
	test ! -d $($@) || rm -fr $($@)
	test ! -d $($@) 
	mkdir $($@)
	( cd $(ver) && tar cf - .)                      | ( cd $($@) && tar xf - ) 
	chmod 755 	$($@)/
	for aa1 in $($@)/tmp $($@)/dev $($@)/proc $($@)/ch2 ; do \
		mkdir   -p	$${aa1} 	; \
		echo  	>	$${aa1}/_ 	; \
		done
	( cd /home/bootH/OpenVZ/openVPN.02.key/conf_`echo -n $($@)|cut -c 4-`/  && tar cf - .)     | ( cd $($@)/ && tar xf - ) 
	echo "/sbin/openvpn --config   /etc/openvpn/`echo -n $($@)|cut -c 4-`.conf" > $($@)/sss
	cd $($@)/ && chmod u+w . && ln -s lib/ lib64
	chmod -R a-w $($@)/
	rm -f                            		sq.openvpn.$@.$(ver).mksquashfs     sq.openvpn.mksquashfs
	nice -n 19 mksquashfs	$($@)/	sq.openvpn.$@.$(ver).mksquashfs     -comp xz -b 1M -force-uid nobody -force-gid nogroup
	ln -s                                   sq.openvpn.$@.$(ver).mksquashfs		sq.openvpn.$@.mksquashfs


#	sh ./test_lib.sh2 > 1.txt 
#	cat 1.txt |xargs -n 1 -I '{}' cp '{}' lib/ 

m:
	vim Makefile

c clean:
	@mkdir -p $(build_dir)/
	rm -fr $(dir09)/

$(src_Makefile): $(srcA)
	@mkdir -p $(build_dir)/
	cd $(build_dir) && tar xJf ../$^
	rm -f dst_dir
	#ln -s $(build_dir)/  dst_dir
	ln -s $(dir09)/ dst_dir

e extract : $(src_Makefile)

aaa : clean extract xor_patch xor_diff build regen_lib 

b build : force_i386 bbb2  
bbb2 : rm_ld_libs  run_config run_make run_rm_old_install_bin run_make_install

force_i386 :
#	[ "$(x86sign)" = '2' ] || ( echo ; echo ; echo "error met , no allow in a x86_64" ; echo ; echo ; exit 34 ) 

cb clean_bin run_rm_old_install_bin : 
	@echo
	[ -f $(ver)/sbin/openvpn ] && ( \
		chmod -R u+w $(ver)/ ; \
		rm -fr $(ver)/ ; \
		) || ( echo ; echo " $(ver)/sbin/openvpn don't exist " ; echo )
	@echo

#		LDFLAGS=" -Wl,-rpath=/system/ext41/lib -Wl,-rpath=/system/ext41/usr/lib -Wl,-rpath=/home/bootH/OpenVZ/i386/lib " \

rm_ld_libs:
	rm -f $(wildcard /home/bootH/OpenVZ/i386/lib/ld-linux.so.2 /home/bootH/OpenVZ/i386/lib/lib*.so.*)
run_config:
	cd $(dir09)/ && \
		./configure --prefix=$(dir02)        > ../log.$(srcN).configure.txt
#		LDFLAGS=" -Wl,-rpath=/system/ext41/lib -Wl,-rpath=/system/ext41/usr/lib -Wl,-rpath=/home/bootH/OpenVZ/i386/lib " \

run_make:
	cd $(dir09)/ && make                     > ../log.$(srcN).make.txt
run_make_install:
	cd $(dir09)/ && make install             > ../log.$(srcN).install.txt
	(find $(ver)/ -type f |xargs -n 1 strip --strip-unneeded ) 2>/dev/null ; echo
	chmod -R a-w $(ver)/




#######     HowTo compile OpenVPN + obfuscation with xorpatch on Debian
# apt-get install build-essential libssl-dev liblzo2-dev libpam0g-dev easy-rsa 
# wget http://swupdate.openvpn.org/community/releases/openvpn-2.3.7.tar.xz
# wget https://raw.githubusercontent.com/clayface/openvpn_xorpatch/master/openvpn_xor.patch
# tar xvf openvpn-2.3.7.tar.xz
# cd openvpn-2.3.7.tar.xz
# patch -p1 < ../openvpn_xor.patch
# ./configure
# ./make
# ./make install
# config --->>> scramble obfuscate xxxyyyzzz
#
# another patch :
# https://github.com/qzs21/Tunnelblick/blob/master/third_party/sources/openvpn/openvpn-2.3.7txp/patches/02-tunnelblick-openvpn_xorpatch.diff
# https://github.com/qzs21/Tunnelblick/raw/master/third_party/sources/openvpn/openvpn-2.3.7txp/patches/02-tunnelblick-openvpn_xorpatch.diff

xd2 xor_diff2  :
	@echo 
	@echo 'diff -r <$(dir09)> <$(dir08)>'
	diff -r $(dir09) $(dir08) 
	@echo 

xp xor_patch  :
	@echo 
#	cd $(dir09)/ && ( [ -L openvpn-2.3.6  ] || ln -s . openvpn-2.3.6  )
#	cd $(dir09)/ && ( [ -L openvpn-2.3.6_ ] || ln -s . openvpn-2.3.6_ )
#	cd $(dir09)/ && patch < ../../openvpn_xor.patch
#	cd $(dir09)/ && patch -p1 < ../../openvpn_xor.patch
	cd $(dir09)/ && patch -p1 < ../../xor_patch.patch99.$(ver)
	@echo 
xd xor_diff  :
	@echo 
	@echo  ' Usage : extract src dir to xxx.bak01 , then , modified them manually. '
	@echo  ' then , re-extract to xxx/ , and run this to gen the diff file '
	@echo
	@echo 
	cd $(dir09)/ && rm -f \
		srcOPENVPN/openvpn/forward.c.orig  \
		srcOPENVPN/openvpn/options.c.orig  \
		srcOPENVPN/openvpn/socket.h.orig
	cd $(dir09)/ && cd .. && (test ! -d $(srcN).bak01/ || ( diff -u -r $(srcN).bak01/ $(srcN)/  &> xor_patch.now.$(ver) ; \
		echo ; echo 'xor_patch.now.$(ver) ... is generated . ' ; pwd ; echo ))
	@echo 






gs:
	git status
gc:
	rm -f date.now.txt
	echo "$(dir_called_full)_ _$(time_called)" > date.now.txt
	git commit -a --template=date.now.txt
	sync

ga:
	git add .

gd:
	git diff
#gc:
#	git commit -a
gcX:
	git commit -a -m '$(time_called)'

up:
	git push

vim_prepare_clean :
	@mkdir -p _vim/
	@rm -f _vim/cscope.out       _vim/cscope.in?     _vim/tags


vp vim_prepare1 : vim_prepare_clean
	@ls Makefile*     > _vim/cscope.in0
#   @find  .  -type f -name "*.php" -o -name "Makefile*" >> _vim/cscope.files
	@cat _vim/vim_file01.txt |sed -e 's/^ *//g' |sed -e '/^#.*$$/d' |sed -e 's/ *$$//g' |sed -e '/^$$/d' >> _vim/cscope.in1 
	cat _vim/dir_01.txt |sed -e 's/^ *//g' |sed -e '/^#.*$$/d' |sed -e 's/ *$$//g' |sed -e '/^$$/d' |sort -u \
		|xargs -n 1 -I '{}' find '{}' -maxdepth 1 -type f \
		-name "*.c" -o -name "*.s" -o -name "*.S" -o -name "*.h" -o -name "*.cpp" -o -name "*.hpp" \
		-o -name "*.sh" -o -name "Makefile*" \
		-o -name "Kconfig*" \
		-o -name "*config.mk" \
		-o -name "*.conf" \
		|grep -v mod\\.c$$  \
		|sort -u >> _vim/cscope.in2
	@cat _vim/cscope.in? |sort -u > _vim/cscope.files
	@rm -f _vim/cscope.in? cscope.out tags
	@ctags -L _vim/cscope.files
	@cscope -Rbu  -k -i_vim/cscope.files 
	sync


