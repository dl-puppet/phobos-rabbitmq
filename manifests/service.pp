class rabbitmq::service inherits rabbitmq
{
    if $rabbitmq::service_manage == true { 

        Service { 
            ensure      => $rabbitmq::service_ensure,
            enable      => $rabbitmq::service_enable,
            hasstatus   => $rabbitmq::service_hasstatus,
            hasrestart  => $rabbitmq::service_hasrestart,
        }

		    	service { $rabbitmq::service_mq : 
		    		#require     => Package[""],
		    	}
	}

}