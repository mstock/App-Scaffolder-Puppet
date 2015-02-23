package App::Scaffolder::Puppet;

# ABSTRACT: App::Scaffolder extension to scaffold Puppet modules

use strict;
use warnings;

=head1 DESCRIPTION

App::Scaffolder::Puppet provides commands to scaffold Puppet modules and classes.
See L<App::Scaffolder::Command::puppetmodule|App::Scaffolder::Command::puppetmodule>
and L<App::Scaffolder::Command::puppetclass|App::Scaffolder::Command::puppetclass>
for the actual commands.

L<App::Scaffolder::Puppet::Command|App::Scaffolder::Puppet::Command> is a base
class for the above commands, and is itself based on
L<App::Scaffolder::Command|App::Scaffolder::Command>.

=head1 SEE ALSO

=over

=item *

L<App::Scaffolder|App::Scaffolder>

=item *

L<App::Scaffolder::Puppet::Command|App::Scaffolder::Puppet::Command>

=item *

L<https://puppetlabs.com/puppet/puppet-open-source> - Puppet

=back

=cut

1;

