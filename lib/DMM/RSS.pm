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
