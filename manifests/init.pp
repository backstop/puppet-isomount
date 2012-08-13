class isomount (
	$path = '/var/cache/isomount',
) {

	file { [ $path, "${path}/.iso" ]:
		ensure => directory,
	}

	define iso (
		$url
	) {
		exec { "wget ${url} -qO ${isomount::path}/.iso/${name}":
			path    => [ '/bin', '/usr/bin' ],
			creates => "${isomount::path}/.iso/${name}",
		}

		file {
			"${isomount::path}/.iso/${name}":
				ensure => exists;
			"${isomount::path}/${name}":
				ensure => directory;
		}	

		mount { "${isomount::path}/${name}":
			ensure  => mounted,
			device  => "${isomount::path}/.iso/${name}",
			fstype  => 'iso9660',
			require => [ File["${isomount::path}/.iso/${name}"], File["${isomount::path}/${name}"] ],
		}
	}
}
