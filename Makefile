

ifneq ($(USER),dyn)
	$(info   )
$(info "the user must be 'dyn' , now : $(USER)" )
	$(info   )
	$(error exit)
endif

time_called:=$(shell date +"%Y_%m%d__%H%M%P")
dir_called=$(shell basename `pwd`)
dir_called_full=$(shell pwd)



name:=openvpn
#ver:=2.3.8
ver:=2.3.9
ext:=tar.xz

build_dir:=1

dir01:=$(shell realpath `pwd`)
dir02:=$(dir01)/$(ver)

srcN:=$(name)-$(ver)
srcA:=src/$(srcN).$(ext)

dir09:=$(build_dir)/$(name)-$(ver)
dir08:=$(dir09).bak01

src:=$(srcA)
src_Makefile:=$(srcN)/Makefile

x86sign:=$(shell uname -a |grep -q x86_64 && echo 1 || echo 2)

all :
	@echo ; echo ; echo
	@echo ' b   : build '
	@echo ' c   : clean '
	@echo ' e   : extract '
	@echo ' xp  : xor_patch  '
	@echo ' ceb : clean extract xor_patch build '
	@echo 
	@echo ' if need gen ld_libs , use : '
	@echo '        sh ./test_lib.sh2 > 1.txt '
	@echo '        cat 1.txt |xargs -n 1 -I '{}' cp '{}' lib/ '
	@echo ; echo ; echo
m:
	vim Makefile

c clean:
	@mkdir -p $(build_dir)/
	rm -fr $(dir09)/

$(src_Makefile): $(srcA)
	@mkdir -p $(build_dir)/
	cd $(build_dir) && tar xJf ../$^

e extract : $(src_Makefile)

ceb : clean extract xor_patch build

b build : force_i386 bbb2  
bbb2 : rm_ld_libs  run_config run_make run_make_install

force_i386 :
	[ "$(x86sign)" = '2' ] || ( echo ; echo ; echo "error met , no allow in a x86_64" ; echo ; echo ; exit 34 ) 


#		LDFLAGS=" -Wl,-rpath=/system/ext41/lib -Wl,-rpath=/system/ext41/usr/lib -Wl,-rpath=/home/bootH/OpenVZ/i386/lib " \

rm_ld_libs:
	rm -f $(wildcard /home/bootH/OpenVZ/i386/lib/ld-linux.so.2 /home/bootH/OpenVZ/i386/lib/lib*.so.*)
run_config:
	cd $(dir09)/ && \
		LDFLAGS=" -Wl,-rpath=/system/ext41/lib -Wl,-rpath=/system/ext41/usr/lib -Wl,-rpath=/home/bootH/OpenVZ/i386/lib " \
		./configure --prefix=$(dir02)        > ../log.$(srcN).configure.txt
run_make:
	cd $(dir09)/ && make                     > ../log.$(srcN).make.txt
run_make_install:
	cd $(dir09)/ && make install             > ../log.$(srcN).install.txt




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

xd xor_diff  :
	@echo 
	diff -r $(dir09) $(dir08) 
	@echo 

xp xor_patch  :
	@echo 
#	cd $(dir09)/ && ( [ -L openvpn-2.3.6  ] || ln -s . openvpn-2.3.6  )
#	cd $(dir09)/ && ( [ -L openvpn-2.3.6_ ] || ln -s . openvpn-2.3.6_ )
	cd $(dir09)/ && patch -p1 < ../../openvpn_xor.patch
#	cd $(dir09)/ && patch < ../../openvpn_xor.patch
	@echo 






gs:
	git status
gc:
	rm -f date.now.txt
	echo "$(dir_called_full)_ _$(time_called)" > date.now.txt
	git commit -a --template=date.now.txt
	sync

gd:
	git diff

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


