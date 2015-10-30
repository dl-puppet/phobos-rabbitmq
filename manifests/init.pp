class rabbitmq 
(  
 
  ######## configuration install ########
  $config_server               = $rabbitmq::params::config_server,


  ######### PACKAGES ########
  $package_manage               = $rabbitmq::params::package_manage,
  $package_ensure               = $rabbitmq::params::package_ensure,
  $package_mq                   = $rabbitmq::params::package_mq,   
    
 
  ######### SERVICES ########
  $service_manage               = $rabbitmq::params::service_manage,
  $service_mq                   = $rabbitmq::params::service_mq,
  $service_ensure               = $rabbitmq::params::service_ensure,            
  $service_enable               = $rabbitmq::params::service_enable,   
  $service_hasstatus            = $rabbitmq::params::service_hasstatus,
  $service_hasrestart           = $rabbitmq::params::service_hasrestart,


  ###### CONFIG_FILES ######    
  $file_ensure                  = $rabbitmq::params::file_ensure,
  $file_group                   = $rabbitmq::params::file_group,        
  $file_mode                    = $rabbitmq::params::file_mode,        
  $file_owner                   = $rabbitmq::params::file_owner,        
  $file_backup                  = $rabbitmq::params::file_backup,      


  # -----------------------------------
  # CONFIGURATION MIDDLEWARE 
  # -----------------------------------
  #$middlle_libdir                 = $rabbitmq::params::middlle_libdir,



) inherits rabbitmq::params  

{

  validate_bool           ($package_manage)
  validate_string         ($package_ensure)
  validate_array          ($package_mq)

  validate_bool           ($service_manage)
  validate_string         ($service_mq)
  validate_string         ($service_ensure)
  validate_bool           ($service_enable)
  validate_bool           ($service_hasstatus)
  validate_bool           ($service_hasrestart)

  validate_string         ($file_name) 
  validate_string         ($file_path)    
  validate_string         ($file_ensure)      
  validate_string         ($file_backup)     
  validate_string         ($file_content)          



  anchor { 'rabbitmq::begin': } ->
    class { '::rabbitmq::install': } 
    class { '::rabbitmq::config': } 
    class { '::rabbitmq::service': } 
    class { '::rabbitmq::user': } 
  anchor { 'rabbitmq::end': }
 		  
}

