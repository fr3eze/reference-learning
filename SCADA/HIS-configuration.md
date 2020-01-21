## Build HIS

Refer to official HIS guide under `/home/s/src/param/tech_notes`

On a system with HIS installed, to rebuild HIS

01. STOPSOS both HIS1, HIS2

Don't forget to replace the tnsnames.ora on PC_COM
since HIS uses a slightly specialized tnsnames (vs emp1)

#### Step A:
```
cd param/param_scripts
export ORACLE_SID=his
RDBCREATE -auto -ohis
```

#### Step B: Check the TZ by doing "env | grep TZ"

```
. /home/s/env/Profile_0150.spectrum_shhis
export ORACLE_SID=his
cd param/param_scripts
echo "y" | RDBCREATE -lstop
echo "y" | RDBCREATE -lstart
RDBCREATE -dstart -ohis
sqlplus / as sysdba << END
alter database set time_zone='Singapore';
exit;
END
RDBCREATE -dshut -ohis
RDBCREATE -dstart -ohis
sqlplus / as sysdba << END
@$ORACLE_HOME/javavm/install/initjvm.sql
exit;
END
sqlplus / as sysdba << END
select * from all_registry_banners;
select dbtimezone from dual;
exit;
END
```

#### Step C:

```
. /home/s/env/Profile_0150.spectrum_shhis
export ORACLE_SID=his
cd /home/s/sys/shhis

HisInstall.pl -action add -service his -path $SHHIS_INSTPATH -his -common -webui -sp3
```

#### Step D:

```
cd /home/s/bin
orawrap sqlpl DEF_SQL his null hisu XLOGINX<<-EODISABLEJOB
exec dbms_scheduler.drop_job('HISU.SP3_PROCESS_JOB');
exit;
EODISABLEJOB
```

#### Step E:

```
. /home/s/env/Profile_0150.spectrum_shhis
export ORACLE_SID=his
cd /home/s/sys/shhis
HisAddUser.pl -u SPECTRUM -op i -service HIS -access w -admin T
```

If errors occur in this step, check your username/password configurations are correct in `/home/s/bin/constman`

#### Step F:

```
HisAddUser.pl -u SPECTRUM -op m -service HIS -add 1:2:3:4:5:6:7:8:9:10:11:12:13:14:15
```
Errors? See below for help.

```
HisInstall.pl -action add -service his -path $SHHIS_INSTPATH -common
HisInstall.pl -action update -service his -path $SHHIS_INSTPATH -his

select C_LIB.GetConfigString('OTSActive') from dual;
select C_TIME.SysdateUtc from dual;
select * from user_objects where object_name like '%C_TIME%';
select sys_extract_utc(systimestamp) from dual;

select to_date(to_char(sys_extract_utc(systimestamp),'DDMMYYYYHH24MISS'),'DDMMYYYYHH24MISS')

from dual;

@/home/s/src/code/RC_PCSW_HIS/Schema/Src/PACKAGE/COMMON/C_TIME.spb
```
