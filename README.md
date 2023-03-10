# Demonstration of error when generating AXI4 pins

This repository contains [testBlock](/src/main/scala/testBlock.scala) module that contains single AXI4 memory mapped register. Verilog generation worked for `chipyard 1.8.1` but for more recent versions (e.g. chipyard tag `0af8643`) it fails.

The error reported is:
```
chisel3.package$ExpectedChiselTypeException: wire type 'AXI4TestBlock.in.bits.extra: Wire[BundleMap]' must be a Chisel type, not hardware
[error] 	at ... ()
[error] 	at freechips.rocketchip.amba.axi4.AXI4RegisterNode.$anonfun$regmap$16(RegisterRouter.scala:42)
[error] 	at chisel3.internal.prefix$.apply(prefix.scala:48)
[error] 	at freechips.rocketchip.amba.axi4.AXI4RegisterNode.$anonfun$regmap$15(RegisterRouter.scala:42)
[error] 	at chisel3.internal.plugin.package$.autoNameRecursively(package.scala:33)
[error] 	at freechips.rocketchip.amba.axi4.AXI4RegisterNode.regmap(RegisterRouter.scala:42)
[error] 	at adder.AXI4TestBlock.regmap(testBlock.scala:34)
[error] 	at adder.TestBlock$$anon$1.<init>(testBlock.scala:18)
[error] 	at adder.TestBlock.$anonfun$module$1(testBlock.scala:15)
[error] 	at chisel3.internal.plugin.package$.autoNameRecursively(package.scala:33)
[error] 	at adder.TestBlock.module$lzycompute(testBlock.scala:15)
[error] 	at adder.TestBlock.module(testBlock.scala:15)
[error] 	at adder.AXI4TestBlockApp$.$anonfun$new$2(testBlock.scala:41)
[error] 	at ... ()
[error] 	at ... (Stack trace trimmed to user code only. Rerun with --full-stacktrace to see the full stack trace)
```

And it seems that error is due to the Wire of Wire in [RegisterRouter](https://github.com/chipsalliance/rocket-chip/blob/f5ebf26b369922b2924d71e185c473c0385bf54e/src/main/scala/amba/axi4/RegisterRouter.scala) or more concisely:

```
...
41. val in = Wire(Decoupled(new RegMapperInput(params)))
42. val ar_extra = Wire(in.bits.extra)
43. val aw_extra = Wire(in.bits.extra)
...
```

From the part of the linked code, it can be seen that ar_extra is Wire(Wire(...)) and it looks like that this is the reason for the error. Unfortunatelly, removing the additional Wire in lines 42 and 43 solves this problem but generates additional ones.

## Reproducing error

In order to initialize submodules run:
```
$ ./init_submodules.sh
```

After that run `sbt` and in the `sbt` console just type `run`.
```
sbt:axi4test> run
```