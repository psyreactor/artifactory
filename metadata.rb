name 'artifactory'
maintainer 'Lucas Mariani'
maintainer_email 'marianilucas@gmail.com'
license 'Apache-2.0'
description 'Installs/Configures artifactory'
long_description 'Installs/Configures artifactory'
version '0.2.0'
chef_version '>= 12.1' if respond_to?(:chef_version)
supports 'centos'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
issues_url 'https://github.com/psyreactor/artifactory/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
source_url 'https://github.com/psyreactor/artifactory'

depends 'java'
depends 'build-essential'
