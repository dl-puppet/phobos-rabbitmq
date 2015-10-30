# phobos-rabbitmq




# Installation Rabbitmq:

Le module phobos-rabbitmq installera les packages suivants: 

-http://www.rabbitmq.com/releases/erlang/erlang-18.1-1.el6.x86_64.rpm
-http://www.rabbitmq.com/releases/rabbitmq-server/v3.5.0/rabbitmq-server-3.5.0-1.noarch.rpm




# Test de l'installation :

Après le démarrage du service, vérifiez que le broker est à l'écoute sur le port TCP 61613:

<blockquote>
netstat -an | grep 61613
</blockquote>

Si vous ne voyez pas un socket d'écoute disponibles pour les connexions entrantes, consultez le fichier journal 

<blockquote>
tail -f /var/log/xxxx/xxx.log
</blockquote>




# Le Firewall

Vous devez vous assurer que les sessions TCP entrants vers le port 61613 peuvent être créés à partir de chaque serveur et le client mcollective.

<blockquote>
iptables --list --line-numbers

iptables -I INPUT 20 -m state --state NEW -p tcp --source 192.168.0.0/24 --dport 61613 -j ACCEPTE
service iptables save

ip6tables -I INPUT 20 -m state --state NEW -p tcp --source 2001:DB8:6A:C0::/24 --dport 61613 -j ACCEPT
service ip6tables save
</blockquote>



# Les Ports 

<blockquote>
4369 (epmd), 25672 (Erlang distribution)
5672, 5671 (AMQP 0-9-1 without and with TLS)
15672 (if management plugin is enabled)
61613, 61614 (if STOMP is enabled)
1883, 8883 (if MQTT is enabled)
</blockquote>




# Default User

<blockquote>
login: 	guest
pwd: 	guest
</blockquote>




# Les Logs

<blockquote>
tail -f /var/log/rabbitmq/xxxxxxxxx.{log/-sasl.log}

configure logrotate:
/etc/logrotate.d/rabbitmq-serve
</blockquote>




# Les Optimisations

RabbitMQ peut avoir besoin de paramétrer les limites système (tuning noyau) afin de gérer un nombre décent de connexions simultanées et les files d'attente:

-le nombre maximal de fichiers ouverts que le noyau permet (fs.file-max), Peut être augmentée via /etc/security/limits.conf. Cela nécessite également l'activation du module de pam_limits.so et re-connexion ou un redémarrage.

-la limite par utilisateur (ulimit -n) (recommandé 65536 / 4096 devrait être suffisant): La façon la plus simple pour régler la limite par utilisateur pour RabbitMQ est d'éditer le rabbitmq-env.conf (ulimit -S -n 4096)

				*Le premier doit être plus élevé que ce dernier.


RabbitMQ est livré avec les paramètres par défaut intégrés qui sera très probablement être suffisante pour faire fonctionner votre serveur RabbitMQ efficacement. S'il fonctionne bien, alors vous n'avez besoin d'aucune configuration.

Si vous avez d'autres contraintes, RabbitMQ fournit trois façons générales pour personnaliser le serveur:


-variables d'environnement ( /etc/rabbitmq/rabbitmq-env.conf) :
Définit les ports, emplacements de fichiers et les noms sur les systèmes Unix. Vous pouvez créer/modifier rabbitmq-env.conf afin de définir des variables d'environnement. Utilisez les noms de variables d'environnement standard (mais laisser tomber le préfixe de RABBITMQ_):  
-http://www.rabbitmq.com/man/rabbitmq-env.conf.5.man.html 
-http://www.rabbitmq.com/configure.html

Un fichier de configuration ( /etc/rabbitmq/rabbitmq.config ) : 
Définit les paramètres du composant de serveur pour les autorisations, les limites et les clusters, ainsi que les paramètres du plugin.




# Fichier rabbitmq.config

<blockquote>
% Template Path: rabbitmq/templates/rabbitmq.config
[

        {rabbit, [
                {default_user, <<"guest">>},
                {default_pass, <<"guest">>}
        ]},


        {kernel, [
        ]},

        {rabbitmq_management, [
                {listener, [
                        {port, 15672}
                 ]}
        ]},


        {rabbitmq_stomp, [
                {tcp_listeners, [
                        {"10.26.112.230",       61613}
                ]}
        ]}
].
</blockquote>




# Ajouter un User

<blockquote>
rabbitmqctl add_user stge stgepwd
rabbitmqctl set_user_tags stge administrator
rabbitmqctl set_permissions -p / stge ".*" ".*" ".*"
</blockquote>




# Installation du plugin console web

<blockquote>
rabbitmq-plugins enable rabbitmq_management 
http://hostnmae:15672/
</blockquote>


vous devez activer le plugin Stomp et l'outil de gestion CLI (rabbitadmin) :###

#telecharger rabbitadmin (chmod u+x)
cd /usr/bin/
wget http://server-name:15672/cli/ 



#voir l'aide:
rabbitmqadmin --help 



#activer la completion:
rabbitmqadmin --bash-completion > /etc/bash_completion.d/rabbitmqadmin






Get a list of exchanges: 
	rabbitmqadmin -V test list exchanges
Get a list of queues, with some columns specified: 
	rabbitmqadmin list queues vhost name node messages message_stats.publish_details.rate
Get a list of queues, with all the detail we can take: rabbitmqadmin -f long -d 3 list queues
Connect to another host as another user: rabbitmqadmin -H myserver -u simon -p simon list vhosts
Declare an exchange: rabbitmqadmin declare exchange name=my-new-exchange type=fanout
Declare a queue, with optional parameters: rabbitmqadmin declare queue name=my-new-queue durable=false
Publish a message : rabbitmqadmin publish exchange=amq.default routing_key=test payload="hello, world"
And get it back: rabbitmqadmin get queue=test requeue=false
Export configuration : rabbitmqadmin export rabbit.config
Import configuration, quietly: rabbitmqadmin -q import rabbit.config
Close all connections: rabbitmqadmin -f tsv -q list connections name | while read conn ; do rabbitmqadmin -q close connection name=${conn} ; done
##############################################################

##############################################################
#Le STOMP plug-in ajoute le support pour le protocole STOMP à RabbitMQ 
#L'adaptateur STOMP est incluse dans la distribution de RabbitMQ.(rabbitmq_stomp.ez et amqp_client.ez.)

rabbitmq-plugins enable rabbitmq_stomp

Lorsque aucune configuration ne est spécifié l'adaptateur "STOMP écoutera sur toutes les interfaces sur le port 61613" et avoir un utilisateur par défaut : guest/guest.
Sinon, modifier votre fichier de configuration rabbitmq.config:

[
  {rabbitmq_stomp, [{tcp_listeners, [12345]}]}
].

ou:

[
  {rabbitmq_stomp, [{tcp_listeners, [{"127.0.0.1", 61613},
                                     {"::1",       61613}]}]}
].



Pour utiliser SSL pour les connexions STOMP, SSL doit être configuré dans le broker (voir: http://www.rabbitmq.com/ssl.html) . Pour activer les connexions SSL STOMP, ajouter une configuration d'écoute à la variable "ssl_listeners" pour l'application de rabbitmq_stomp.

This configuration creates a standard TCP listener on port 61613 and an SSL listener on port 61614:

[{rabbit,          [
                    {ssl_options, [{cacertfile, "/path/to/tls/ca/cacert.pem"},
                                   {certfile,   "/path/to/tls/server/cert.pem"},
                                   {keyfile,    "/path/to/tls/server/key.pem"},
                                   {verify,     verify_peer},
                                   {fail_if_no_peer_cert, true}]}
                   ]},
  {rabbitmq_stomp, [{tcp_listeners, [61613]},
                    {ssl_listeners, [61614]}]}
].



Utilisateur stomp par défaut:
The RabbitMQ STOMP adapter allows CONNECT frames to omit the login and passcode headers if a default is configured.To configure a default login and passcode, add a default_user section to the rabbitmq_stomp application configuration.

[
  {rabbitmq_stomp, [{default_user, [{login, "guest"},
                                    {passcode, "guest"}]}]}
].



Authentification avec des certificats client SSL:
L'adaptateur de STOMP peut authentifier Les connexions SSL en extrayant un nom dans le certificat SSL du client, sans utiliser un mot de passe.Par mesure de sécurité, le serveur doit être configuré avec les options fail_if_no_peer_cert set to true and verify set to verify_peer, pour forcer tous les clients SSL d'avoir un certificat client vérifiable.
Pour activer cette fonction, réglez ssl_cert_login à vrai pour l'application de rabbitmq_stomp.

[
  {rabbitmq_stomp, [{ssl_cert_login, true}]}
].


By default this will set the username to an RFC4514-ish string form of the certificate's subject's Distinguished Name, similar to that produced by OpenSSL's "-nameopt RFC2253" option.

To use the Common Name instead, add:

{rabbit, [{ssl_cert_login_from, common_name}]}


Implicite Connect
Si vous configurez un utilisateur par défaut ou utilisez SSL l'authentification par certificat client, vous pouvez également choisir de permettre aux clients d'omettre le cadre CONNECTER entièrement. Dans ce mode, si la première trame envoyé sur une session ne est pas un CONNECT, le client est automatiquement connecté en tant qu'utilisateur par défaut ou l'utilisateur fourni dans le certificat SSL.

Pour activer la connexion implicite, réglez implicit_connect true pour l'application de rabbit_stomp.

[
  {rabbitmq_stomp, [{default_user,     [{login, "guest"},
                                        {passcode, "guest"}]},
                    {implicit_connect, true}]}
].


Testing the Adapter
Si l'adaptateur de STOMP par défaut est en cours d'exécution, vous devriez être en mesure de se connecter à 61613 de port en utilisant un client STOMP de votre choix. Dans un pincement, telnet ou netcat (nc) fera l'affaire. 


Destinations:
L'adaptateur RabbitMQ STOMP prend en charge un certain nombre de types de destinations différentes:
/exchange -- SEND to arbitrary routing keys and SUBSCRIBE to arbitrary binding patterns;
/queue -- SEND and SUBSCRIBE to queues managed by the STOMP gateway;
/amq/queue -- SEND and SUBSCRIBE to queues created outside the STOMP gateway;
/topic -- SEND and SUBSCRIBE to transient and durable topics;
/temp-queue/ -- create temporary queues (in reply-to headers only).

