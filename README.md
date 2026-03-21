# Brainf*ck Compiler

**Brainf*ck Compiler**, or **BFC**, is written in Swift and backended by LLVM.

## Building **BFC**

`llvm.pc` `/opt/homebrew/lib/pkgconfig/`
```
Name: llvm
Libs: -L/opt/homebrew/opt/llvm/lib -lLLVM-22
Cflags: -I/opt/homebrew/opt/llvm/include
```

## Using **BFC**

```sh
  $ bfc helloworld.bf
  $ clang helloworld.o -o helloworld
  $ ./helloworld
```
