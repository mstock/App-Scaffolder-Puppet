package App::Scaffolder::Puppet::Command;

use parent qw(App::Scaffolder::Command);

# ABSTRACT: Base class for App::Scaffolder::Puppet commands

use strict;
use warnings;

use File::Spec::Functions qw(catdir);
use MRO::Compat;
use Path::Class::Dir;

=head1 SYNOPSIS

	use parent qw(App::Scaffolder::Puppet::Command);

=head1 DESCRIPTION

This class provides some specialized methods for the C<puppet*> commands.

In addition to the default template search path (see
L<App::Scaffolder|App::Scaffolder> for details), this command base class will
also look for templates in C</etc/puppet/scaffolder_templates> or
C</usr/local/etc/puppet/scaffolder_templates> if they exist.

=head1 METHODS

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
		namepartspath      => catdir(@name_parts) || '',
		subnameparts       => \@subname_parts,
		subnamepartsjoined => join('_', @subname_parts),
		subnamepartspath   => catdir(@subname_parts) || '',
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
		[ 'name|n=s'    => 'Name of the new Puppet module/class that should be created' ],
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

Extend the template search path with
C</etc/puppet/scaffolder_templates/E<lt>command nameE<gt>> or
C</usr/local/etc/puppet/scaffolder_templates/E<lt>command nameE<gt>> if they
exist.

=head3 Result

The extended list with template directories.

=cut

sub get_extra_template_dirs {
	my ($self, $command) = @_;

	my @sub_path = ('etc', 'puppet', 'scaffolder_templates', $command);
	my @extra_template_dirs = grep { -d $_ && -r $_ } (
		Path::Class::Dir->new('', @sub_path),
		Path::Class::Dir->new('', 'usr', 'local', @sub_path),
	);

	return (
		$self->next::method($command),
		@extra_template_dirs,
	);
}


1;

=head1 SEE ALSO

=over

=item *

L<App::Scaffolder::Command|App::Scaffolder::Command>

=back
