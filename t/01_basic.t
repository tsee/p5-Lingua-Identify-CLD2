use strict;
use warnings;
use utf8;

use Test::More tests => 22;

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
cmp_ok($res->{languages}->[0]->{score}, '>', 0);
$res->{languages}->[0]->{score} = 1;
is_deeply($res->{languages}, [
    {
        'language_code' => 'en',
        'percent' => 95,
        'score' => 1
    }], "languages");

$res = DetectLanguage(
  "Dies ist ein deutscher Text und die Sprache wird korrekt erkannt!
   Das ist nicht so ganz einfach, aber das Werkzeug ist ja total super.
   Mal gucken, ob sich das also totale Falscheinschätzung herausstellt.",
);

is(ref($res), "HASH");
is($res->{text_bytes}, 201);
is($res->{language_name}, 'GERMAN');
is($res->{language_code}, 'de');
$res->{languages}->[0]->{score} = 1;
is_deeply($res->{languages}, [
    {
        'language_code' => 'de',
        'percent' => 99,
        'score' => 1
    }], "languages");

$res = DetectLanguage("Привет", {bestEffort => 1});
is($res->{language_name}, "RUSSIAN");
is($res->{language_code}, "ru");

$res = DetectLanguage("Hello world, Привет мир", {bestEffort => 1});

is($res->{language_name}, "RUSSIAN");
is($res->{language_code}, "ru");

$res->{languages}->[0]->{score} = 1;
$res->{languages}->[1]->{score} = 1;

is_deeply($res->{languages}, [
       {
         'language_code' => 'ru',
         'percent' => 58,
         'score' => 1
       },
       {
         'language_code' => 'en',
         'percent' => 36,
         'score' => 1
       }], 'languages');


# in 'full' mode this returns UNKNOWN. In 'chrome' mode it returns correct answer.
#$res = DetectLanguage("При регистрации заезда гостям необходимо предъявить действительное удостоверение личности, выданное государственным органом, или паспорт.", {bestEffort=>1});
#is($res->{language_code}, "ru");
#is($res->{is_reliable}, 1);
#is_deeply($res->{languages}, [{}]);


$res = DetectLanguage("Para garantizar la reserva deberá abonar un depósito mediante transferencia bancaria o PayPal (consulte las condiciones del hotel). Una vez efectuada la reserva, el establecimiento le facilitará las instrucciones necesarias.");

is($res->{language_code}, "es");
is($res->{is_reliable}, 1);



#$res = DetectLanguage("請注意，使用桑拿浴室和日光浴室的客人須支付額外費用");
#use Data::Dumper;
#print STDERR Dumper($res) . "\n";
#is($res->{language_name}, "Chinese");
#is($res->{language}, "zh");



#$res = DetectLanguage(<<'TEXT', {bestEffort=>1});
#El hotel Delminium está ubicado en Stup, un barrio residencial de Sarajevo, cerca del aeropuerto de la ciudad, y cuenta con 2 pistas de tenis, campo de fútbol y restaurante. También ofrece conexión Wi-Fi gratuita y aparcamiento privado vigilado. El Delminium alberga un bar y un restaurante decorado con un estilo clásico en tonos amarillos, donde se sirven platos típicos de Bosnia junto con platos clásicos internacionales. Las habitaciones tiene el suelo de moqueta e incluyen baño privado de azulejo, TV y minibar. Este hotel se encuentra a 8 km del centro de Sarajevo, a 4 km del aeropuerto de Sarajevo, a 6 km de la estación de trenes y autobuses central de Sarajevo y a 45 minutos en coche de las estaciones olímpicas de Bjelasnica e Igman.
#TEXT
