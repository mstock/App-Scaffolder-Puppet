package App::Scaffolder::CommandTest::puppetmoduleTest;
use parent qw(Test::Class);

use strict;
use warnings;

use Carp;
use Test::More;
use Test::Exception;
use Test::MockObject;
use App::Cmd::Tester;
use Path::Class::Dir;
use File::Spec::Functions qw(catfile);
use Test::File;
use Test::File::ShareDir '-share' => {
	'-dist' => { 'App-Scaffolder-Puppet' => Path::Class::Dir->new(qw(share)) }
};
use Directory::Scratch;
use App::Scaffolder;
use App::Scaffolder::Command::puppetmodule;


sub setup : Test(setup) {
	my ($self) = @_;

	$self->{opt_mock} = Test::MockObject->new();
	delete $self->{target_opt};
	delete $self->{name_opt};
	delete $self->{package_opt};
	$self->{opt_mock}->mock(target => sub {
		return $self->{target_opt};
	});
	$self->{opt_mock}->mock(name => sub {
		return $self->{name_opt};
	});
	$self->{opt_mock}->mock(package => sub {
		return $self->{package_opt};
	});
}


sub app_test : Test(7) {
	my ($self) = @_;

	my $scratch = Directory::Scratch->new();
	my $result = test_app('App::Scaffolder' => [
		qw(puppetmodule --name vim --template package --quiet --target), $scratch->base()
	]);
	is($result->stdout(), '', 'no output');
	is($result->error, undef, 'threw no exceptions');
	my @files = (
		[qw(manifests init.pp)],
		[qw(manifests install.pp)],
		[qw(manifests params.pp)],
		[qw(tests init.pp)],
		[qw(.gitignore)],
	);
	for my $file (@files) {
		file_exists_ok($scratch->base()->file(@{$file}));
	}
}


sub get_extra_template_dirs_test : Test(2) {
	my ($self) = @_;

	my $sharedir = Path::Class::Dir->new(qw(share));
	my $cmd = App::Scaffolder::Command::puppetmodule->new({});
	local $ENV{SCAFFOLDER_TEMPLATE_PATH} = $sharedir->stringify();
	my @template_dirs = $cmd->get_extra_template_dirs('puppetmodule');
	cmp_ok(scalar @template_dirs, '>=', 1, 'at least one template dir found');
	is(
		scalar(grep { $_ eq $sharedir->subdir('puppetmodule')->stringify() } @template_dirs),
		1,
		'path from environment respected'
	);
}


sub get_variables_test : Test(3) {
	my ($self) = @_;

	my $cmd = App::Scaffolder::Command::puppetmodule->new({});

	$self->{name_opt} = 'foo';
	is_deeply($cmd->get_variables($self->{opt_mock}), {
		name               => 'foo',
		package            => 'foo',
		nameparts          => ['foo'],
		namepartsjoined    => 'foo',
		namepartspath      => 'foo',
		subnameparts       => [],
		subnamepartsjoined => '',
		subnamepartspath   => undef,
	}, 'variables ok');

	$self->{name_opt} = 'foo::bar';
	is_deeply($cmd->get_variables($self->{opt_mock}), {
		name               => 'foo::bar',
		package            => 'foo::bar',
		nameparts          => ['foo', 'bar'],
		namepartsjoined    => 'foo_bar',
		namepartspath      => catfile('foo', 'bar'),
		subnameparts       => ['bar'],
		subnamepartsjoined => 'bar',
		subnamepartspath   => 'bar',
	}, 'variables ok');

	$self->{name_opt} = 'foo::bar::baz';
	$self->{package_opt} = 'foo-bar-baz';
	is_deeply($cmd->get_variables($self->{opt_mock}), {
		name               => 'foo::bar::baz',
		package            => 'foo-bar-baz',
		nameparts          => ['foo', 'bar', 'baz'],
		namepartsjoined    => 'foo_bar_baz',
		namepartspath      => catfile('foo', 'bar', 'baz'),
		subnameparts       => ['bar', 'baz'],
		subnamepartsjoined => 'bar_baz',
		subnamepartspath   => catfile('bar', 'baz'),
	}, 'variables ok');
}

1;
