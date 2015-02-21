package App::Scaffolder::Command::puppetmodule;
use parent qw(App::Scaffolder::Command);

# ABSTRACT: Scaffold a Puppet module

use strict;
use warnings;

use File::Spec::Functions qw(catfile);
use MRO::Compat;
use Path::Class::Dir;

=head1 SYNOPSIS

	# Create scaffold to install the 'vim' package:
	$ scaffolder puppetmodule --template package --name vim

	# Create scaffold to install the 'apache2' package and setup the corresponding service:
	$ scaffolder puppetmodule --template service --name apache2

=head1 DESCRIPTION

App::Scaffolder::Command::puppetmodule scaffolds Puppet modules. By default, it
provides two simple templates:

=over

=item *

C<package>: Create Puppet module to install a package.

=item *

C<service>: Create Puppet module to setup a service.

=back

In addition to the default template search path (see
L<App::Scaffolder|App::Scaffolder> for details), this command will also look for
templates in C</etc/puppet/scaffolder_templates> or
C</usr/local/etc/puppet/scaffolder_templates> if they exist.

=head1 METHODS

=cut

=head2 get_target

Specialized C<get_target> version which uses the name (if it does not contain
C<::>, otherwise, it will be the current working directory) if no target was
given.

=cut

sub get_target {
	my ($self, $opt) = @_;
	my $target = $opt->target() || (
		$opt->name() =~ m{::}x
			? '.'
			: $opt->name()
	);
	return Path::Class::Dir->new($target);
}


=head2 get_variables

Specialized C<get_variables> version which returns the name of the module and
other useful variables.

=cut

sub get_variables {
	my ($self, $opt) = @_;

	my @name_parts = split(/::/x, $opt->name());
	my (undef, @subname_parts) = @name_parts;
	my $package = $opt->package() || $opt->name();
	return {
		name               => scalar $opt->name(),
		nameparts          => \@name_parts,
		namepartsjoined    => join('_', @name_parts),
		namepartspath      => catfile(@name_parts),
		subnameparts       => \@subname_parts,
		subnamepartsjoined => join('_', @subname_parts),
		subnamepartspath   => catfile(@subname_parts),
		package            => $package,
	};
}


=head2 get_dist_name

Return the name of the dist this command is in.

=cut

sub get_dist_name {
	return 'App-Scaffolder-Puppet';
}


=head2 get_options

Return additional options for this command.

=cut

sub get_options {
	my ($class) = @_;
	return (
		[ 'name|n=s'    => 'Name of the new Puppet module that should be created' ],
		[ 'package|p=s' => 'Name of a package that should be available in templates '
			. '(defaults to the value of the --name parameter)' ],
	);
}


sub validate_args {
	my ($self, $opt, $args) = @_;

	$self->next::method($opt, $args);
	unless ($self->contains_base_args($opt) || $opt->name()) {
		$self->usage_error("Parameter 'name' required");
	}
	return;
}


=head2 get_extra_template_dirs

Extend the template search path with C</etc/puppet/scaffolder_templates> or
C</usr/local/etc/puppet/scaffolder_templates> if they exist.

=head3 Result

The extended list with template directories.

=cut

sub get_extra_template_dirs {
	my ($self, $command) = @_;

	my $template_dir_name = 'scaffolder_templates';
	my @extra_template_dirs = grep { -d $_ && -r $_ } (
		Path::Class::Dir->new('', 'etc', 'puppet', $template_dir_name),
		Path::Class::Dir->new('', 'usr', 'local', 'etc', 'puppet', $template_dir_name),
	);

	return (
		$self->next::method($command),
		@extra_template_dirs,
	);
}


=head1 SEE ALSO

=over

=item *

L<https://puppetlabs.com/puppet/puppet-open-source> - Puppet

=item *

L<https://docs.puppetlabs.com/puppet/latest/reference/modules_fundamentals.html> - Module Fundamentals

=back

=cut

1;

