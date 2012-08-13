class isomount (
	$path = '/var/cache/isomount',
)

	file { [ $path, "${path}/.iso" ]:
		ensure => directory,
	}

	define isomount (
		$url
	) {
		$filename = basename($url)

		exec { "wget ${url} -qO /var/lib/isomount/.iso/${filename}":
			path    => [ '/bin', '/usr/bin' ],
			creates => "/var/lib/isomount/.iso/${filename}",
		}

		file {
			"/var/lib/isomount/.iso/${filename}":
				ensure => exists,
			"/var/lib/isomount/${filename}":
				ensure => directory,
		}	

		mount { "/var/lib/isomount/${filename}":
			ensure  => mounted,
			device  => "/var/lib/isomount/.iso/${filename}",
			fstype  => 'iso9660',
			require => [ File["/var/lib/isomount/.iso/${filename}"], File["/var/lib/isomount/${filename}"] ],
		}
	}
}
