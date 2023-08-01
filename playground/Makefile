LLVM_CONFIG=llvm-config

CXXFLAGS=$(shell $(LLVM_CONFIG) --cxxflags)
LDFLAGS=$(shell $(LLVM_CONFIG) --ldflags --libs)

play1 : play1.cpp
	$(CXX) -oplay1 play1.cpp $(CXXFLAGS) $(LDFLAGS)

config:
	@echo CXXFLAGS=$(CXXFLAGS)
	@echo LDFLAGS=$(LDFLAGS)
	@echo CXX=$(CXX)
