# Periscope: Unified Network Information Service (UNIS)

Periscope comprises a set of extensions to the standard PerfSONAR network monitoring schemas as well as a client monitoring component and topology and data stores. The information collected by Periscope components is maintained in a hierachically deployed set of UNIS and Measurement Store (MS) instances.  This container runs an instance of the UNIS server daemon.

Documentation of the UNIS API may be found [here](http://unis.open.sice.indiana.edu/docs/unis/).

## Configuration

The UNIS server looks for a configuration file at `/etc/periscope/unis.cfg`  A default configuration is included in the container but can be overridden by using a volume mount for `/etc/periscope`.  The service listens on port 8888.

```
[unis]
#url    = ; Our 'self' endpoint
#ms_url = ; Measurement Store endpoint
               
# root_urls is a comma-separated list of "parent" instances
root_urls = http://unis.open.sice.indiana.edu:8888
# a comma-separated list of community strings pushed to root instance
communities = OSIRIS,SLATE

#db_name    = unis_db                  ; Name of our database
#db_host    = 127.0.0.1                ; Database host (e.g., MongoDB)
#db_port    = 27017                    ; Database port

#summary_size              = 10
#summary_collection_period = 3600      ; Summary interval (seconds)

use_ms      = false                    ; Enable MS registration

[unis_ssl]
#enable     = false                    ; Enable SSL connections
#ssl_cert   =                          ; SSL certificate file
#ssl_key    =                          ; SSL key file
#ssl_cafile =                          ; SSL CA file

[auth]
#enabled    = false                    ; Use authentication on requests
```

## MongoDB notes

The UNIS service relies on MongoDB to provide a no-SQL object database.  The DB files can live within the container overlayfs but stopping or restarting the container without committing first risks losing any stored service data.  For persistent storage, it is recommended to mount a separate DB volume for this purpose.  MongoDB defaults to `/var/lib/mongodb` as its backing directory.

## Puppet Configuration using Docker module

Below is a snippet of Puppet code that can be used to instantiate the UNIS container on the host network with common options.

```
  $confdir = '/data/periscope'
  $dbdir   = '/data/mongodb'

	docker::run { 'unis':
          image            => 'miosiris/unis',
          net              => 'host',
          extra_parameters => [ '--name unis' ],
          volumes          => [ "${confdir}:${confdir}", "${dbdir}:${dbdir}" ],
          systemd_restart  => 'on-failure',
          hostname         => 'unis',
          privileged       => true,
          pull_on_start    => true
	}
```

## Docker Environment Variables

No environment variables effect the execution of the UNIS service. Use the configuration file to change settings.



