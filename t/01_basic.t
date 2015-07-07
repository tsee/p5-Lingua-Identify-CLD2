use strict;
use warnings;
use utf8;

use Test::More tests => 21;

use Lingua::Identify::CLD2 qw/:all/;

can_ok("Lingua::Identify::CLD2", "DetectLanguage");
can_ok("Lingua::Identify::CLD2", "LanguageName");
can_ok("Lingua::Identify::CLD2", "LanguageCode");
can_ok("Lingua::Identify::CLD2", "LanguageDeclaredName");

my $res;

$res = DetectLanguage("This is English text.");

is(ref($res), "HASH");
is($res->{text_bytes}, 22);
is($res->{language_name}, 'ENGLISH');
is($res->{language_code}, 'en');
is_deeply($res->{languages}, [
    {
        'language_code' => 'en',
        'percent' => 95,
        'score' => 1804
    }], "languages");

$res = DetectLanguage(
  "Dies ist ein deutscher Text und die Sprache wird korrekt erkannt!
   Das ist nicht so ganz einfach, aber das Werkzeug ist ja total super.
   Mal gucken, ob sich das also totale Falscheinschätzung herausstellt.",
  1,
  undef
);

is(ref($res), "HASH");
is($res->{text_bytes}, 201);
ok($res->{language} > 0, "language > 0");
is(LanguageName($res->{language}), "GERMAN");
is($res->{language_name}, 'GERMAN');
is($res->{language_code}, 'de');
is_deeply($res->{languages}, [
    {
        'language_code' => 'de',
        'percent' => 99,
        'score' => 1141
    }], "languages");

$res = DetectLanguage("Привет", 1, undef, kCLDFlagBestEffort);
is($res->{language_name}, "RUSSIAN");
is($res->{language_code}, "ru");

$res = DetectLanguage("Hello world, Привет мир", 1, undef, kCLDFlagBestEffort);
is($res->{language_name}, "RUSSIAN");
is($res->{language_code}, "ru");

is_deeply($res->{languages}, [
       {
         'language_code' => 'ru',
         'percent' => 58,
         'score' => 614
       },
       {
         'language_code' => 'en',
         'percent' => 36,
         'score' => 1194
       }], 'languages');
