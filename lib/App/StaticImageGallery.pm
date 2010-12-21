package App::StaticImageGallery;
BEGIN {
  $App::StaticImageGallery::VERSION = '0.001';
}

use App::StaticImageGallery::Dir;
use Path::Class ();
use Getopt::Lucid qw( :all );
use Pod::Usage;

sub new_with_options {
    my $class = shift;

    my @specs = (
        Counter("verbose|v"),
        Counter("quiet|q"),
        Param("dir|d"),
        Param("style|s")->default("Simple"),
        Switch("help|h")->anycase,
        Switch("man")->anycase,
    );
    my $self  = {
        _opt     => Getopt::Lucid->getopt(\@specs),
        _arg_dir => shift @ARGV,
    };

    bless $self, $class;
}

sub opt { shift->{_opt} };

sub config {
    return {
        data_dir_name => '.StaticImageGallery',
    }
}

sub run {
    my ($self) = @_;

    if ($self->opt->get_help() || $self->opt->get_man() ){
        pod2usage(
            -input => __FILE__,
            -verbose => $self->opt->get_man()  ? 2 : 1,
            -exitval => 0,
        );
    }

    if ( length($self->opt->get_dir()) < 1
        and length($self->{_arg_dir}) < 1
    ){
        $self->msg_error("\nRequired option 'dir' not found.\n");
        pod2usage(
            -input => __FILE__,
            -verbose => 1,
            -exitval => 1,
        );

    }
    my $dir = App::StaticImageGallery::Dir->new(
        ctx => $self,
        work_dir => Path::Class::dir($self->opt->get_dir() || $self->{_arg_dir}),
    );

    $dir->write_index();
}

sub msg_verbose {
    my $self = shift;
    my $level = shift;
    my $format = shift;
    return if $self->opt->get_verbose() == 0;

    if ( $self->opt->get_verbose() >= $level ){
        printf "VERBOSE: " . $format . "\n" ,@_;
    }
    return;
}

sub msg {
    my $self = shift;
    my $format = shift;
    return if $self->opt->get_quiet() > 0;
    printf $format . "\n" ,@_;
    return;
}

sub msg_warning {
    my $self = shift;
    my $format = shift;
    printf STDERR $format . "\n" ,@_;
    return;
}

sub msg_error {
    my $self = shift;
    my $format = shift;
    printf STDERR $format . "\n" ,@_;
    return;
}

1;    # End of App::StaticImageGallery
__END__
=head1 NAME

App::StaticImageGallery - Static Image Gallery

=head1 VERSION

version 0.001

=head1 SYNOPSIS

    ./bin/sig [options] [dir]

=head1 OPTIONS


=head2 B<--dir|-d>

Working directory, direcotry with the images.
Write html pages and thumbnails into this directory.

=head2 B<--style|-s>

=over 4

=item Default: Simple

=back

Set the style/theme.

=head2 B<--help|-h>

Print a brief help message and exits.

=head2 B<-v>

Verbose mode, more v more output...

=head2 B<--quiet|-q>

Quite mode

=head1 METHODS

=over 4

=item new_with_options

=item config

Returns the config hashref, at the moment the configuration is hardcode in StaticImageGallery.pm

=item msg

If not in quite mode, print message to STDOUT.

=item msg_error

Print message at any time to STDERR.

=item msg_verbose

=item msg_warning

Print message at any time to STDERR.

=item opt

Returns the L<Getopt::Lucid> object.

=item run

=back

=head1 TODO

=over 4

=item * Documentation

=item * Sourcecode cleanup

=item * Write Dispatcher
    
    App::StaticImageGallery::Style::Source::Dispatcher

=item * App::StaticImageGallery::Image line: 31, errorhandling

=item * Test unsupported format

=item * Added config file support ( App::StaticImageGallery->config )

=back

=head1 COPYRIGHT & LICENSE

Copyright 2010 Robert Bohne.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=head1 AUTHOR

Robert Bohne, C<< <rbo at cpan.org> >>