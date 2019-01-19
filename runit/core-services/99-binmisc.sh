# shellcheck disable=SC1117,SC2034,SC2086
[ -n "${JAILED}" ] && return 0

echo "=> Registering binary image activators"

arm_interpreter=/usr/local/bin/qemu-arm-static
arm_magic="\x7f\x45\x4c\x46\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00"
arm_mask="\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff"

armv6_interpreter=/usr/local/bin/qemu-arm-static
armv6_magic="\x7f\x45\x4c\x46\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00"
armv6_mask="\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff"

armv7_interpreter=/usr/local/bin/qemu-arm-static
armv7_magic="\x7f\x45\x4c\x46\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00"
armv7_mask="\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff"

aarch64_interpreter=/usr/local/bin/qemu-aarch64-static
aarch64_magic="\x7f\x45\x4c\x46\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xb7\x00"
aarch64_mask="\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff"

mips_interpreter=/usr/local/bin/qemu-mips-static
mips_magic="\x7f\x45\x4c\x46\x01\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x08"
mips_mask="\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff"

mipsel_interpreter=/usr/local/bin/qemu-mipsel-static
mipsel_magic="\x7f\x45\x4c\x46\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x08\x00"
mipsel_mask="\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff"

mips64_interpreter=/usr/local/bin/qemu-mips64-static
mips64_magic="\x7f\x45\x4c\x46\x02\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x08"
mips64_mask="\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff"

powerpc_interpreter=/usr/local/bin/qemu-ppc-static
powerpc_magic="\x7f\x45\x4c\x46\x01\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x14"
powerpc_mask="\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff"

powerpc64_interpreter=/usr/local/bin/qemu-ppc64-static
powerpc64_magic="\x7f\x45\x4c\x46\x02\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x15"
powerpc64_mask="\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff"

sparc64_interpreter=/usr/local/bin/qemu-sparc64-static
sparc64_magic="\x7f\x45\x4c\x46\x02\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x2b"
sparc64_mask="\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff"

wine32_interpreter=/usr/local/bin/wine
wine32_magic="\x4d\x5a\x90\x00\x03\x00\x00\x00\x04\x00\x00\x00\xff\xff\x00\x00\xb8\x00\x00\x00"
wine32_mask="\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff"

for arch in arm armv6 armv7 aarch64 mips mipsel mips64 powerpc powerpc64 sparc64 wine32; do
	if [ -x "$(eval echo \$${arch}_interpreter)" ]; then
		/usr/sbin/binmiscctl remove ${arch} >/dev/null 2>&1
		/usr/sbin/binmiscctl add ${arch} --size 20 --set-enabled \
			--interpreter "$(eval echo \$${arch}_interpreter)" \
			--magic "$(eval echo \$${arch}_magic)" \
			--mask "$(eval echo \$${arch}_mask)" ||
			echo "WARNING: Failed to activate ${arch} interpreter"
	fi
done
