class rabbitmq::config inherits rabbitmq
{

   File {
    ensure          => $rabbitmq::file_ensure,
    group           => $rabbitmq::file_group,
    mode            => $rabbitmq::file_mode,
    owner           => $rabbitmq::file_owner,
    backup          => $rabbitmq::file_backup,
    #notify          => Service['rabbitmq'],
    #require         => Package['rabbitmq']
  }

  		######### CONFIG CLIENT MQ ########
		if $rabbitmq::config_server == true {

	        file {
	        	#définit les paramètres serveur: autorisations, limites, clusters, paramètres du plugin.
	            "/etc/rabbitmq/rabbitmq.config" :
	            content   =>  template("rabbitmq/rabbitmq.config.erb");

	            "/etc/rabbitmq/rabbitmqadmin.conf" :
	            content   =>  template("rabbitmq/rabbitmqadmin.conf.erb");

	            #définit les ports, emplacements des fichiers et les noms
	            "/etc/rabbitmq/rabbitmq-env.conf" :
	            content   =>  template("rabbitmq/rabbitmq-env.conf.erb");

	            "/etc/rabbitmq/enabled_plugins" :
	            content   =>  template("rabbitmq/enabled_plugins.erb"),
	        }  

	        exec { "rabbitmq-plugins enable rabbitmq_management" :  #http://localhost:15672/
	        	path 		=> ["/sbin/", "/bin"],
	        	subscribe   => File["/etc/rabbitmq/enabled_plugins"],
  				refreshonly => true
				#onlyif 	=> "test -e /etc/rabbitmq/enabled_plugins",
			}

		}
}