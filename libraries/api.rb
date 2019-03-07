#
# Chef Documentation
# https://docs.chef.io/libraries.html
#
require 'base64'
require 'json'
require 'net/http'
require 'uri'
#
# This module name was auto-generated from the cookbook name. This name is a
# single word that starts with a capital letter and then continues to use
# camel-casing throughout the remainder of the name.
#
module Artifactory
  module ApiHelpers

    def artifactory_rest(auth=true)
      require 'rest-client'
      RestClient.log = 'stdout' # for debug
      if (auth)
        RestClient::Resource.new(new_resource.api_server, new_resource.api_user, new_resource.api_password)
      else
        RestClient::Resource.new(new_resource.api_server)
      end
    end

    def artifactory_rest_post(path, payload = nil, headers = {})
      artifactory_rest[path].post payload.to_json, headers
    end

    def artifactory_rest_put(path, payload = nil, headers = {})
      artifactory_rest[path].put payload.to_json, headers
    end

    def artifactory_rest_get(path, headers = {}, auth=true)
      artifactory_rest(auth)[path].get headers
    end

    def artifactory_rest_delete(path, payload = nil)
      artifactory_rest[path].delete payload.to_json
    end

    def artifactory_api?
      artifactory_rest_get('system/ping',{:verify_ssl => false},false).include?('OK')
    rescue RestClient::ExceptionWithResponse
      false
    end
  end
end

#
# The module you have defined may be extended within the recipe to grant the
# recipe the helper methods you define.
#
# Within your recipe you would write:
#
#     extend Artifactory::ApiHelpers
#
#     my_helper_method
#
# You may also add this to a single resource within a recipe:
#
#     template '/etc/app.conf' do
#       extend Artifactory::ApiHelpers
#       variables specific_key: my_helper_method
#     end
#
