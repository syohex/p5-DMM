package DMM::RSS;
use strict;
use warnings;

use 5.010;

use Carp ();

use XML::RSS::LibXML;
use Furl;
use Encode ();

use DMM::Product;

sub new {
    my ($class, $url) = @_;

    unless (defined $url) {
        Carp::croak("missing mandatory 'url' parameter");
    }

    my $rss = XML::RSS::LibXML->new;
    my $ua  = Furl->new(
        agent   => __PACKAGE__,
        timeout => 10,
    );

    bless {
        url => $url,
        rss => $rss,
        ua  => $ua,
    }, $class;
}

sub parse {
    my $self = shift;

    my $res = $self->{ua}->get( $self->{url} );
    unless ($res->is_success) {
        Carp::croak("Can't download $self->{url}");
    }

    # RSS is always UTF-8 ??
    my $rss_content = Encode::decode_utf8($res->content);
    $self->{rss}->parse($rss_content);

    my @products;
    for my $item ( @{$self->{rss}->{items}} ) {
        my $product = DMM::Product->new(
            title       => $item->{title},
            link        => $item->{link},
            package     => $item->{package},
            description => $item->{content}->{encoded},
        );
        push @products, $product;
    }

    return @products;
}

1;

__END__

=encoding utf-8

=for stopwords

=head1 NAME

DMM::RSS - DMM RSS module

=head1 SYNOPSIS

    use DMM::RSS;

    my $url = 'DMM RSS URL';
    my $rss = DMM::RSS->new($url);

    my @products = $rss->parse;
    for my $product (@products) {
        printf "Title: %s\n", $product->title;
    }


=head1 DESCRIPTION

DMM::RSS parses RSS and extract products information from it.

=head1 AUTHOR

Syohei YOSHIDA E<lt>syohex@gmail.comE<gt>

=head1 COPYRIGHT

Copyright 2012 - Syohei YOSHIDA

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
