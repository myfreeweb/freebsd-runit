msg "Pruning nextboot configuration..."
/sbin/nextboot -D

msg "Setting up loopback interface..."
ifconfig lo0 inet 127.0.0.1/8 alias

_hostname=$(sysrc -qn hostname)
if [ -n "${_hostname}" ]; then
	msg "Setting hostname to '${_hostname}'..."
	hostname "${_hostname}"
else
	msg_warn "Didn't setup a hostname!"
fi

if [ -e "/etc/pf.conf" ]; then
	msg "Loading PF ruleset from '/etc/pf.conf'..."
	pfctl -f /etc/pf.conf $(conf pfctl_flags)
fi

if [ -e "/etc/rctl.conf" ]; then
	msg "Applying resource limits from '/etc/rctl.conf'..."
	while read var comments; do
		case ${var} in
		\#*|'') ;;
		*) echo "${var}" ;;
		esac
	done < /etc/rctl.conf | xargs rctl -a
fi

msg "Restoring soundcard mixer values..."
for dev in /dev/mixer*; do 
	if [ -r ${dev} ] && [ -r "/var/db/${dev}-state" ]; then
		/usr/sbin/mixer -f ${dev} $(cat "/var/db/${dev}-state") > /dev/null
	fi
done