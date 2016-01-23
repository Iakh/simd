SIMD
====

std.simd alternative imlementation of std.simd ([Manu's one](https://github.com/TurkeyMan/simd))

Structure:
* std.simd - processor independent intrinsics and some high level stuff.
    * std.simd.x86 - unified (compiler independent) x86 intrinsic call.
    * std.simd.arm - unified arm-based simd.

Since std.simd and submodules are overlapping functionality std.simd doesn't
imports submodules(publicly).

Implementation plan:
 1. simdFind - demo with sse, sse2
 2. adequate 128bit support (sse, sse2)
 3. high level architecture/demo
 4. 5. ... mmx, 64bit and 256bit support, arm-neon etc.
