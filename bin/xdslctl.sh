DEVICEIP=0.0.0.0
DEVICESSHUSER=root
DEVICESSHPORT=6666

STATSFILE=xdslctl.out

ZBX_SERVER=0.0.0.1
ZBX_HOST=dsldevice.lan

ssh $DEVICESSHUSER@$DEVICEIP -p $DEVICESSHPORT "xdslctl info --stats > $STATSFILE"; scp -qP $DEVICESSHPORT $DEVICESSHUSER@$DEVICEIP:$STATSFILE $STATSFILE

DSLSTATUS=`cat $STATSFILE | grep '^Status' | awk '{$1=""; print $0}' | sed -e 's/^ //'`
LASTRETRAINREASON=`cat $STATSFILE | grep 'Last Retrain Reason' | awk '{$1=$2=$3=""; print $0}' | sed -e 's/^ //'`
LASTINITSTATUS=`cat $STATSFILE | grep 'Last initialization procedure status:' | awk '{print $5}' | sed -e 's/^ //'`
DSLDOWNSTREAMRATE=`cat $STATSFILE | grep 'Max:.*Upstream rate' | awk '{print $10}' | sed -e 's/^ //'`
DSLUPSTREAMRATE=`cat $STATSFILE | grep 'Max:.*Upstream rate' | awk '{print $5}' | sed -e 's/^ //'`
DSLLINKPOWERSTATE=`cat $STATSFILE | grep 'Link Power State' | awk '{print $4}' | sed -e 's/^ //'`
DSLMODE=`cat $STATSFILE | grep 'Mode:' | awk '{$1=""; print $0}' | sed -e 's/^ //'`
VDSL2PROFILE=`cat $STATSFILE | grep 'VDSL2 Profile:' | awk '{$1=$2=""; print $0}' | sed -e 's/^ //'`
LINESTATUS=`cat $STATSFILE | grep 'Line Status:' | awk '{$1=$2=""; print $0}' | sed -e 's/^ //'`
SNRDOWN=`cat $STATSFILE | grep 'SNR' | awk '{print $3}' | sed -e 's/^ //'`
SNRUP=`cat $STATSFILE | grep 'SNR' | awk '{print $4}' | sed -e 's/^ //'`
ATTNDOWN=`cat $STATSFILE | grep 'Attn' | awk '{print $2}' | sed -e 's/^ //'`
ATTNUP=`cat $STATSFILE | grep 'Attn' | awk '{print $3}' | sed -e 's/^ //'`
PWRDOWN=`cat $STATSFILE | grep 'Pwr' | awk '{print $2}' | sed -e 's/^ //'`
PWRUP=`cat $STATSFILE | grep 'Pwr' | awk '{print $3}' | sed -e 's/^ //'`

zabbix_sender -z $ZBX_SERVER -s $ZBX_HOST -k xdslctl.info.status[attndown] -o "$ATTNDOWN" >/dev/null
zabbix_sender -z $ZBX_SERVER -s $ZBX_HOST -k xdslctl.info.status[attnup] -o "$ATTNUP" >/dev/null
zabbix_sender -z $ZBX_SERVER -s $ZBX_HOST -k xdslctl.info.status[dsldownstreamrate] -o "$DSLDOWNSTREAMRATE" >/dev/null
zabbix_sender -z $ZBX_SERVER -s $ZBX_HOST -k xdslctl.info.status[dsllinkpowerstate] -o "$DSLLINKPOWERSTATE" >/dev/null
zabbix_sender -z $ZBX_SERVER -s $ZBX_HOST -k xdslctl.info.status[dslmode] -o "$DSLMODE" >/dev/null
zabbix_sender -z $ZBX_SERVER -s $ZBX_HOST -k xdslctl.info.status[dslstatus] -o "$DSLSTATUS" >/dev/null
zabbix_sender -z $ZBX_SERVER -s $ZBX_HOST -k xdslctl.info.status[dslupstreamrate] -o "$DSLUPSTREAMRATE" >/dev/null
zabbix_sender -z $ZBX_SERVER -s $ZBX_HOST -k xdslctl.info.status[lastinitstatus] -o "$LASTINITSTATUS" >/dev/null
zabbix_sender -z $ZBX_SERVER -s $ZBX_HOST -k xdslctl.info.status[lastretrainreason] -o "$LASTRETRAINREASON" >/dev/null
zabbix_sender -z $ZBX_SERVER -s $ZBX_HOST -k xdslctl.info.status[linestatus] -o "$LINESTATUS" >/dev/null
zabbix_sender -z $ZBX_SERVER -s $ZBX_HOST -k xdslctl.info.status[pwrdown] -o "$PWRDOWN" >/dev/null
zabbix_sender -z $ZBX_SERVER -s $ZBX_HOST -k xdslctl.info.status[pwrup] -o "$PWRUP" >/dev/null
zabbix_sender -z $ZBX_SERVER -s $ZBX_HOST -k xdslctl.info.status[snrdown] -o "$SNRDOWN" >/dev/null
zabbix_sender -z $ZBX_SERVER -s $ZBX_HOST -k xdslctl.info.status[snrup] -o "$SNRUP" >/dev/null
zabbix_sender -z $ZBX_SERVER -s $ZBX_HOST -k xdslctl.info.status[vdsl2profile] -o "$VDSL2PROFILE" >/dev/null