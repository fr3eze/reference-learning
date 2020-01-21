## Upgrade PHPIPAM from v0.5

Problem statement: Upgrading of earlier PHPIPAM version is through a series of SQL scripts which is independent but continuous of each other. The quickest way to upgrade from old version to the latest is to collect all the SQL scripts, put them in oldest to newest order, and loop through them one time to an existing old database. 

#### Consolidation of old versions into single directory

- Make a directory with all the old versions, download from: https://sourceforge.net/projects/phpipam/files/

```
user@ubuntu18:/var/www/html/old_versions$ ls -l *tar
-rw-r--r-- 1 user user  2245120 Jun 27 04:17 phpipam-0.7.tar
-rw-r--r-- 1 user user  3996672 Jun 27 04:17 phpipam-0.8.tar
-rw-r--r-- 1 user user  4907008 Jun 27 04:17 phpipam-0.9.tar
-rw-r--r-- 1 user user  5687296 Jun 27 04:17 phpipam-1.0.tar
-rw-r--r-- 1 user user  6205440 Jun 27 04:18 phpipam-1.1.010.tar
-rw-r--r-- 1 user user  6198784 Jun 27 04:17 phpipam-1.1.tar
-rw-r--r-- 1 user user  9223168 Jun 27 04:17 phpipam-1.2-2.tar
-rw-r--r-- 1 user user  9226240 Jun 27 04:01 phpipam-1.2.tar
-rw-r--r-- 1 user user 32209920 Jun 27 03:45 phpipam-1.3.2.tar
```

- Untar each of the tar files into separate folder

```
for i in `ls *tar`; do folder=${i/.tar/}; mkdir $folder && tar xpf $i -C $folder; done
```

- Copy all UPDATE.sql into new folder UPDATEdir. Duplicate files will be blocked from overwriting the copied file in new folder, run the command for a few times if needed. But it is good to just run it once since the those are just identical duplicated files.

```
sudo cp `ls -SF phpipam-*/db/UPD*` UPDATEdir/
```

- Delete UPDATE-v0.6.sql since it is covered in UPDATE-v0.5.sql.

#### Upgrade database

- Access the newly created instance: ssh -i "logstash.pem" ubuntu@10.120.11.205
- Recreate database to get rid of the latest schema in order to restore v0.5 LGA database

```
sudo mysql -u root -p
drop database phpipamdb;
create database phpipamdb;
```

- Import current database dump v0.5 from existing LGA phpipam site:

```
cd /var/www/html/old_versions/UPDATEdir
sudo mysql -u root -p phpipamdb < phpipam_IP_adress_export_2019-07-19.sql
```

- Update from v0.5 to v1.1 by looping the SQL script:

```
for n in $(ls -A1 U*); do echo "$n"; sudo mysql -u root -p phpipamdb < "$n" ; done
```

- Update from v1.1 to v1.32:

```
sudo mysql -u root -p phpipamdb < 1.11_above/UPDATE.sql
```

- Update queries are stored in functions/upgrade_queries.php form version 1.4 onwards, from the latest phpipam folder download using git above, extract the SQL script of current DB version. The extracted SQL script consist of update queries starting from 1.4 to the latest version (v1.5 as of now)

```
cd /var/www/html/phpipam
sudo sh -c "php functions/upgrade_queries.php 1.4 > UPDATE-latest.sql"
```

- Update from 1.32 to v1.5:

```
sudo mysql -u root -p phpipamdb < /var/www/html/phpipam/UPDATE-latest.sql
```

- In case need to insert default user Admin to access, insert data in database phpipamdb, password ipamadmin:

```
INSERT INTO `users` (`id`, `username`, `password`, `groups`, `role`, `real_name`, `email`, `domainUser`,`widgets`, `passChange`)
VALUES (1,'Admin',X'243624726F756E64733D33303030244A51454536644C394E70766A6546733424524B3558336F6132382E557A742F6835564166647273766C56652E3748675155594B4D58544A5573756438646D5766507A5A51506252626B38784A6E314B797974342E64576D346E4A4959684156326D624F5A33672E',X'','Administrator','phpIPAM Admin','admin@domain.local',X'30','statistics;favourite_subnets;changelog;access_logs;error_logs;top10_hosts_v4', 'Yes');
```

- Access PHPIPAM in browser, perform automatic database update if there is any. You should be good to login now.


