all: musl_build compiler-rt_build

musl_build:
	mkdir musl_build
	cd musl_build && RANLIB=llvm-ranlib-10 AR=llvm-ar-10 CC=clang-10 \
	       CFLAGS="-target riscv64 -march=rv64i" ../musl-1.2.0/configure \
	       --target=riscv64 --disable-shared --prefix=`pwd`/install && \
	       make -j32 && \
	       make install
	
compiler-rt_build:
	mkdir compiler-rt_build
	cd compiler-rt_build && ASMFLAGS="-target riscv64 -march=rv64i" \
		CC=clang-10 CFLAGS="-target riscv64 -march=rv64i \
		-I`pwd`/../musl_build/install/include" \
		cmake ../compiler-rt/ \
		-DLLVM_CONFIG_PATH=/usr/bin/llvm-config-10 \
		-DCOMPILER_RT_DEFAULT_TARGET_TRIPLE=riscv64 \
		-DCMAKE_SYSTEM_NAME=riscv64 \
		-DCMAKE_C_COMPILER_WORKS=1 \
		-DCMAKE_INSTALL_PREFIX=`pwd`/install && \
		make -j32 && \
		make install

clean:
	rm -rf musl_build compiler-rt_build
