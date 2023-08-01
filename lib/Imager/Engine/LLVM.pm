package Imager::Engine::LLVM;
use strict;
use warnings;
use Imager;

our $VERSION;
BEGIN {
  $VERSION = "1.000";
  use XSLoader;
  #++$DynaLoader::dl_debug;
  XSLoader::load("Imager::Engine::LLVM" => $VERSION);
}
#my $boot = "boot_Imager__Engine__LLVM";
#print DynaLoader::dl_find_symbol($DynaLoader::dl_librefs[-1], $boot), "\n";
#print "Symbols @DynaLoader::dl_require_symbols\n";
#print ($boot eq $DynaLoader::dl_require_symbols[0] ? "Good\n" : "Bad\n");

#print "Loaded",DynaLoader::dl_error(),"\n";

sub compile {
  my ($self, %opts) = @_;

  my $tree = $opts{tree}
    or die;

  return $self->_compile($tree);
}

1;
