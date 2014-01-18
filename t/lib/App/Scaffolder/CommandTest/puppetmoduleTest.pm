package App::Scaffolder::CommandTest::puppetmoduleTest;
use parent qw(Test::Class);

use strict;
use warnings;

use Carp;
use Test::More;
use Test::Exception;
use App::Cmd::Tester;
use Path::Class::Dir;
use Test::File;
use Test::File::ShareDir '-share' => {
	'-dist' => { 'App-Scaffolder-Puppet' => Path::Class::Dir->new(qw(share)) }
};
use Directory::Scratch;
use App::Scaffolder;
use App::Scaffolder::Command::puppetmodule;

sub app_test : Test(7) {
	my ($self) = @_;

	my $scratch = Directory::Scratch->new();
	my $result = test_app('App::Scaffolder' => [
		qw(puppetmodule --name vim --template package --target), $scratch->base()
	]);
	is($result->stdout(), '', 'no output');
	is($result->error, undef, 'threw no exceptions');
	my @files = qw(
		manifests/init.pp
		manifests/install.pp
		manifests/params.pp
		tests/init.pp
		.gitignore
	);
	for my $file (@files) {
		file_exists_ok($scratch->base()->file($file));
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

1;
