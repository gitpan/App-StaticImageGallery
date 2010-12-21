
use Test::More tests => 7;
use Path::Class ();
BEGIN {
    use_ok( 'App::StaticImageGallery' );
    use_ok( 'App::StaticImageGallery::Dir' );
}

my $dir = App::StaticImageGallery::Dir->new(
    ctx      => App::StaticImageGallery->new_with_options(),
    work_dir => Path::Class::dir('t/images/'),
);
isa_ok($dir, 'App::StaticImageGallery::Dir');

my @images = $dir->images;

my $image = shift @images;
isa_ok($image, 'App::StaticImageGallery::Image');
is($image->original,'JPEG.jpg','JPEG.jpg');

$image = shift @images;
isa_ok($image, 'App::StaticImageGallery::Image');
is($image->original,'PNG.png','PNG.png');

