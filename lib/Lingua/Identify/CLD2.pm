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
      LanguageShortCode
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

=head1 SEE ALSO

=head1 AUTHOR

Steffen Mueller, E<lt>smueller@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

The C<Lingua::Identify::CLD2> module is

Copyright (C) 2015 by Steffen Mueller

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
