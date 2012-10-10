# ==========================================================
# puppet-isomount v1.0
# http://backstop.github.com/puppet-isomount
# ==========================================================
# Copyright 2012 Backstop Solutions Group, LLC.
# Author: Nate Riffe (nriffe@backstopsolutions.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ==========================================================
class isomount (
	$path = '/var/cache/isomount',
) {

	file { [ $path, "${path}/.iso" ]:
		ensure => directory,
	}

	define iso (
		$url
	) {
		file {
			"${isomount::path}/${name}":
				ensure => directory;
		}	

		download { "${isomount::path}/.iso/${name}":
			url     => "${url}/${name}",
			timeout => 0,
			require => File["${isomount::path}/.iso"],
		}

		mount { "${isomount::path}/${name}":
			ensure  => mounted,
			device  => "${isomount::path}/.iso/${name}",
			fstype  => 'iso9660',
			options => 'ro',
			require => [ File["${isomount::path}/.iso/${name}"], File["${isomount::path}/${name}"] ],
		}
	}
}
