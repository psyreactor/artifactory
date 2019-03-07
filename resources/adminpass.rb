resource_name :artifactory_adminpass

default_action :update

property :name, kind_of: String, name_attribute: true
property :password, kind_of: String, required: true
property :api_user, kind_of: String, required: false, identity: true, default: 'admin'
property :api_password, kind_of: String, required: false, identity: true, default: 'password'
property :api_server, kind_of: String, default: 'http://localhost:8081/artifactory/api'

action_class do
  include ::Artifactory::ApiHelpers

  def change_pass?
    begin
     resp = RestClient::Resource.new(new_resource.api_server,'admin',new_resource.password)['/api/security/users/admin'].get
     if resp.body.nil?
       true
     else
       ! resp.body.include?('admin')
     end
    rescue RestClient::ExceptionWithResponse => e
     true
    end
  end

  def pass_payload
    as_hash = {}
    as_hash['userName'] = 'admin'
    as_hash['oldPassword'] = 'password'
    as_hash['newPassword1'] = new_resource.password.to_s
    as_hash['newPassword2'] = new_resource.password.to_s
    as_hash
  end
end
action :update do
  if change_pass?
    resp = artifactory_rest_post('/api/security/users/authorization/changePassword',  pass_payload.to_json, 'Content-Type' => 'application/json')
    if resp.code == 200
      true
    else
      false
    end
  end
end
