use strict;
use warnings;

use Test::More tests => 6;
use Lingua::Identify::CLD2;

can_ok("Lingua::Identify::CLD2", "DetectLanguage");

my $res;

$res = Lingua::Identify::CLD2::DetectLanguage("This is English text.");

is(ref($res), "HASH");
is($res->{text_bytes}, 22);

$res = Lingua::Identify::CLD2::DetectLanguage(
  "Dies ist ein deutscher Text und die Sprache wird korrekt erkannt!",
  1,
  undef,
  0x4000 # try hard even on short strings (TODO named flag needs exposing to Perl)
);

is(ref($res), "HASH");
is($res->{text_bytes}, 66);
ok($res->{language} > 0);

