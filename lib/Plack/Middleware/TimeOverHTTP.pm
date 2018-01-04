package Plack::Middleware::TimeOverHTTP;

use strict;
use warnings;

use parent 'Plack::Middleware';

use HTTP::Status qw/ :constants /;
use Time::HiRes qw/ clock_gettime CLOCK_REALTIME /;

sub call {
    my ( $self, $env ) = @_;

    unless ( $env->{REQUEST_URI} eq '/.well-known/time' ) {
        return $self->app->($env);
    }

    unless ( $env->{REQUEST_METHOD} eq 'HEAD' ) {
        return [ HTTP_METHOD_NOT_ALLOWED, [], [] ];
    }

    [
        HTTP_NO_CONTENT,
        [
            'X-HTTPSTIME' => clock_gettime(CLOCK_REALTIME),
        ],
        [],
    ];

}

1;
