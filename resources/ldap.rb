# To learn more about Custom Resources, see https://docs.chef.io/custom_resources.html
resource_name :artifactory_ldap

default_action :add

property :config_name, kind_of: String, name_attribute: true
property :config, kind_of: Hash, required: true
property :api_user, kind_of: String, required: false, identity: true, default: 'admin'
property :api_password, kind_of: String, required: false, identity: true, default: 'password'
property :api_server, kind_of: String, default: 'http://localhost:8081/artifactory/api'

action_class do
  include ::Artifactory::ApiHelpers

  def ldap_config?
    resp = artifactory_rest_get('plugins/execute/getLdapSettingsList')
    if resp.body.nil?
      false
    else
      resp.body.include?(new_resource.config_name)
    end
  end

  def ldap_config
    resp = artifactory_rest_get('plugins/execute/getLdapSettings', 'params' => { 'key' => new_resource.config_name })
    resp.body
  end

  def compare_ldap_config
    current = JSON.parse(ldap_config).with_indifferent_access
    if current == new_resource.config
      true
    else
      false
    end
  end
end

action :add do
  if ldap_config?
    action_update
  else
    resp = artifactory_rest_post('plugins/execute/addLdapSetting', new_resource.config, 'Content-Type' => 'application/json')
    if resp.code == 200
      true
    else
      false
    end
  end
end

action :delete do
  if ldap_config?
    resp = artifactory_rest_delete('plugins/execute/deleteLdapSetting', 'params' => { 'key' => new_resource.config_name })
    if resp.code == 200
      true
    else
      false
    end
  end
end

action :update do
  if ldap_config? && compare_ldap_config
    resp = artifactory_rest_post('plugins/execute/updateLdapSetting', new_resource.config, 'Content-Type' => 'application/json')
    if resp.code == 200
      true
    else
      false
    end
  end
end
