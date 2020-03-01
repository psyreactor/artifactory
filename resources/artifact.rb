resource_name :artifactory_artifact

default_action :create

property :name, kind_of: String, name_attribute: true
property :version, kind_of: String, required: true
property :url, kind_of: String, required: true
property :phase, kind_of: String, required: true, default: nil
property :context, kind_of: String, required: true
property :extencion, kind_of: String, required: true
property :protocol, kind_of: String, required: true, default: 'https'
property :path, kind_of: String, required: true default: "#{Chef::Config[:file_cache_path]}/#{new_resource.name}"
property :user, kind_of: String, required: false, identity: true, default: 'admin'
property :password, kind_of: String, required: false, identity: true, default: 'password'
property :overwrite, kind_of: [TrueClass, FalseClass], default: false


action_class do
  def filename
    file = "#{new_resource.name}-#{new_resource.version}.#{new_resource.extencion}"
  end

  def download_url
    auth = "#{new_resource.user}:#{new_resource.password}"  
    download_url = "#{new_resource.protocol}://#{auth}@#{new_resource.url}/#{new_resource.phase}/#{new_resource.context}/#{filename}"
  end

  def file_exist?
    if File.file?("#{new_resource.path}.#{filename}") 
      true
    else
      false
    end
  end

end

action :create do
  file "#{new_resource.path}.#{filnamee}" do
    action :delete
    only_if { file_exist? && overwrite }
  end
  
  directory new_resource.path do
    recursive true
    action :create
  end

  remote_file "#{new_resource.path}.#{filnamee}" do
    source download_url
    sensitive true
    not_if { file_exist? && !overwrite }
  end
end
