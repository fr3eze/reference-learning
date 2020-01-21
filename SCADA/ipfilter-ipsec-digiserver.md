## IPSec

https://docs.oracle.com/cd/E19253-01/816-4554/6maoq02fl/index.html#ipsec-mgtasks-createsa-2

#### How to Generate Random Numbers on a Solaris System

```
od -X `****`-A n /dev/random \| head -2
```

Refer to `admiaye:/FII/zf/ipsec-18Oct2014` for a couple of scripts for Ipsec.

- `/etc/inet/ipsecinit.conf` remains the same, copy over this file from ADM to new servers
- `/etc/inet/secret/ipseckeys` adds new entry:
- entry must be consist of in and out as a pair for an interface
- this entry pair will be unique within a `ipseckeys` file and be copied to destination server
- `chmod 400 /etc/inet/secret/ipseckeys`
- `chmod root/root /etc/inet/secret/ipseckeys`

Services below must be `online`

```
svcs -a | grep ipsec
online Sep_04 svc:/network/ipsec/ipsecalgs:/default
online Sep_04 svc:/network/ipsec/policy:/default
online Sep_04 svc:/network/ipsec/manual-key:/default
```

Refresh/restart service below on both servers to take effect

- Only `svc:/network/ipsec/policy:/default` if `/etc/inet/ipsecinit.conf` is modified
- Only `svc:/network/ipsec/manual-key:/default` if `/etc/inet/secret/ipseckeys` is modified

In case of `svc:/network/ipsec/manual-key:/default` in `maintenance` mode:

- `svcs -x <service>` to check the log for errors
- `ipseckey -c /etc/inet/secret/ipseckeys` to check for syntax error
- `ipseckey flush all` to flush all SA before adding in new one
- `svcadm clear <service>` clear the maintenance state before restart service

## IPFilter

`/etc/ipf/ipf.conf` remains the same
`/etc/ipf/ippool.conf` add IP of new servers and distribute from ADM

Copy over `/etc/ipf/ippool.conf` from ADM to new server

Restart/refresh `ipfilter` service on both servers to take effect
`svcadm refresh svc:/network/ipfilter:default`

## Digi port servers

- Connect computer and to the Digiport server via Ethernet port.
- Use windows tool `40002256_H` to detect the IP of Digi port server. Change computer LAN interface to IP in same family, login Digi port server via browser.
- Default username/password: root/dbps
- Configuration:
- Advanced Network Settings
- DNA Priority -> Static
- Ethernet Interface -> 10 Mbit, Full-Duplex
- Serial Port Configuration set to RealPort profile
- Update firware if necessary

## Example on how to trace IFS

1) On IFSU set channel 2 to “OFF” state
2) Turn on the trace with command “bum obj iecp ssig sigusr1”
3) Send a “CLOSE” or “OPEN” DO.
4) Send DO the opposite way as in previous step.
5) Then set channel 2 to “ON” state
6) Wait until channel 2 is Active.
7) Send a “CLOSE” or “OPEN” DO.
8) Send DO the opposite way as in previous step.
9) Stop the trace with command “bum obj iecp ssig sigusr2”

## Build system and FillSDM

- SPECSUB_IFS=1
- Create database first.

`cd param/param_scripts; ./RDBCREATE –auto –oemp1`

- Product handle
- Run up Com and restore selective odb for dynamic image
- Make sure `tnsping emp1; tnsping dms1; tnsping fshhis` is OK. If not, check the tnsnames.ora is correctly configured.

```
cd system/libprog
time ./buster –all+ -e –o $HOME/buster.log_`date +%y%m%d`
cd SpecUI; bld –R clean
syptosys all; biptobin
```

- Run up system.

`IMAGESOS; INITSOS -C ADM Pr`

- Propagate new system to other servers

```
SOS upda <all other servers in the system>
FillSDM -all -x -online -f 'N'
```

## HIS message retrieval via SQL

```
export ORACLE_SID=his
sqlplus hisu/h1s/pa55
select MESSAGE_TEXT from HIS_MESSAGE where MESSAGE_TEXT like '%07.18%';
```
