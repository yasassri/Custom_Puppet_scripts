Custom_Puppet_scripts
=====================

How to Run
----------
1.  Clone the repository
2.  Do the necessary changes in the ESB_deploy.pp file. (Within the Param Class - Make sure product pack is unzipped)
3.  Run the script as following "puppet apply ESB_deploy.pp"

Note : Script will not create Databases. The script will create necessary elb configuration files and other LB configs. Copy/Append the configs as necessary
