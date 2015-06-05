#!perl
use strict;
use warnings;
use File::Spec::Functions;
use Data::Dumper;

my $internal_folder = catdir(qw(src cld2 internal));
my $gen_languages_header = catfile($internal_folder, "generated_language.h");

print "# WARNING: DO NOT CHANGE! MACHINE GENERATED!\n\n";

print "package Lingua::Identify::CLD2::GenConstants;\n";
print "package Lingua::Identify::CLD2; # hacky\n\n";

open my $fh, "<", $gen_languages_header or die $!;
my $code = do {local $/; <$fh>};
close $fh;

$code =~ s/\/\/.*$//mg;
$code =~ m/
  typedef \s+ enum \s* \{
  (
    (?:
      \s*
      \w+ \s* = \s* \d+ \s* ,
    )+
  )
  \s*
  NUM_LANGUAGES
  \s* \} \s* Language \s* ;
/sx
  or die "Could not find Language enum";

my $lang_enum = chop_match($1);

print <<'HERE';
our %Constants;
BEGIN {
  %Constants = (
HERE

foreach my $elem (@$lang_enum) {
  print "  'CLD2_$elem->[0]' => $elem->[1],\n";
}

print <<'HERE';
  );
  use constant \%Constants;

  our @EXPORT_OK;
  push @EXPORT_OK, keys %Constants;
  our %EXPORT_TAGS;
  $EXPORT_TAGS{constants} ||= [];
  push @{$EXPORT_TAGS{constants}}, keys %Constants;

  %Constants = (); # At least release _some_ of that gob of memory
}

HERE


print "\n\n1;\n";

sub chop_match {
  my $match = shift;
  my @chopped = split /\s*,\s*/, $match;
  my @out;

  foreach (@chopped) {
    my ($name, $num) = split /\s*=\s*/, $_;
    s/^\s+//, s/\s+$// for ($name, $num);
    push @out, [$name, $num];
  }

  return \@out;
}
