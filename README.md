# Brainf*ck Compiler

**Brainf*ck Compiler**, or **BFC**, is written in Swift with an LLVM backend.

## Building **BFC**

`llvm.pc` `/opt/homebrew/lib/pkgconfig/`
```
Name: llvm
Libs: -L/opt/homebrew/opt/llvm/lib -lLLVM-22
Cflags: -I/opt/homebrew/opt/llvm/include
```

## Using **BFC**

**BFC** compiles brainf*ck files into object files. To run your code, you must first link these object files externally into an executable:

```sh
  $ bfc helloworld.bf
  $ clang helloworld.o -o helloworld
  $ ./helloworld
```
