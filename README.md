SIMD
====

iakh.simd is an alternative imlementation of cross-platform/cross-compiler simd ([Manu's one](https://github.com/TurkeyMan/simd))

Structure:
----------
* iakh.simd - processor independent intrinsics and some high level stuff.
    * iakh.simd.x86 - unified (compiler independent) x86 intrinsic call.
    * iakh.simd.arm - unified arm-based simd (not implemented).

Implementation plan (evolvs):
-----------------------------
 * simdFind - demo with sse, sse2. (done)
 * Implement Mask128Bit. Vector comparison. (done)
 * Compile time SIMD version check.
 * Fallback SIMD implementations.
 * Implement Comprable!UInt.
 * Define simd subset supported/emulated by all archs. High level design.
 * Size independent vector/mask.
 * ... 256bit support, arm-neon, PPC, etc.

This library is distributed under Boost Software Licence. See the [licence](LICENSE) file.
