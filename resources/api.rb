resource_name :artifactory_api_status

default_action :status

property :api_name, kind_of: String, name_attribute: true
property :api_user, kind_of: String, required: false, identity: true, default: 'admin'
property :api_password, kind_of: String, required: false, identity: true, default: 'password'
property :api_server, kind_of: String, default: 'http://localhost:8081/artifactory/api'
property :time, kind_of: Integer, default: 10
property :retry, kind_of: Integer, default: 10

action_class do
  include ::Artifactory::ApiHelpers
end

action :status do
  @retry = new_resource.retry
  until @retry < 0 || artifactory_api?
    Chef::Log.warn("Verificando la Api de Artifactory intento: #{10 - @retry} de 10")
    @retry -= 1
    sleep 5
  end
  raise 'Fallo el inicio la Api de Artifactory' if @retry < 0
  puts "\nInicio la Api de Artifactory correctamente" if @retry >= 0
end
