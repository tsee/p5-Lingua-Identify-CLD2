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

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = (
    qw(
      DetectLanguage
      LanguageName
      LanguageCode
      LanguageDeclaredName
      GetLanguageFromName
      LanguageCloseSet
      IsLatnLanguage
      IsOthrLanguage
    ),
    keys(%constants),
  );

our %EXPORT_TAGS = ('all' => \@EXPORT_OK);

1;
__END__

=head1 NAME

Lingua::Identify::CLD2 - CLD2 wrapper for Perl

=head1 DESCRIPTION

This module is an XS wrapper around the CLD2 "compact language detection"
library.

Optionally, you may choose to import a any or all of the functions listed below
into your namespace using normal L<Exporter> semantics.
You can import all of them with the C<":all"> tag.

=head2 DetectLanguage

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
