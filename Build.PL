#!/usr/bin/perl -w
use strict;
use Module::Build::WithXSpp;


my $inc = "/usr/local/include/cld"; # BSD
unless (-e $inc) {
	$inc = "/usr/include/cld2"; # Linux
	unless (-e $inc) {
		die "Unable to find libcld2...\n";
	}
}


my $build = Module::Build::WithXSpp->new(
  module_name     => 'Lingua::Identify::CLD2',
  license         => 'perl',
  requires        => {
  },
  test_requires => { 'Test::More' => 0, 'Test::Exception' => 0, },
  # Provides useful extra C typemaps for opaque objects:
  extra_typemap_modules => {
    'ExtUtils::Typemaps::ObjectMap'  => '0.01',
    'ExtUtils::Typemap::STL::String' => '0.04',
    'ExtUtils::Typemap::Basic'       => '0.04',
  },
  early_includes => [qw()],
  extra_compiler_flags => ["-Isrc", "-I$inc/internal", "-I$inc/public"],
  extra_linker_flags   => ["-lcld2"],
);

$build->create_build_script;
