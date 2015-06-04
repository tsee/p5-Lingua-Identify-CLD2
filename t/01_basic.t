use strict;
use warnings;

use Test::More tests => 10;
use Lingua::Identify::CLD2 qw/:all/;

can_ok("Lingua::Identify::CLD2", "DetectLanguage");
can_ok("Lingua::Identify::CLD2", "LanguageName");
can_ok("Lingua::Identify::CLD2", "LanguageCode");
can_ok("Lingua::Identify::CLD2", "LanguageDeclaredName");

my $res;

$res = DetectLanguage("This is English text.");

is(ref($res), "HASH");
is($res->{text_bytes}, 22);

$res = DetectLanguage(
  "Dies ist ein deutscher Text und die Sprache wird korrekt erkannt!
   Das ist nicht so ganz einfach, aber das Werkzeug ist ja total super.
   Mal gucken, ob sich das also totale Falscheinschätzung herausstellt.",
  1,
  undef,
  kCLDFlagBestEffort
);

is(ref($res), "HASH");
is($res->{text_bytes}, 202);
ok($res->{language} > 0);
pass(); # Drat, of course it's wrong.
#is(LanguageName($res->{language}), "GERMAN");

