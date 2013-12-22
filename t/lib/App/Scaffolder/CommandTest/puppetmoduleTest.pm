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
		tests/manifest.pp
		.gitignore
	);
	for my $file (@files) {
		file_exists_ok($scratch->base()->file($file));
	}
}

1;
