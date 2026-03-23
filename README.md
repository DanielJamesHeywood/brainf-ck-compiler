# Brainf*ck Compiler

**Brainf*ck Compiler**, or **BFC**, is written in Swift with an LLVM backend.

## Building **BFC**

This package is dependent on LLVM.
On macOS, you can resolve this dependency by installing LLVM via homebrew and creating the following pkg-config file, `llvm.pc`, at `/opt/homebrew/lib/pkgconfig/`:

```
Name: llvm
Libs: -L/opt/homebrew/opt/llvm/lib -lLLVM-22
Cflags: -I/opt/homebrew/opt/llvm/include
```

## Using **BFC**

**BFC** compiles brainf*ck files into object files.
To run your code, you must first link these object files externally into an executable:

```sh
  $ bfc helloworld.bf
  $ clang helloworld.o -o helloworld
  $ ./helloworld
```

## Emitting LLVM IR

Passing `-emit-llvm-ir` as a command-line argument causes **BFC** to emit LLVM IR in addition to the object file:

```sh
  $ bfc helloworld.bf -emit-llvm-ir
```

## Emitting Assembly

Passing `-emit-assembly` as a command-line argument causes **BFC** to emit assembly in addition to the object file:

```sh
  $ bfc helloworld.bf -emit-assembly
```
