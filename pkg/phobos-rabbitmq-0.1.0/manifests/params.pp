# définition des paramètres par défaut 

class rabbitmq::params
{
    ######## configuration install ########
    $config_server 			= true


	######### PACKAGES ######## 
	$package_manage       	= true
	$package_ensure       	= 'installed' 
	$package_mq		        = ['erlang','rabbitmq-server']
   
		  
	######### SERVICES ########
	$service_manage 		= true
	$service_mq		   		= 'rabbitmq-server'  #rabbitmq, rabbitmqctl 
	$service_ensure         = 'running'            
	$service_enable         = true
	$service_hasstatus		= true
	$service_hasrestart 	= true


	###### CONFIG_FILES ######      
	$file_ensure            = 'present'  
	$file_group             = '0' 
	$file_mode              = '0640' 
	$file_owner             = 'rabbitmq'  
	$file_backup            = '.puppet-bak'  


	# CONFIGURATION MIDDLEWARE 
	#$middlle_libdir                 = 


}
