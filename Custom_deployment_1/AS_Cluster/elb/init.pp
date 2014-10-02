#Global Parameters

$script_base_dir = inline_template("<%= Dir.pwd %>") # Current Location
$deployment_target = '/home/yasassri/Desktop/QA_Resources/puppet/mySCripts/elb/deploy'


#Param Class - All the Parameters are set here
class params {

 $elb_pack_location = '/home/yasassri/Desktop/soft/WSO2_Products/ELB'
 $configchanges = ['loadbalancer.conf','axis2/axis2.xml']
# ELB Configs
  
  $group_mgt_port = '4500'
  $main_domain = 'wso2.as.domain'
  $mgt_hosts = ['mgt.as.wso2.com'] #Add host names of multiple manager nodes ['host1','host2']
  $worker_hosts = ['as.wso2.com','as.wk1.wso2.com']
  $service_domain = 'appserver'
 
 #Axis 2.xml Properties (Listener Properties)
 
 $http_port = '80'
 $https_port = '443'
 $local_ip = '10.100.5.112'
 
}
####################~END OF PARAM CLASS~################################

###############~Deployment and Config Class~#############################
class elb inherits params{

#notify {$group_mgt_port:}

#Creating Deployment directory

file {"$deployment_target/elb":

	ensure => directory;
}

#Coppying the deployment Directories

exec {"Copying_ELB_to_carbonHome":

	path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/java/bin/', # The search path used for command execution.
	command => "cp -r ${elb_pack_location}/wso2elb-*/* ${deployment_target}/elb/",
	require => File["$deployment_target/elb"],
}

# pushing Templates, here we are iterating over the array
pushTemplates {$configchanges:}
}

# Resorce Definition to push templates

define pushTemplates {

	file {"${deployment_target}/elb/repository/conf/${name}":

	ensure => present,
	owner   => $owner,
    	group   => $group,
    	mode    => '0755',
	content => template("${script_base_dir}/templates/${name}.erb"),
	require => Exec["Copying_ELB_to_carbonHome"],
	}
  
notify { "Config File ${name} changed!!!!": }
}


include elb
