resource_name :artifactory_users

default_action :create

property :name, kind_of: String, name_attribute: true
property :email, kind_of: String, required: true
property :password, kind_of: String, required: true
property :admin, kind_of: [TrueClass, FalseClass], default: false
property :disableUIAccess, kind_of: [TrueClass, FalseClass], default: false
property :internalPasswordDisabled, kind_of: [TrueClass, FalseClass], default: false
property :profileUpdatable, kind_of: [TrueClass, FalseClass], defaul: true
property :realm, kind_of: String, default: 'internal'
property :groups, kind_of: Array
property :api_user, kind_of: String, required: false, identity: true, default: 'admin'
property :api_password, kind_of: String, required: false, identity: true, default: 'password'
property :api_server, kind_of: String, default: 'http://localhost:8081/artifactory/api'

action_class do
  include ::Artifactory::ApiHelpers

  def user_exist?
    resp = artifactory_rest_get("/api/security/users/#{new_resource.name}")
    if resp.body.nil?
      false
    else
      resp.body.include?(new_resource.name)
    end
  end

  def user_payload
    as_hash = {}
    as_hash['name']   = new_resource.name.to_s
    as_hash['email']   = new_resource.email.to_s
    as_hash['password']     = new_resource.password.to_s
    as_hash['admin']  = new_resource.admin if new_resource.admin
    as_hash['profileUpdatable'] = new_resource.profileUpdatable if new_resource.profileUpdatable
    as_hash['disableUIAccess'] = new_resource.disableUIAccess if new_resource.disableUIAccess
    as_hash['internalPasswordDisabled']  = new_resource.internalPasswordDisabled if new_resource.internalPasswordDisabled
    as_hash['realm'] = new_resource.realm if new_resource.realm
    as_hash['groups'] = new_resource.groups if new_resource.groups
    as_hash
  end

  def user_config
    resp = artifactory_rest_get("/api/security/users/#{new_resource.name}")
    resp.body
  end

  def compare_user
    current = JSON.parse(user_config).with_indifferent_access
    user_payload.each_pair do | key, value |
      if ( ! current['key'] = value )
          true
      end
    end
  end
end

action :add do
  if user_exist?
    action_update
  else
    resp = artifactory_rest_put("/api/security/users/#{new_resource.name}", user_payload.to_json, 'Content-Type' => 'application/json')
    if resp.code == 200
      true
    else
      false
    end
  end
end

action :delete do
  if user_exist?
    resp = artifactory_rest_delete("/api/security/users/#{new_resource.name}")
    if resp.code == 200
      true
    else
      false
    end
  end
end

action :update do
  if user_exist? && compare_user
    resp = artifactory_rest_post("/api/security/users/#{new_resource.name}",  user_payload.to_json, 'Content-Type' => 'application/json')
    if resp.code == 200
      true
    else
      false
    end
  end
end
