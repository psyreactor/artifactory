# artifactory Cookbook

This cookbook install artifactory from binary source.

####[Artifactory](https://jfrog.com/artifactory)
JFrog is revolutionizing the software world with the practice of Continuous Update, with a speed and continuity that forever changes the way organizations manage and release software.

Requirements
------------
#### Cookbooks:

- java
- build-essential

The following platforms and versions are tested and supported using Opscode's test-kitchen.

- CentOS/RedHat 7.2

The following platform families are supported in the code, and are assumed to work based on the successful testing on CentOS.

- Fedora
- Amazon Linux

Recipes
-------
### artifactory::default
> Call to Artifactory::install

#### artifactory::Install
> Install Artifactory

| Attribute | Description | Default Value |
|-----------|-------------|---------------|
|node['artifactory']['home'] | Home path install| '/opt/jfrog/artifactory' |
|node['artifactory']['user'] | OS user| 'artifactory' |
|node['artifactory']['group'] | OD group| 'artifactory' |
|node['artifactory']['service_name'] | Systemd Sevice Name | 'artifactory' |
|node['artifactory']['package_version'] |Versio to install| '6.6.0' |
|node['artifactory']['package_name'] | Package Name| 'jfrog-artifactory-pro' |
|node['artifactory']['package_url'] | Package Url| "https://bintray.com/jfrog/artifactory-pro-rpms/download_file?file_path=org%2Fartifactory%2Fpro%2Frpm%2Fjfrog-artifactory-pro%2F#{node['artifactory']['package_version']}%2Fjfrog-artifactory-pro-#{node['artifactory']['package_version']}.rpm" |
|node['artifactory']['java_install'] | Java Install| true |
|node['artifactory']['java_version'] | Java Verison| '8' |
|node['artifactory']['port'] | Tomacat Port | '8081' |
|node['artifactory']['shutdown_port'] | Tomcat shutdown Port | 8015 |
|node['artifactory']['admin']['user'] | UI user | 'admin' |
|node['artifactory']['admin']['password'] | UI Password | 'Password.01' |
|node['artifactory']['config_path'] | Config files Path | '/etc/opt/jfrog/artifactory' |
|node['artifactory']['activate'] | Create License File | false |
|node['artifactory']['activation_key'] | Activation key | 'eyJhcnRpZmFjdG9yeSI6eyJpZCI6IiIsIm93bmVyIjoicjRwMyIsInZhbGlkRnJvbSI6MTU0ODA3NjI0MDc5NiwiZXhwaXJlcyI6MTU3OTYwMTQ0MDc5NSwidHlwZSI6IkVOVEVSUFJJU0VfUExVUyIsInRyaWFsIjpmYWxzZSwicHJvcGVydGllcyI6e319fQ==' |
|node['artifactory']['db']['type'] | Database Type (mysql,postgresql,sqlserver)  for local db set derby |  'mssql' |
|node['artifactory']['db']['host'] | Database Host | 'mssqlserver.domain.local' |
|node['artifactory']['db']['port'] | Database Port | '1433' |
|node['artifactory']['db']['user'] | Database User | 'artifactory' |
|node['artifactory']['db']['name'] | Database Name | 'artifactory' |
|node['artifactory']['db']['password'] | Database Password | 'secret-pass' |

#### artifactory::db
> Install driver and config DB in artifactory for (sqlserver, postgresql,mysql) Not use for derby

#### artifactory::activate
> Create license file to activate artifactory pro

#### artifactory ldap
> Configure ldap throughout artifactory api

| Attribute | Description | Default Value |
|-----------|-------------|---------------|
| node['artifactory']['ldap']['key'] | Ldap Config Name | 'ldap_server' |
| node['artifactory']['ldap']['enable'] | Enable Ldap | false |
| node['artifactory']['ldap']['ldapUrl'] | Ldap Url | 'ldap://server' |
| node['artifactory']['ldap']['userDnPattern'] | Ldap DN Pattern | 'user@domain.com' |
| node['artifactory']['ldap']['searchFilter'] | Ldap Search Filter | nil |
| node['artifactory']['ldap']['searchSubTree'] | Ldap Search subtree | false |
| node['artifactory']['ldap']['managerDn'] | Ldap Binding User | nil |
| node['artifactory']['ldap']['managerPassword'] | Ldap Binding user Password | nil |
| node['artifactory']['ldap']['autoCreateUser'] | Create user in Actifactory | false |
| node['artifactory']['ldap']['emailAttribute'] | Ldap User email attribute | 'email' |

## Usage

Include `artifactory` in your node's `run_list`:

```json
"default_attributes": {
  "artifactory": {
    "username": "admin",
    "password": "password",
    "vesion": "6.6.0",
    }
  }
```

License and Authors
-------------------
Authors:
Lucas Mariani (Psyreactor)
- [marianiluca@gmail.com](mailto:marianiluca@gmail.com)
- [https://github.com/psyreactor](https://github.com/psyreactor
