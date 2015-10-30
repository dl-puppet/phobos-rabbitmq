class rabbitmq::user inherits rabbitmq
{
  
  ## Create user
  group { 'rabbitmq':
    ensure => present,
  }

  user { 'rabbitmq':
    ensure   => present,
    gid      => 'rabbitmq',
    managehome => false,
  }

}