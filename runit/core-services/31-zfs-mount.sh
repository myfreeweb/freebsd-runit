# No ZFS support on FreeBSD/powerpc
[ "$(sysctl -n hw.machine_arch)" = "powerpc" ] && return 0

if [ -z "${JAILED}" ]; then
	echo "=> Mounting ZFS datasets"
	zfs mount -va || emergency_shell

	echo "=> Sharing ZFS datasets"
	zfs share -a || emergency_shell
	if [ ! -r /etc/zfs/exports ]; then
		touch /etc/zfs/exports
	fi
elif [ "$(sysctl -n security.jail.mount_zfs_allowed)" -eq 1 ]; then
	echo "=> Mounting ZFS datasets"
	zfs mount -a || emergency_shell
fi
