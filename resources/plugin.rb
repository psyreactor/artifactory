# To learn more about Custom Resources, see https://docs.chef.io/custom_resources.html
resource_name :artifactory_plugin

property :plugin_name, kind_of: String, name_attribute: true
property :repo, kind_of: String, required: false, default: 'https://raw.github.com/JFrogDev/artifactory-user-plugins'
property :api_user, kind_of: String, required: false, identity: true, default: 'admin'
property :api_password, kind_of: String, required: false, identity: true, default: 'password'
property :branch, kind_of: String, required: false, default: 'master'
property :folders, kind_of: String, required: true
property :reload, [true, false], default: true
property :api_server, kind_of: String, default: 'http://localhost:8081/artifactory/api'

action_class do
  include ::Artifactory::ApiHelpers

  def installed_plugin?
    resp = artifactory_rest_get('plugins')
    resul = JSON.parse(resp)
    if resul['executions'].nil?
      false
    else
      resul['executions'].any? { |hash| hash['name'].include?(new_resource.plugin_name) }
    end
  end

  def reload_plugin
    begin
      resp = artifactory_rest_post('plugins/reload', nil, {})
    rescue RestClient::ExceptionWithResponse => error
      return false if error.response
    end
    resp.include?(new_resource.plugin_name)
  end
end

action :create do
  remote_file "/etc/opt/jfrog/artifactory/plugins/#{new_resource.plugin_name}.groovy" do
    source "#{new_resource.repo}/#{new_resource.branch}/#{new_resource.folders}/#{new_resource.plugin_name}.groovy"
    owner node['artifactory']['user']
    group node['artifactory']['group']
    action :create_if_missing
    notifies :run, 'ruby_block[reload_plugin]', :immediately
    only_if installed_plugin?
  end

  ruby_block 'reload_plugin' do
    block do
      reload_plugin
    end
    action :nothing
  end
end
