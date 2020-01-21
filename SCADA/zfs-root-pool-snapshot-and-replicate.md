## ZFS root pool snapshot and replicate

### Backup

Record existing properties :
`zpool get all rpool`
`zfs get all rpool`

Create snapshot recursively with a name after the `@`:
`zfs snapshot -r rpool@backup`

List the current snapshot to verify:
`zfs list -t snapshot`

Get rid of swap and dump snapshot as they are zvols(volumes):
`zfs destroy rpool/swap@backup`
`zfs destroy rpool/dump@backup`

Send each snapshot to a dump file or use a `-r` option:
`zfs send -r rpool@backup > /bak/rpool.dump`

### Restore

Boot from Solaris 10 DVD into single user mode which allow to access a console. Following will use `c1t1d0s0` as example:
`zfs create -fo altroot=/var/tmp/rpool -o cachefile=/etc/zfs/zpool.cache -m legacy rpool c1t1d0s0

Restore :
`zfs receive -Fdr rpool < /bak/rpool.dump`
