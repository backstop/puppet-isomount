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
