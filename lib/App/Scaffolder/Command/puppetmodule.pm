package App::Scaffolder::Command::puppetmodule;
use parent qw(App::Scaffolder::Command);

# ABSTRACT: Scaffold a Puppet module

use strict;
use warnings;

use MRO::Compat;

=head1 SYNOPSIS

	scaffolder puppetmodule --template package --name vim

=head1 DESCRIPTION

App::Scaffolder::Command::puppetmodule scaffolds a Puppet module.

=head1 METHODS

=cut

=head2 get_target

Specialized C<get_target> version which uses the name if no target was given.

=cut

sub get_target {
	my ($self, $opt) = @_;
	return Path::Class::Dir->new($opt->target() || $opt->name());
}


=head2 get_variables

Specialized C<get_variables> version which returns the name of the module.

=cut

sub get_variables {
	my ($self, $opt) = @_;
	return {
		name => scalar $opt->name(),
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
		[ 'name=s' => 'Name of the new Puppet module that should be created' ],
	);
}


sub validate_args {
	my ($self, $opt, $args) = @_;

	$self->next::method($opt, $args);
	unless ($self->contains_base_args($opt) || $opt->name()) {
		$self->usage_error("Parameter 'name' required");
	}
}

1;

