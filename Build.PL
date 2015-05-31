#!/usr/bin/perl -w
use strict;
use Module::Build::WithXSpp;

my $additional_link_dir = "../cld2-read-only/internal";
my $additional_include_dir = "../cld2-read-only/public";

my $build = Module::Build::WithXSpp->new(
  module_name     => 'Lingua::Identify::CLD2',
  license         => 'perl',
  requires        => {
  },
  # Provides useful extra C typemaps for opaque objects:
  extra_typemap_modules => {
    'ExtUtils::Typemaps::ObjectMap'  => '0.01',
    'ExtUtils::Typemap::STL::String' => '0.04',
    'ExtUtils::Typemap::Basic'       => '0.04',
  },
  early_includes => [qw()],
  extra_compiler_flags => [ (defined($additional_include_dir) ? "-I$additional_include_dir" : ()) ],
  extra_linker_flags   => [ (defined($additional_link_dir) ? "-L$additional_link_dir" : ()),
                            "-lcld2_full" ],
);

$build->create_build_script;
