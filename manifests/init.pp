class isomount (
	$path = '/var/cache/isomount',
) {

	file { [ $path, "${path}/.iso" ]:
		ensure => directory,
	}

	define iso (
		$url
	) {
		exec { "wget ${url}/${name} -qO ${isomount::path}/.iso/${name}":
			path    => [ '/bin', '/usr/bin' ],
			creates => "${isomount::path}/.iso/${name}",
			require => File["${isomount::path}/.iso"],
			timeout => 0,
		}

		file {
			"${isomount::path}/.iso/${name}":
				ensure => present;
			"${isomount::path}/${name}":
				ensure => directory;
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
