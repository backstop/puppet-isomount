class isomount (
	$path = '/var/cache/isomount',
) {

	file { [ $path, "${path}/.iso" ]:
		ensure => directory,
	}

	define iso (
		$url
	) {
		exec { "wget ${url} -qO /var/lib/isomount/.iso/${name}":
			path    => [ '/bin', '/usr/bin' ],
			creates => "/var/lib/isomount/.iso/${name}",
		}

		file {
			"/var/lib/isomount/.iso/${name}":
				ensure => exists;
			"/var/lib/isomount/${name}":
				ensure => directory;
		}	

		mount { "/var/lib/isomount/${name}":
			ensure  => mounted,
			device  => "/var/lib/isomount/.iso/${name}",
			fstype  => 'iso9660',
			require => [ File["/var/lib/isomount/.iso/${name}"], File["/var/lib/isomount/${name}"] ],
		}
	}
}
