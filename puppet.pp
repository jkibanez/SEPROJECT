class project{
	package{ 'vim': #installing packages
		ensure => 'installed',
	}
	
	package{ 'curl':
		ensure => 'installed',
	}

	package{ 'git' :
		ensure => 'installed',
	}
#----------------------------------------------------------------------------

	user { 'monitor':	#creating user monitor inside /home/
		ensure => 'present',
		home => '/home/monitor',
		managehome => true,
		shell => '/bin/bash',
	}
#----------------------------------------------------------------------------

	file { '/home/monitor/scripts': #creating directory scripts
		ensure => 'directory',
	}
#----------------------------------------------------------------------------
	exec { 'wget':
		command => '/usr/bin/wget https://raw.githubusercontent.com/jkibanez/SEPROJECT/master/memory_check.sh -O memory_check', #downloading memorycheck.sh from github and renaming it to memory_check using wget
		path => '/home/monitor/scripts',#path for downloading
		cwd => '/home/monitor/scripts',#directory to execute exec
	}	
#-------------------------------------------------------------------------------------

	file { '/home/monitor/src/': #creating directory src
		ensure => 'directory',
	}
	
	file { '/home/monitor/src/my_memory_check':
		ensure => '/home/monitor/scripts/memory_check',
	}

	cron { '10mins':
		command => 'sh /home/monitor/src/my_memory_check -w 60 -c 90 -e jkibanez15@gmail.com',
		user => 'root',
		minute => '*/10',
	}
}

include pack
