package DMM::Util;
use strict;
use warnings;

use 5.010;

use parent qw/Exporter/;
use utf8;

our @EXPORT_OK = qw/separate_name/;

sub separate_name {
    my $name_str = shift;

    if ($name_str =~ m{(.+?)[(（](.+?)[)）]}) {
        my ($name, $aliases_str) = ($1, $2);

        my @aliases;
        if ($aliases_str) {
            @aliases = split /[,、]/, $aliases_str;
        }

        return ($name, \@aliases);
    } else {
        return ($name_str);
    }
}

1;

__END__

=encoding utf-8

=for stopwords

=head1 NAME

DMM::Util - Utilities of DMM package

=head1 SYNOPSIS

    use DMM::Util qw/separate_name/;

    my ($name, $aliases_ref) = separate_name("Name(alias1, alias2)");
    print "Current name: $name";
    print "Aliases\n"
    print "  $_\n" for @{$aliases_ref};

=head1 DESCRIPTION

DMM::Util is utility functions used in DMM package.

=head1 FUNCTIONS

=head2 separate_name($string)

Separate current name and aliases and return them.
If C<$string> contains only current name, returns only current name.

=head1 AUTHOR

Syohei YOSHIDA E<lt>syohex@gmail.comE<gt>

=head1 COPYRIGHT

Copyright 2012 - Syohei YOSHIDA

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
