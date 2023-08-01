/* perl's defines mess up the namespace horribly, so do that last */
#include "llvm/ExecutionEngine/Orc/LLJIT.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Module.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/InitLLVM.h"
#include "llvm/Support/TargetSelect.h"

#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "imext.h"
#include "imperl.h"

std::unique_ptr<llvm::InitLLVM> init_llvm;

std::array my_args{
  "Imager::Engine::LLVM",
    (const char *)nullptr
    };
const char **my_argv = my_args.data();
int my_argc = my_args.size() - 1;


class LLVM {
public:
  LLVM():
    m_jit(llvm::orc::LLJITBuilder().create()),
    m_context(new llvm::LLVMContext()),
    m_module(new llvm::Module("Imager::Engine::LLVM", *m_context)) {
  }
  class Compiled {
  };
  Compiled *_compile(SV *tree);

  llvm::Expected<std::unique_ptr<llvm::orc::LLJIT>> m_jit;
  std::unique_ptr<llvm::LLVMContext> m_context;
  std::unique_ptr<llvm::Module> m_module;
};

#define LLVM__Compiled LLVM::Compiled

DEFINE_IMAGER_CALLBACKS;

MODULE = Imager::Engine::LLVM    PACKAGE = Imager::Engine::LLVM

LLVM *
LLVM::new()

LLVM::Compiled *
LLVM::_compile(SV *tree)

void
LLVM::DESTROY()
  CODE:
    delete THIS;

void
CLONE_SKIP()
  CODE:

MODULE = Imager::Engine::LLVM    PACKAGE = Imager::Engine::LLVM::Compiled

void
LLVM::Compiled::DESTROY()

void
CLONE_SKIP()
  CODE:

BOOT:
        init_llvm = std::make_unique<llvm::InitLLVM>(my_argc, my_argv, false);
        llvm::InitializeNativeTarget();
        llvm::InitializeNativeTargetAsmPrinter();
        PERL_INITIALIZE_IMAGER_CALLBACKS;
