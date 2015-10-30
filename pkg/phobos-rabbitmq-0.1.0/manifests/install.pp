class rabbitmq::install inherits rabbitmq
{
	if $rabbitmq::package_manage == true { 

		#file { "/tmp/rabbitmq" :
		#	ensure 		=> directory,
		#	source 		=> ["puppet:///modules/rabbitmq/rpm"],
		#	mode    	=> '0640',
		#	recurse 	=> true,
		#	ignore 		=> '.git',
		#	backup 		=> false,
		#}

  			Package {       
	    		ensure          => $rabbitmq::package_ensure,
				#provider 		=> 'rpm',
				#install_options => ['--prefix=/opt/nmap'],
				#before 		=> File['nmap']        
    		}

				package { $rabbitmq::package_mq :

					#"erlang-18.1-1.el6.x86_64.rpm" :
			    	#source 		=> "/tmp/rabbitmq/erlang-18.1-1.el6.x86_64.rpm";

			    	#"rabbitmq-server-3.5.6-1.noarch.rpm" :
			    	#source 		=> "/tmp/rabbitmq/rabbitmq-server-3.5.6-1.noarch.rpm",
			    	#require 	=> Exec["rpm --import /tmp/rabbitmq/rabbitmq-signing-key-public.asc"];
				}
	} 
}