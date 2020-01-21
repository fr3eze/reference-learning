## Viewing and changing policy of Clearcase 

- policy may affect which user with what permission can access the vob

## These permisson may affect vob2unix and etc

`cto lspolicy -----> display the policy in play`

`cto lspolicy -l <policy> --------> display in depth information of policy (include user and rights)`

## Changing policy

`cto chpolicy -nc -kind <element> -add/remove/modify User:spsy/root -permission Read/Full <Policy>`

NOTE: you need to do it for all the vob if all of them is affected.

`for i in `cto lsvob -s`;do
cd $i
cto chpolicy -nc -kind element -add Everyone -permission Read DefaultPolicy`

## Clearcase promotion

```
user : vobadm_p

newgrp spec <--- change group to spec, neccessary if you check in your code ask spsy:spec, you will need to change grp to spec to allow

        clearcase to unlock the branch for promoting

cto setview promote

cd /usr/local/conf/ccase

choose the right config spec for promotion

ccprom -f <config spec>
```

## Create new Element

```
user vobadm_p
group spec - newgrp spec
cto setview <view>
cto desc <file> - to see file type
cto mkelem -eltype directory/key_texted_file -nc <name_of_directory/file>
```

## Some advance command line control.

```
cto co -nc <files>
cto checkout -nocomment <files>

cto lsco
cto listcheckout

cto findmerge . -fver /main/sppg-int/ad-paramarsation/LATEST -print

cto <find files that need to be merge from .> <current working directtory> -fver <view-name> <print the file need to be merge without really merging them yet>

cto findmerge . -fver /main/sppg-int/ad-paramarsation/LATEST -merge -nc ----> merge using branch with no comment

cto findmerge . -fver SP7_V01.30_HOTFIX_01 -merge -nc ----> merge using label with no comment

rm *.contrib

rm findme*

cto lsco .

cto ci -nc `cto lsco -s .`
cto ci -nc `cto lsco -s -avobs | grep "/vob/smrt46"`

cd /vob/sppg

find . -name "*.contrib" -exec rm {} \;
```

#### examples config spec for project view

eg: ad-nato

```
element * CHECKEDOUT
element * .../ad-nato/LATEST -time 15-Mar-2016
element * .../cps-int/LATEST -mkbranch ad-nato
element * /main/LATEST -mkbranch cps-int
```

NOTE: for -mkbranch command to work, all the vob must have the branch type
NOTE: you can add in the -time option to make the view select an eariler version.

##### command to check branch type created in vob 

```
cto lstype -kind brtype -invob \<vob>
```

#### how to get the vob 

```
cto lsvob -s
```

Note: you can check anyone of the vob or all the vob.if the branch type is not created,

##### creating branch type for vob 

```
cto lsvob -s
cd <vob>
cto mkbrtype -nc -global <branch name>
```

if you want to do it for all vob just use a for loop:

```
for i in `cto lsvob -s`; do
cd $i
cto mkbrtype -nc -global <branch name>
done
```

#### unlock vob

```
for i in `/usr/atria/bin/cleartool lsvob -s`; do
/usr/atria/bin/cleartool unlock vob:$i
done
```

#### change permission or user:group for element

```
cto protect -chmod 755 <filename>
cto protect -chgrp <newgroup> -chown <newuser> <filename>
```

#### unregister vob and view 

```
cto lsvob >> logfile
```

edit to logfile to remain only path (not tag) Note: cto lsvob -long

```
for i in `cat logfile`;do
cto unregister -vob $i
done
cto lsview >> logfileview
```

edit to logfileview to remain only path (not tag) Note: cto lsview -long

```
for i in `cat logfileview`;do
cto unregister -view $i
done
```

#### unmount vob

```
cto umount -all
```

#### remove tag

```
for i in `cto lsvob -s`; do
cto rmtag -vob -all -password <rgy_password password> $i
done
```
normally hostname Note: /usr/atria/etc/rgy_passwd

### remove view

```
for i in `cto lsview -s`; do
cto rmtag -view -all $i
done
```

#### check vob schema

```
cto desc -long vob:<vob-tag>
```

#### Remove branch from all element

```
for i in `cto lsvob -s`;do
cd $i
cto rmtype -rmall -force brtype:BRANCH_TYPE_NAME
done
```

NOTE: Might need to chpolicy of vob to enable mod_branch policy to delete branch.

#### create branch for all element

```
echo $PROJECT (make sure you are using the right project)
all_vobs “cleartool mkbrtype -nc $PROJECT-int”
```

#### To lock and unlock trigger in case of rmelem

```
cleartool lock -obsolete trtype:<trigger type name>
cleartool unlock trtype:<trigger type name>
```

#### create view

```
cleartool mkview -tag <viewName> -stgloc -auto or define view-tag storage location
```
