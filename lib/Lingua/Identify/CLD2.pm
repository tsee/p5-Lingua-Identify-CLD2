package Lingua::Identify::CLD2;
use 5.008;
use strict;
use warnings;

our $VERSION = '0.01';

require XSLoader;
XSLoader::load('Lingua::Identify::CLD2', $VERSION);

require Exporter;
our @EXPORT_OK = qw(DetectLanguage);
our %EXPORT_TAGS = (':all' => \@EXPORT_OK);

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
