#!perl -w
use strict;
use ExtUtils::MakeMaker 6.46;
use ExtUtils::CppGuess;
use Getopt::Long;
use Config;

my $verbose = $ENV{IM_VERBOSE};
my @libpaths;
my @incpaths;

GetOptions("incpath=s", \@incpaths,
           "libpath=s" => \@libpaths,
           "verbose|v" => \$verbose);

our $BUILDING_IMAGER;
our %IMAGER_LIBS;

my %opts = 
  (
   NAME => 'Imager::Engine::LLVM',
   VERSION_FROM => 'lib/Imager/Engine/LLVM.pm',
   OBJECT => 'LLVM.o',
   #DEFINE => $define,
   #clean => { FILES => 'testout' },
   LICENSE => "perl_5",
   AUTHOR => 'Tony Cook <tonyc@cpan.org>',
   XSOPT => '-C++',
   ABSTRACT => 'LLVM image generation for Imager',
   META_MERGE =>
   {
     'meta-spec' =>
     {
       version => "2",
       url => "https://metacpan.org/pod/CPAN::Meta::Spec",
     },
     resources =>
     {
       homepage => "http://imager.perl.org/",
       repository =>
       {
         type => "git",
         url => "https://github.com/tonycoz/imager-engine-llvm.git",
         web => "https://github.com/tonycoz/imager-engine-llvm/",
       },
       bugtracker =>
       {
         web => "https://github.com/tonycoz/imager-engine-llvm/",
       },
     },
   },
  );


my @inc;
  unshift @INC, "inc";
  require Imager::ExtUtils;
  push @inc, Imager::ExtUtils->includes;
  $opts{TYPEMAPS} = [ Imager::ExtUtils->typemap ];

  # Imager required configure through use
  my @Imager_req = ( Imager => "0.94" );
  if (eval { ExtUtils::MakeMaker->VERSION('6.46'); 1 }) {
    $opts{META_MERGE}{prereqs} =
      {
       configure =>
       {
	requires =>
	{
	 @Imager_req,
	},
       },
       build =>
       {
	requires =>
	{
	 @Imager_req,
	 "Test::More" => "0.47",
	}
       },
       runtime =>
       {
	requires =>
	{
	 @Imager_req,
	}
       },
       test =>
       {
	requires =>
	{
	 "Test::More" => "0.47",
	}
       },
      };
    $opts{PREREQ_PM} =
      {
       @Imager_req,
       XSLoader => 0,
      };
  }

my $llvm_config = $ENV{LLVM_CONFIG};
$llvm_config ||= "llvm-config";

my $llvm_static = $ENV{LLVM_STATIC} ? "--link-static" : "";

print STDERR __LINE__, "\n";
my $cflags = `$llvm_config --cxxflags`;
print STDERR __LINE__, "\n";
my $ldflags = `$llvm_config --ldflags --libs $llvm_static all`;
print STDERR __LINE__, "\n";

unless ($cflags && $ldflags && $cflags =~ /\S/ && $ldflags =~ /\S/) {
  die <<'DIE'
OS unsupported: LLVM libraries or headers not found

  $llvm_config --cflags all
or
  $llvm_config --ldflags --libs $llvm_static all

didn't return a useful result.
DIE
}
tr/\n /  /s for $cflags, $ldflags;

my $guess = ExtUtils::CppGuess->new;
$guess->add_extra_compiler_flags
  (
    $cflags . " " . Imager::ExtUtils->includes
   );
$guess->add_extra_linker_flags
  (
    $ldflags
   );

WriteMakefile(%opts, $guess->makemaker_options);
