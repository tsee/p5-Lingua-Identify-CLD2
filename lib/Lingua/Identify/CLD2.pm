package Lingua::Identify::CLD2;
use 5.008;
use strict;
use warnings;

our $VERSION = '0.01';


require XSLoader;
XSLoader::load('Lingua::Identify::CLD2', $VERSION);

my %constants;
BEGIN {
  %constants = (
    # FIXME these are copy/pasted from the header, so might be very version dependent. :( ENOTENOUGHTIME
    # Also keep in sync with docs below
    kCLDFlagScoreAsQuads => 0x0100,  #/ Force Greek, etc. => quads
    kCLDFlagHtml =>         0x0200,  #/ Debug HTML => stderr
    kCLDFlagCr =>           0x0400,  #/ <cr> per chunk if HTML
    kCLDFlagVerbose =>      0x0800,  #/ More debug HTML => stderr
    kCLDFlagQuiet =>        0x1000,  #/ Less debug HTML => stderr
    kCLDFlagEcho =>         0x2000,  #/ Echo input => stderr
    kCLDFlagBestEffort =>   0x4000,  #/ Give best-effort answer,
  );
}
use constant \%constants;

use Lingua::Identify::CLD2::GenConstants;

require Exporter;
our @ISA = qw(Exporter);

my @functions = qw(
  DetectLanguage
  LanguageName
  LanguageCode
  LanguageDeclaredName
  GetLanguageFromName
  LanguageCloseSet
  IsLatnLanguage
  IsOthrLanguage
  ULScriptName
  ULScriptCode
  ULScriptDeclaredName
  GetULScriptFromName
);
  #ULScriptRecognitionType
  #LScript4

our @EXPORT_OK;
push @EXPORT_OK, (
  @functions,
  keys(%constants),
);

our %EXPORT_TAGS;
$EXPORT_TAGS{all} = \@EXPORT_OK;
$EXPORT_TAGS{functions} = \@functions;
$EXPORT_TAGS{constants} ||= [];
push @{$EXPORT_TAGS{constants}}, keys %constants;

1;
__END__

=head1 NAME

Lingua::Identify::CLD2 - CLD2 wrapper for Perl

=head1 DESCRIPTION

This module is an XS wrapper around the CLD2 "compact language detection"
library.

Optionally, you may choose to import a any or all of the functions and constants
discussed below into your namespace using normal L<Exporter> semantics.
You can import all of them with the C<":all"> tag. You can choose to import
only the functions or the (large number of) constants using C<":functions">
and C<":constants"> respectively.

The constants that correspond to the C<Language> enum values in CLD2
have a C<CLD2_> prefix in Perl. For example C<CLD2::GERMAN> in C++
becomes C<CLD2_GERMAN> in C<Lingua::Identify::CLD2> in Perl.
Unlike the C<Language> enum values, the C<ULScript> values already have
a name prefix in C++, so they are exposed as is, eg. C<ULScript_Balinese>.

The documentation of this module might be a bit spotty. If in doubt,
refer to the CLD2 documentation of the respective functions and please
submit patches after you do.

=head2 DetectLanguage

The main API function that, given a text and some other parameters, will
attempt to detect the language(s) of the text. An example output is reproduced
below. For details on its interpretation, please refer to the CLD2 manual.
Patches welcome.

The first input parameter should be a string containing the text to
analyse. All other parameters are optional.

The second parameter is a boolean (defaulting to true) that indicates
whether or not the provided text is plain text. If not, HTML tags/etc will be
stripped out. The third parameter can be a CLD hints structure (see below) or
undefined. The fourth parameter is an integer for flags. The following flags
are defined as constants (and exportable from this module). They can be
combined with the C<|> operator. As per the CLD2 documentation,
they are:

    kCLDFlagScoreAsQuads # Force Greek, etc. => quads
    kCLDFlagHtml         # Debug HTML => stderr
    kCLDFlagCr           # <cr> per chunk if HTML
    kCLDFlagVerbose      # More debug HTML => stderr
    kCLDFlagQuiet        # Less debug HTML => stderr
    kCLDFlagEcho         # Echo input => stderr
    kCLDFlagBestEffort   # Give best-effort answer

Quoting the CLD2 documentation with more detail on the flags:

    kCLDFlagScoreAsQuads
     Normally, several languages are detected solely by their Unicode script.
     Combined with appropritate lookup tables, this flag forces them instead
     to be detected via quadgrams. This can be a useful refinement when looking
     for meaningful text in these languages, instead of just character sets.
     The default tables do not support this use.
    kCLDFlagHtml
     For each detection call, write an HTML file to stderr, showing the text
     chunks and their detected languages.
    kCLDFlagCr
     In that HTML file, force a new line for each chunk.
    kCLDFlagVerbose
     In that HTML file, show every lookup entry.
    kCLDFlagQuiet
     In that HTML file, suppress most of the output detail.
    kCLDFlagEcho
     Echo every input buffer to stderr.
    kCLDFlagBestEffort
     Give best-effort answer, instead of UNKNOWN_LANGUAGE. May be useful for
     short text if the caller prefers an approximate answer over none.
 
A CLD2 hints structure in Perl is a reference to a hash
containing any of the following keys. They all have
defaults.

    content_language_hint => eg. "mi,en" would boost Maori and English
    tld_hint              => eg. "id" boosts Indonesian
    encoding_hint         => Given a CLD encoding id boosts that encoding
                             (FIXME not exposed to Perl right now)
    language_hint         => Given a CLD language id, boosts that language

Here's an example return value for this function (see F<t/01basic.t>
in this distribution for this particular example).

    $VAR1 = {
              'valid_prefix_bytes' => 0,
              'language_string' => 'SINDHI',
              'language' => 99,
              'text_bytes' => 202,
              'normalized_score3' => '1039',
              'is_reliable' => 1,
              'resultchunkvector' => [
                                       {
                                         'pad' => 42035,
                                         'bytes' => 212,
                                         'lang1' => 5,
                                         'lang1_str' => 'GERMAN',
                                         'offset' => 0
                                       }
                                     ],
              'percent3' => 99
            };


=head2 LanguageName

Given a CLD2 language id, converts it to a human readable language name.

=head2 LanguageCode

Given a CLD2 language id, converts it to a language code. Quoting the CLD2
documentation:

    Given the Language, return the language code, e.g. "ko"
    This is determined by the following (in order of preference):
    
    - ISO-639-1 two-letter language code
      (all except those mentioned below)
    - ISO-639-2 three-letter bibliographic language code
      (Tibetan, Dhivehi, Cherokee, Syriac)
    - Google-specific language code
      (ChineseT ("zh-TW"), Teragram Unknown, Unknown,
      Portuguese-Portugal, Portuguese-Brazil, Limbu)
    - Fake RTypeNone names.

=head2 LanguageDeclaredName

=head2 GetLanguageFromName

Convert a language name or code back to a CLD2 id.

Quoting the CLD2 documentation:

    Name can be either full name or ISO code, or can be ISO code embedded in
    a language-script combination such as "en-Latn-GB".

=head2 LanguageCloseSet

Given a language code or CLD2 language id,
returns which set of statistically-close languages lang is in. 0 means "none".

=head2 ULScriptName

Given CLD2 ULScript id, returns the script name as a string.

=head2 ULScriptCode

Given CLD2 ULScript id, returns the code for the script as a string (equivalent
to the language codes, see above).

=head2 GetULScriptFromName

Given a script name or code, returns the corresponding CLD2 ULScript id.

=head2 DefaultLanguage

Given an ULScript id, returns the most common Language (id) in that script.

=head1 CAVEATS

For both portability (CLD2 uses a bunch of ummm.. shell scripts as a build system)
AND for consistency of the exposed constants, C<Lingua::Identify::CLD2> ships
its own copy of CLD2. Newer versions of CLD2 thus require updating this module.

The encoding functionality for hints is mostly not exposed.
But if needed, that should be a rather simple matter of
(relatively little) programming.

=head1 SEE ALSO

At the time of this writing, CLD2 still lived on Google Code: L<https://code.google.com/p/cld2>

L<Lingua::Identify::CLD>

=head1 AUTHOR

Steffen Mueller, E<lt>smueller@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

The C<Lingua::Identify::CLD2> module (but not the CLD2 library) is

Copyright (C) 2015 by Steffen Mueller

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.0 or,
at your option, any later version of Perl 5 you may have available.

At the time of this writing, the CLD2 library code carries the
following license and author notice:

    Copyright 2013 Google Inc. All Rights Reserved.
    
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    
        http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
    
    Author: dsites@google.com (Dick Sites)

=cut
