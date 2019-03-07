# cookbook attributes
default['artifactory']['home'] = '/opt/jfrog/artifactory'
default['artifactory']['user'] = 'artifactory'
default['artifactory']['group'] = 'artifactory'
default['artifactory']['service_name'] = 'artifactory'
default['artifactory']['package_version'] = '6.6.0'
default['artifactory']['package_name'] = 'jfrog-artifactory-pro'
default['artifactory']['package_url'] = "https://bintray.com/jfrog/artifactory-pro-rpms/download_file?file_path=org%2Fartifactory%2Fpro%2Frpm%2Fjfrog-artifactory-pro%2F#{node['artifactory']['package_version']}%2Fjfrog-artifactory-pro-#{node['artifactory']['package_version']}.rpm"
default['artifactory']['java_install'] = true
default['artifactory']['java_version'] = '8'
default['artifactory']['port'] = '8081'
default['artifactory']['shutdown_port'] = 8015
default['artifactory']['admin']['user'] = 'admin'
default['artifactory']['admin']['password'] = 'Password.01'

# paths ***Not modify***
default['artifactory']['config_path'] = '/etc/opt/jfrog/artifactory'

# activation
default['artifactory']['activate'] = false
default['artifactory']['activation_key'] = 'eyJhcnRpZmFjdG9yeSI6eyJpZCI6IiIsIm93bmVyIjoicjRwMyIsInZhbGlkRnJvbSI6MTU0ODA3NjI0MDc5NiwiZXhwaXJlcyI6MTU3OTYwMTQ0MDc5NSwidHlwZSI6IkVOVEVSUFJJU0VfUExVUyIsInRyaWFsIjpmYWxzZSwicHJvcGVydGllcyI6e319fQ=='

# database Config
default['artifactory']['db']['type'] = 'mssql' # mysql, postgresql,sqlserver
case default['artifactory']['db']['type']
when 'mysql'
  default['artifactory']['db_jar_file'] = 'mysql-connector-java-6.0.6.jar'
  default['artifactory']['jdbc_driver_url'] = 'http://central.maven.org/maven2/mysql/mysql-connector-java/6.0.6/mysql-connector-java-6.0.6.jar'
when 'postgresql'
  default['artifactory']['db_jar_file'] = 'postgresql-9.3-1102.jdbc41.jar'
  default['artifactory']['jdbc_driver_url'] = 'http://central.maven.org/maven2/org/postgresql/postgresql/42.2.2/postgresql-42.2.2.jar'
when 'mssql'
  default['artifactory']['db_jar_file'] = 'sqljdbc4-4.0.jar'
  default['artifactory']['jdbc_driver_url'] = 'http://clojars.org/repo/com/microsoft/sqlserver/sqljdbc4/4.0/sqljdbc4-4.0.jar'
end
default['artifactory']['jdbc_driver_path'] = "#{node['artifactory']['home']}/tomcat/lib"

default['artifactory']['db']['host'] = '127.0.1.0'
default['artifactory']['db']['port'] = '1433'
default['artifactory']['db']['user'] = 'artifactory'
default['artifactory']['db']['name'] = 'artifactory'
default['artifactory']['db']['password'] = 'password'

# ldapSettingsConfig
default['artifactory']['ldap']['key'] = 'ldap_server'
default['artifactory']['ldap']['enable'] = false
default['artifactory']['ldap']['ldapUrl'] = 'ldap://server'
default['artifactory']['ldap']['userDnPattern'] = 'user@domain.com'
default['artifactory']['ldap']['searchFilter'] = nil
default['artifactory']['ldap']['searchSubTree'] = false
default['artifactory']['ldap']['managerDn'] = nil
default['artifactory']['ldap']['managerPassword'] = nil
default['artifactory']['ldap']['autoCreateUser'] = false
default['artifactory']['ldap']['emailAttribute'] = 'email'

# Artifactory properties file
default['artifactory']['properties'] = { 'artifactory.repo.global.disabled' => true,
                                         'artifactory.ping.allowUnauthenticated' => true,
                                         'derby.storage.pageCacheSize' => 500,
                                         'derby.module.mgmt.jmx' => 'org.apache.derby.impl.services.jmxnone.NoManagementService',
                                         'derby.stream.error.logSeverityLevel' => 0,
                                         'derby.language.logStatementText' => false,
                                        }
