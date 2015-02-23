package App::Scaffolder::Command::puppetmodule;
use parent qw(App::Scaffolder::Puppet::Command);

# ABSTRACT: Scaffold a Puppet module

use strict;
use warnings;

=head1 SYNOPSIS

	# Create scaffold to install the 'vim' package:
	$ scaffolder puppetmodule --template package --name vim

	# Create scaffold to install the 'vim-puppet' package in module created with above command:
	$ scaffolder puppetmodule --template subpackage --name vim::puppet --package vim-puppet

	# Create scaffold to install the 'apache2' package and setup the corresponding service:
	$ scaffolder puppetmodule --template service --name apache2

	# Create scaffold to install the 'apache2-doc' package in module created with above command:
	$ scaffolder puppetmodule --template subpackage --name apache2::doc --package apache2-doc

=head1 DESCRIPTION

App::Scaffolder::Command::puppetmodule scaffolds Puppet modules. By default, it
provides the following templates:

=over

=item *

C<package>: Create Puppet module to install a package.

=item *

C<service>: Create Puppet module to setup a service.

=item *

C<subpackage>: Create class to install a 'sub package'. This is intended to be
used after using C<package> or C<service> to add an additional package to the
module (eg. C<apache2-doc> to the C<apache2> service). This must be used inside
the module directory created before, and you will have to add a variable with
the actual package name to the existing C<manifests/params.pp> file. The name of
the variable can be seen in the newly created files below C<manifests>.

=back

=head1 SEE ALSO

=over

=item *

L<https://docs.puppetlabs.com/puppet/latest/reference/modules_fundamentals.html> - Module Fundamentals

=back

=cut

1;

