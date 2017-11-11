# pod

## About 'pod'
**pod** is about automating tasks over many machines.    
Tested on Mac, Ubuntu and Centos.    

It is written in bash because sometimes thats all you can use in locked down environments (banking).    
Effort has been made to make pod as extensible as possible with new modules (or 'pods') planned.  
Its first two pods are specific to setting up and running a DSE cluster from **tarballs**.  
- **pod_dse**:    
    - setup, configure, distribute software to all servers in a cluster.  
- **pod_dse_rollingStartStop**:   
    - start and stop a dse cluster gracefully.   

Other dse specific pods in the pipeline:    
- **pod_dse_security**    
    - to automate configuration of files concerned with cluster encryption.    
- **pod_dse_opscenter**    
    - to automate the setup, configuration and encryption of opscenter/agents.    

## About 'pod_dse'  

With **'pod_dse'** you can easily create and manage multiple cluster setups (different versions/settings).  
You can deploy these different configurations to the same machines and they will not interfere with each other.  
As such pod is very useful in development/testing environments as well as setting up dse in production when opscenter is not an option.  

Pod will distribute, untar and configure all software sent to each server - defined in **two** pod configuration files.    
Out of the box - this will create a folder on your desktop with the unpacked software, data and log folders all in one place.  
Note: you have control over where data,logs and folders are put by editing its two configuration files.    

## Get started with 'pod_dse'   

Quick Instructions (to work out of the box):  

1) git clone https://github.com/jondowson/pod  

For Macs (both running pod and in a cluster) - you will need first run the dependencies script from the root folder of the repo.  
`  
$ ./misc/dependencies_mac.sh
`     

2) Make a folder on your desktop called 'DSE_SOFTWARE'.  
3) Add the following folder structure and tar files (add multiple versions per folder if you like).

- DSE_SOFTWARE  
  - packages  
    - dse
      - dse-5.x.x-bin.tar.gz  
    - oracle-java  
      - jdk-8uxxx-linux-i586.tar.gz    


4) In pod, duplicate the builds/pod_dse/ template folder, rename it and then review/edit its 'cluster_settings.sh' file.    
`
$ cp -r builds/pod_dse/dse-5.x.x_template  builds/pod_dse/dse-x.x.x_nameIt  
`  
`
$ vi builds/pod_dse/dse-x.x.x_nameIt/cluster_settings.sh    
`   

The 'cluster_settings.sh' file contains instructions, in brief, it captures cluster-wide settings such as cluster name as well as preferred paths.    


5) In pod, duplicate a servers template json file, rename and edit it.  
`
$ cp servers/template_x.json  servers/nameIt.json  
`  
`
$ vi servers/nameIt.json    
`     

The json defintion file contains instructions, in brief, it captures server specific settings such as login credentials and ip addresses.    


6) Finally run 'launch-pod' passing in the required parameters.  
`
$ ./launch-pod --pod pod_dse --servers nameIt.json --build dse-x.x.x_nameIt    
`

**Note:**    
When you first run pod, it will look in your specified builds folder to see if there is a '**resources**' folder.    
If there is not, it will untar your choosen dse version tarball and copy its resourcs folder there.    
The folder copied into pod is stripped of all **non-config files** - the remainder are then available for editing.    

The settings specified in 'cluster_settings.sh' and the servers '.json' files cover the most important settings.    
But for all the settings they do not cover, you can edit manually in the resources folder of your chosen build.    
So if required, hit **\<ctrl-c\>** at the end of this preperation stage (you will have 10 seconds!).    
Then you can edit config files and finally re-launch pod_dse to distribute the configured builds + software.    
