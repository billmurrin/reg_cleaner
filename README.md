# reg_cleaner
The purpose of this script is to parse the registry file for filebeat, see if the files in the registry exist, and if so, echo that line out to stdout. The effect of this method is that it will only echo the JSON for the files that do exist and will effectively remove the other files from the registry. You can store the output of this script into a new file and then replace your registry file with it.

## Disclaimer
I built this script on the limited datasets I have getting read by filebeat, this script works in my environment. This script is not destructive by nature. You will have to manually overwrite the registry file with the output of this script in order to replace it. If something is not parsing right from your registry file, feel free to open an issue with some example code from your registry file and I will work on modifying the script.

## Why this script
[This issue](https://github.com/elastic/beats/issues/1341) outlines why I built this script. Right now, the registry file stores all file state. Even if ignore_older is set, if the inode from a file is re-used, it may see the file as an update and this may cause the file to be parsed at the offset of the original file, or even worse, may cause no data to be sent.

### Basic Execution
The following outlines approximately how you can use the script.

#### Stop the Filebeat service
```
[me@HELLOBOBBY ~]# service filebeat stop

Stopping filebeat:  [  OK  ]
```

#### Make a backup copy of the registry file
```
[me@HELLOBOBBY ~]# cp /var/lib/filebeat/registry ./registry-backup
```

#### Execute the reg_cleaner script 
Next, execute the reg_cleaner script and have the results of the output go into a new file
```
 [me@HELLOBOBBY ~]# ./reg_cleaner.sh > new_registry
```

#### Check the results if you must
```
[me@HELLOBOBBY ~]# cat new_registry
 {"/awesome-o/dns.log":{"source":"/awesome-o/dns.log","offset":127271146,"FileStateOS":{"inode":9579100,"device":64792}},"/awesome-o/http.log":{"source":"/awesome-o/http.log","offset":14055563,"FileStateOS":{"inode":9579149,"device":64792}},"/mydata/HELLOBOBBY.20160408.2150.data":{"source":"/mydata/HELLOBOBBY.20160408.2150.data","offset":77898602,"FileStateOS":{"inode":9549700,"device":64792}},"/mydata/HELLOBOBBY.20160408.2200.data":{"source":"/mydata/HELLOBOBBY.20160408.2200.data","offset":78626351,"FileStateOS":{"inode":9579310,"device":64792}}}
```

#### If the results look good
If the results look good, copy them back into the location where your registry file is stored.
```
[me@HELLOBOBBY ~]# cp new_registry /var/lib/filebeat/registry
```
 
#### Start the service
```
[me@HELLOBOBBY ~]# service filebeat start
Starting filebeat: [  OK  ]

 2016/04/08 22:21:25.737647 geolite.go:24: INFO GeoIP disabled: No
 paths were set under output.geoip.paths
 2016/04/08 22:21:25.767145 logstash.go:106: INFO Max Retries set to: 3
 2016/04/08 22:21:26.015826 outputs.go:126: INFO Activated logstash as
 output plugin.
 2016/04/08 22:21:26.016732 publish.go:288: INFO Publisher name: SCHOM10ASW8N84
 2016/04/08 22:21:26.023822 async.go:78: INFO Flush Interval set to: 1s
 2016/04/08 22:21:26.023835 async.go:84: INFO Max Bulk Size set to: 2048
 2016/04/08 22:21:26.023931 beat.go:147: INFO Init Beat: filebeat; Version: 1.2.0
 ```
 
#### cat the mybeat file
If you are logging for filebeat you can examine this file to validate that you are properly reading the logs you are supposed to and that you are sending events.
