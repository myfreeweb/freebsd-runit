# vim: set ts=4 sw=4 et:

[ -n "$VIRTUALIZATION" ] && return 0

msg "Initializing swap..."
swapon -aq || emergency_shell
