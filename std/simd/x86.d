/// Unified SIMD intrinsics for x86 and x86_64 architecture
module std.simd.x86;

version(X86)
{
    version(DigitalMars)
        version = NoSIMD; // DMD-x86 does not support SIMD
    else
        version = X86_OR_X64;
}
else version(X86_64)
{
    version = X86_OR_X64;
}

version(X86_OR_X64):

version(GNU)
{
    // GDC intrinsics
    import gcc.builtins;
}

public import core.simd;

version(LDC)
{
    import ldc.gccbuiltins_x86;
    import ldc.simd;
}

/// Namespace for sse intrinsics
struct sse
{
static:
//pragma(inline, true):

//Arithmetic:
//addps - Adds 4 single-precision (32bit) floating-point values to 4 other single-precision floating-point values.
//addss - Adds the lowest single-precision values, top 3 remain unchanged.
//subps - Subtracts 4 single-precision floating-point values from 4 other single-precision floating-point values.
//subss - Subtracts the lowest single-precision values, top 3 remain unchanged.
//mulps - Multiplies 4 single-precision floating-point values with 4 other single-precision values.
//mulss - Multiplies the lowest single-precision values, top 3 remain unchanged.
//divps - Divides 4 single-precision floating-point values by 4 other single-precision floating-point values.
//divss - Divides the lowest single-precision values, top 3 remain unchanged.
//rcpps - Reciprocates (1/x) 4 single-precision floating-point values.
//rcpss - Reciprocates the lowest single-precision values, top 3 remain unchanged.
//sqrtps - Square root of 4 single-precision values.
//sqrtss - Square root of lowest value, top 3 remain unchanged.
//rsqrtps - Reciprocal square root of 4 single-precision floating-point values.
//rsqrtss - Reciprocal square root of lowest single-precision value, top 3 remain unchanged.
//maxps - Returns maximum of 2 values in each of 4 single-precision values.
//maxss - Returns maximum of 2 values in the lowest single-precision value. Top 3 remain unchanged.
//minps - Returns minimum of 2 values in each of 4 single-precision values.
//minss - Returns minimum of 2 values in the lowest single-precision value, top 3 remain unchanged.
//pavgb - Returns average of 2 values in each of 8 bytes.
//pavgw - Returns average of 2 values in each of 4 words.
//psadbw - Returns sum of absolute differences of 8 8bit values. Result in bottom 16 bits.
//pextrw - Extracts 1 of 4 words.
//pinsrw - Inserts 1 of 4 words.
//pmaxsw - Returns maximum of 2 values in each of 4 signed word values.
//pmaxub - Returns maximum of 2 values in each of 8 unsigned byte values.
//pminsw - Returns minimum of 2 values in each of 4 signed word values.
//pminub - Returns minimum of 2 values in each of 8 unsigned byte values.
//pmovmskb - builds mask byte from top bit of 8 byte values.
//pmulhuw - Multiplies 4 unsigned word values and stores the high 16bit result.
//pshufw - Shuffles 4 word values. Takes 2 128bit values (source and dest) and an 8-bit immediate value, and then fills in each Dest 32-bit value from a Source 32-bit value specified by the immediate. The immediate byte is broken into 4 2-bit values.
//
//Logic:
//andnps - Logically ANDs 4 single-precision values with the logical inverse (NOT) of 4 other single-precision values.
//andps - Logically ANDs 4 single-precision values with 4 other single-precision values.
//orps - Logically ORs 4 single-precision values with 4 other single-precision values.
//xorps - Logically XORs 4 single-precision values with 4 other single-precision values.
//
//Compare:
//cmpxxps - Compares 4 single-precision values.
//cmpxxss - Compares lowest 2 single-precision values.
//comiss - Compares lowest 2 single-recision values and stores result in EFLAGS.
//ucomiss - Compares lowest 2 single-precision values and stores result in EFLAGS. (QNaNs don't throw exceptions with ucomiss, unlike comiss.)
//Compare Codes (the xx parts above):
//eq - Equal to.
//lt - Less than.
//le - Less than or equal to.
//ne - Not equal.
//nlt - Not less than.
//nle - Not less than or equal to.
//ord - Ordered.
//unord - Unordered.
//
//Conversion:
//cvtpi2ps - Converts 2 32bit integers to 32bit floating-point values. Top 2 values remain unchanged.
//cvtps2pi - Converts 2 32bit floating-point values to 32bit integers.
//cvtsi2ss - Converts 1 32bit integer to 32bit floating-point value. Top 3 values remain unchanged.
//cvtss2si - Converts 1 32bit floating-point value to 32bit integer.
//cvttps2pi - Converts 2 32bit floating-point values to 32bit integers using truncation.
//cvttss2si - Converts 1 32bit floating-point value to 32bit integer using truncation.
//
//State:
//fxrstor - Restores FP and SSE State.
//fxsave - Stores FP and SSE State.
//ldmxcsr - Loads the mxcsr register.
//stmxcsr - Stores the mxcsr register.
//
//Load/Store:
//movaps - Moves a 128bit value.
//movhlps - Moves high half to a low half.
//movlhps - Moves low half to upper halves.?
//movhps - Moves 64bit value into top half of an xmm register.
//movlps - Moves 64bit value into bottom half of an xmm register.
//movmskps - Moves top bits of single-precision values into bottom 4 bits of a 32bit register.
//movss - Moves the bottom single-precision value, top 3 remain unchanged if the destination is another xmm register, otherwise they're set to zero.
//movups - Moves a 128bit value. Address can be unaligned.
//maskmovq - Moves a 64bit value according to a mask.
//movntps - Moves a 128bit value directly to memory, skipping the cache. (NT stands for "Non Temporal".)
//movntq - Moves a 64bit value directly to memory, skipping the cache.
//
//Shuffling:
//shufps - Shuffles 4 single-precision values. Complex.
//unpckhps - Unpacks single-precision values from high halves.
//unpcklps - Unpacks single-precision values from low halves.
//
//Cache Control:
//prefetchT0 - Fetches a cache-line of data into all levels of cache.
//prefetchT1 - Fetches a cache-line of data into all but the highest levels of cache.
//prefetchT2 - Fetches a cache-line of data into all but the two highest levels of cache.
//prefetchNTA - Fetches data into only the highest level of cache, not the lower levels.
//sfence - Guarantees that all memory writes issued before the sfence instruction are completed before any writes after the sfence instruction.

}

/// Namespace for sse2 intrinsics
struct sse2
{
static:
//pragma(inline, true):

    /// Arithmetic:

    /// addpd - Adds 2 64bit doubles.
    double2 addpd(double2 v1, double2 v2)
    {
        version(DigitalMars)
        {
            return __simd(XMM.ADDPD, v1, v2);
        }
        else version(GNU)
        {
            return __builtin_ia32_addpd(v1, v2);
        }
        else version(LDC)
        {
            return v1 + v2;
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    /// Example:
    unittest
    {
        double2 a = [1, 2];
        double2 b = [3, 4];
        auto c = addpd(a, b);
        assert(c.array == [4, 6]);
    }

    /// addsd - Adds bottom 64bit doubles.
    double2 addsd(double2 v1, double2 v2)
    {
        version(DigitalMars)
        {
            return __simd(XMM.ADDSD, v1, v2);
        }
        else version(GNU)
        {
            return __builtin_ia32_addsd(v1, v2);
        }
        else version(LDC)
        {
            return __builtin_ia32_addsd(v1, v2);
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    /// Example:
    unittest
    {
        double2 a = [1, 2];
        double2 b = [30, 40];
        auto c = addsd(a, b);
        assert(c.array == [31, 2]);
    }

    /// subpd - Subtracts 2 64bit doubles.
    double2 subpd(double2 v1, double2 v2)
    {
        version(DigitalMars)
        {
            return __simd(XMM.SUBPD, v1, v2);
        }
        else version(GNU)
        {
            return __builtin_ia32_subpd(v1, v2);
        }
        else version(LDC)
        {
            return v1 - v2;
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    /// Example:
    unittest
    {
        double2 a = [1, 2];
        double2 b = [30, 40];
        auto c = subpd(a, b);
        assert(c.array == [-29, -38]);
    }

    /// subsd - Subtracts bottom 64bit doubles.
    double2 subsd(double2 v1, double2 v2)
    {
        version(DigitalMars)
        {
            return __simd(XMM.SUBSD, v1, v2);
        }
        else version(GNU)
        {
            return __builtin_ia32_subsd(v1, v2);
        }
        else version(LDC)
        {
            return __builtin_ia32_subsd(v1, v2);
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    /// Example:
    unittest
    {
        double2 a = [1, 2];
        double2 b = [30, 40];
        auto c = subsd(a, b);
        assert(c.array == [-29, 2]);
    }

    /// mulpd - Multiplies 2 64bit doubles.
    double2 mulpd(double2 v1, double2 v2)
    {
        version(DigitalMars)
        {
            return __simd(XMM.MULPD, v1, v2);
        }
        else version(GNU)
        {
            return __builtin_ia32_mulpd(v1, v2);
        }
        else version(LDC)
        {
            return v1 * v2;
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    /// Example:
    unittest
    {
        double2 a = [-1, -2];
        double2 b = [3, 3];
        auto c = mulpd(a, b);
        assert(c.array == [-3, -6]);
    }

    /// mulsd - Multiplies bottom 64bit doubles.
    double2 mulsd(double2 v1, double2 v2)
    {
        version(DigitalMars)
        {
            return __simd(XMM.MULSD, v1, v2);
        }
        else version(GNU)
        {
            return __builtin_ia32_mulsd(v1, v2);
        }
        else version(LDC)
        {
            return __builtin_ia32_mulsd(v1, v2);
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    /// Example:
    unittest
    {
        double2 a = [-1, -2];
        double2 b = [3, 3];
        auto c = mulsd(a, b);
        assert(c.array == [-3, -2]);
    }

    /// divpd - Divides 2 64bit doubles.
    double2 divpd(double2 v1, double2 v2)
    {
        version(DigitalMars)
        {
            return __simd(XMM.DIVPD, v1, v2);
        }
        else version(GNU)
        {
            return __builtin_ia32_divpd(v1, v2);
        }
        else version(LDC)
        {
            return v1 / v2;
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    /// Example:
    unittest
    {
        double2 a = [3, 6];
        double2 b = [3, 3];
        auto c = divpd(a, b);
        assert(c.array == [1, 2]);
    }

    /// divsd - Divides bottom 64bit doubles.
    double2 divsd(double2 v1, double2 v2)
    {
        version(DigitalMars)
        {
            return __simd(XMM.DIVSD, v1, v2);
        }
        else version(GNU)
        {
            return __builtin_ia32_divsd(v1, v2);
        }
        else version(LDC)
        {
            return __builtin_ia32_divsd(v1, v2);
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    /// Example:
    unittest
    {
        double2 a = [3, 6];
        double2 b = [3, 3];
        auto c = divsd(a, b);
        assert(c.array == [1, 6]);
    }

    /// maxpd - Gets largest of 2 64bit doubles for 2 sets.
    double2 maxpd(double2 v1, double2 v2)
    {
        version(DigitalMars)
        {
            return __simd(XMM.MAXPD, v1, v2);
        }
        else version(GNU)
        {
            return __builtin_ia32_maxpd(v1, v2);
        }
        else version(LDC)
        {
            return __builtin_ia32_maxpd(v1, v2);
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    /// Example:
    unittest
    {
        double2 a = [1, 20];
        double2 b = [2, 10];
        auto c = maxpd(a, b);
        assert(c.array == [2, 20]);
    }

    /// maxsd - Gets largets of 2 64bit doubles to bottom set.
    double2 maxsd(double2 v1, double2 v2)
    {
        version(DigitalMars)
        {
            return __simd(XMM.MAXSD, v1, v2);
        }
        else version(GNU)
        {
            return __builtin_ia32_maxsd(v1, v2);
        }
        else version(LDC)
        {
            return __builtin_ia32_maxsd(v1, v2);
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    /// Example:
    unittest
    {
        double2 a = [1, 20];
        double2 b = [2, 30];
        auto c = maxsd(a, b);
        assert(c.array == [2, 20]);
    }

    /// minpd - Gets smallest of 2 64bit doubles for 2 sets.
    double2 minpd(double2 v1, double2 v2)
    {
        version(DigitalMars)
        {
            return __simd(XMM.MINPD, v1, v2);
        }
        else version(GNU)
        {
            return __builtin_ia32_minpd(v1, v2);
        }
        else version(LDC)
        {
            return __builtin_ia32_minpd(v1, v2);
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    /// Example:
    unittest
    {
        double2 a = [1, 20];
        double2 b = [2, 10];
        auto c = minpd(a, b);
        assert(c.array == [1, 10]);
    }

    /// minsd - Gets smallest of 2 64bit values for bottom set.
    double2 minsd(double2 v1, double2 v2)
    {
        version(DigitalMars)
        {
            return __simd(XMM.MINSD, v1, v2);
        }
        else version(GNU)
        {
            return __builtin_ia32_minsd(v1, v2);
        }
        else version(LDC)
        {
            return __builtin_ia32_minsd(v1, v2);
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    /// Example:
    unittest
    {
        double2 a = [1, 20];
        double2 b = [2, 10];
        auto c = minsd(a, b);
        assert(c.array == [1, 20]);
    }

    /// paddb - Adds 16 8bit integers.
    byte16 paddb(byte16 v1, byte16 v2)
    {
        version(DigitalMars)
        {
            return __simd(XMM.PADDB, v1, v2);
        }
        else version(GNU)
        {
            return __builtin_ia32_paddb128(v1, v2);
        }
        else version(LDC)
        {
            return v1 + v2;
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    /// Example:
    unittest
    {
        byte16 a = [1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1];
        byte16 b = [10, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1];
        auto c = paddb(a, b);
        assert(c.array == [11, 22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2]);
    }

    //paddw - Adds 8 16bit integers.
    //paddd - Adds 4 32bit integers.
    //paddq - Adds 2 64bit integers.
    //paddsb - Adds 16 8bit integers with saturation.
    //paddsw - Adds 8 16bit integers using saturation.
    //paddusb - Adds 16 8bit unsigned integers using saturation.
    //paddusw - Adds 8 16bit unsigned integers using saturation.
    //psubb - Subtracts 16 8bit integers.
    //psubw - Subtracts 8 16bit integers.
    //psubd - Subtracts 4 32bit integers.
    //psubq - Subtracts 2 64bit integers.
    //psubsb - Subtracts 16 8bit integers using saturation.
    //psubsw - Subtracts 8 16bit integers using saturation.
    //psubusb - Subtracts 16 8bit unsigned integers using saturation.
    //psubusw - Subtracts 8 16bit unsigned integers using saturation.
    //pmaddwd - Multiplies 16bit integers into 32bit results and adds results.
    //pmulhw - Multiplies 16bit integers and returns the high 16bits of the result.
    //pmullw - Multiplies 16bit integers and returns the low 16bits of the result.
    //pmuludq - Multiplies 2 32bit pairs and stores 2 64bit results.
    //rcpps - Approximates the reciprocal of 4 32bit singles.
    //rcpss - Approximates the reciprocal of bottom 32bit single.
    //sqrtpd - Returns square root of 2 64bit doubles.
    //sqrtsd - Returns square root of bottom 64bit double.

    /// pmaxub - Returns maximum of 2 values in each of 8 unsigned byte values.
    byte16 pmaxub(byte16 v1, byte16 v2)
    {
        version(DigitalMars)
        {
            return __simd(XMM.PMAXUB, v1, v2);
        }
        else version(GNU)
        {
            return __builtin_ia32_pmaxub128(v1, v2);
        }
        else version(LDC)
        {
            return __builtin_ia32_pmaxub128(v1, v2);
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    /// Example:
    unittest
    {
        byte16 a = [1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1];
        byte16 b = [10, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1];
        auto c = pmaxub(a, b);
        assert(c.array == [10, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1]);
    }

    //
    //Logic:
    //andnpd - Logically NOT ANDs 2 64bit doubles.
    //andnps - Logically NOT ANDs 4 32bit singles.
    //andpd - Logically ANDs 2 64bit doubles.
    //pand - Logically ANDs 2 128bit registers.
    //pandn - Logically Inverts the first 128bit operand and ANDs with the second.
    //por - Logically ORs 2 128bit registers.
    //pslldq - Logically left shifts 1 128bit value.
    //psllq - Logically left shifts 2 64bit values.
    //pslld - Logically left shifts 4 32bit values.
    //psllw - Logically left shifts 8 16bit values.
    //psrad - Arithmetically right shifts 4 32bit values.
    //psraw - Arithmetically right shifts 8 16bit values.
    //psrldq - Logically right shifts 1 128bit values.
    //psrlq - Logically right shifts 2 64bit values.
    //psrld - Logically right shifts 4 32bit values.
    //psrlw - Logically right shifts 8 16bit values.
    //pxor - Logically XORs 2 128bit registers.
    //orpd - Logically ORs 2 64bit doubles.
    //xorpd - Logically XORs 2 64bit doubles.
    //
    //Compare:
    //cmppd - Compares 2 pairs of 64bit doubles.
    //cmpsd - Compares bottom 64bit doubles.
    //comisd - Compares bottom 64bit doubles and stores result in EFLAGS.
    //ucomisd - Compares bottom 64bit doubles and stores result in EFLAGS. (QNaNs don't throw exceptions with ucomisd, unlike comisd.
    //pcmpxxb - Compares 16 8bit integers.
    //pcmpxxw - Compares 8 16bit integers.
    //pcmpxxd - Compares 4 32bit integers.
    //Compare Codes (the xx parts above):
    //eq - Equal to.
    //lt - Less than.
    //le - Less than or equal to.
    //ne - Not equal.
    //nlt - Not less than.
    //nle - Not less than or equal to.
    //ord - Ordered.
    //unord - Unordered.

    /// pcmpeqb - Compares 16 8bit integers.
    byte16 pcmpeqb(byte16 v1, byte16 v2)
    {
        version(DigitalMars)
        {
            return __simd(XMM.PCMPEQB, v1, v2);
        }
        else version(GNU)
        {
            return __builtin_ia32_pcmpeqb128(v1, v2);
        }
        else version(LDC)
        {
            return equalMask!byte16(v1, v2);
        }
        else
        {
            static assert(0, "Unsupported on this architecture");
        }
    }

    /// Example:
    unittest
    {
        byte16 a = [1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
        byte16 b = [1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1];
        auto c = pcmpeqb(a, b);
        assert(c.array == [-1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1]);
    }

    //
    //Conversion:
    //cvtdq2pd - Converts 2 32bit integers into 2 64bit doubles.
    //cvtdq2ps - Converts 4 32bit integers into 4 32bit singles.
    //cvtpd2pi - Converts 2 64bit doubles into 2 32bit integers in an MMX register.
    //cvtpd2dq - Converts 2 64bit doubles into 2 32bit integers in the bottom of an XMM register.
    //cvtpd2ps - Converts 2 64bit doubles into 2 32bit singles in the bottom of an XMM register.
    //cvtpi2pd - Converts 2 32bit integers into 2 32bit singles in the bottom of an XMM register.
    //cvtps2dq - Converts 4 32bit singles into 4 32bit integers.
    //cvtps2pd - Converts 2 32bit singles into 2 64bit doubles.
    //cvtsd2si - Converts 1 64bit double to a 32bit integer in a GPR.
    //cvtsd2ss - Converts bottom 64bit double to a bottom 32bit single. Tops are unchanged.
    //cvtsi2sd - Converts a 32bit integer to the bottom 64bit double.
    //cvtsi2ss - Converts a 32bit integer to the bottom 32bit single.
    //cvtss2sd - Converts bottom 32bit single to bottom 64bit double.
    //cvtss2si - Converts bottom 32bit single to a 32bit integer in a GPR.
    //cvttpd2pi - Converts 2 64bit doubles to 2 32bit integers using truncation into an MMX register.
    //cvttpd2dq - Converts 2 64bit doubles to 2 32bit integers using truncation.
    //cvttps2dq - Converts 4 32bit singles to 4 32bit integers using truncation.
    //cvttps2pi - Converts 2 32bit singles to 2 32bit integers using truncation into an MMX register.
    //cvttsd2si - Converts a 64bit double to a 32bit integer using truncation into a GPR.
    //cvttss2si - Converts a 32bit single to a 32bit integer using truncation into a GPR.
    //
    //Load/Store:
    //(is "minimize cache pollution" the same as "without using cache"??)
    //movq - Moves a 64bit value, clearing the top 64bits of an XMM register.
    //movsd - Moves a 64bit double, leaving tops unchanged if move is between two XMMregisters.
    //movapd - Moves 2 aligned 64bit doubles.
    //movupd - Moves 2 unaligned 64bit doubles.
    //movhpd - Moves top 64bit value to or from an XMM register.
    //movlpd - Moves bottom 64bit value to or from an XMM register.
    //movdq2q - Moves bottom 64bit value into an MMX register.
    //movq2dq - Moves an MMX register value to the bottom of an XMM register. Top is cleared to zero.
    //movntpd - Moves a 128bit value to memory without using the cache. NT is "Non Temporal."
    //movntdq - Moves a 128bit value to memory without using the cache.
    //movnti - Moves a 32bit value without using the cache.
    //maskmovdqu - Moves 16 bytes based on sign bits of another XMM register.

    /// pmovmskb - Generates a 16bit Mask from the sign bits of each byte in an XMM register.
    int pmovmskb(byte16 v)
    {
        version(DigitalMars)
        {
            version(none) // Should be like this
                return __simd(XMM.PCMPEQB, v);

            version(D_InlineAsm_X86_64)
            {
                asm
                {
                    naked;
                    pmovmskb EAX, XMM0;
                    ret;
                }
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }
        else version(GNU)
        {
            return __builtin_ia32_pmovmskb128(v);
        }
        else version(LDC)
        {
            return __builtin_ia32_pmovmskb128(v);
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    /// Example:
    unittest
    {
        byte16 a = [1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
        byte16 b = [1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1];
        auto c = pcmpeqb(a, b);
        auto mask = pmovmskb(c);

        assert(mask == 0b1000000000000011);
    }

    //
    //Shuffling:
    //pshufd - Shuffles 32bit values in a complex way.
    //pshufhw - Shuffles high 16bit values in a complex way.
    //pshuflw - Shuffles low 16bit values in a complex way.
    //unpckhpd - Unpacks and interleaves top 64bit doubles from 2 128bit sources into 1.
    //unpcklpd - Unpacks and interleaves bottom 64bit doubles from 2 128 bit sources into 1.
    //punpckhbw - Unpacks and interleaves top 8 8bit integers from 2 128bit sources into 1.
    //punpckhwd - Unpacks and interleaves top 4 16bit integers from 2 128bit sources into 1.
    //punpckhdq - Unpacks and interleaves top 2 32bit integers from 2 128bit sources into 1.
    //punpckhqdq - Unpacks and interleaces top 64bit integers from 2 128bit sources into 1.
    //punpcklbw - Unpacks and interleaves bottom 8 8bit integers from 2 128bit sources into 1.
    //punpcklwd - Unpacks and interleaves bottom 4 16bit integers from 2 128bit sources into 1.
    //punpckldq - Unpacks and interleaves bottom 2 32bit integers from 2 128bit sources into 1.
    //punpcklqdq - Unpacks and interleaces bottom 64bit integers from 2 128bit sources into 1.
    //packssdw - Packs 32bit integers to 16bit integers using saturation.
    //packsswb - Packs 16bit integers to 8bit integers using saturation.
    //packuswb - Packs 16bit integers to 8bit unsigned integers unsing saturation.
    //
    //Cache Control:
    //clflush - Flushes a Cache Line from all levels of cache.
    //lfence - Guarantees that all memory loads issued before the lfence instruction are completed before anyloads after the lfence instruction.
    //mfence - Guarantees that all memory reads and writes issued before the mfence instruction are completed before any reads or writes after the mfence instruction.
    //pause - Pauses execution for a set amount of time.

    //version(none)
    unittest
    {

        static const(ubyte*) memchrSIMD(const(ubyte)* ptr, int value, size_t num)
        {
            import core.bitop;

            enum CheckMask = q{
                if (mask != 0)
                {
                    auto n = bsf(mask);
                    num -= n;

                    if (num >= 0)
                    {
                        return cast(const(ubyte)*)ptr16 + n;
                    }
                    else
                    {
                        return null;
                    }
                }
            };

            if (!num)
            {
                return null;
            }

            immutable size_t MaskDWord = 0x0F;
            immutable size_t MaskCacheLine = 0x3F;

            auto ptr16 = cast(const(ubyte16)*)(cast(size_t)ptr & ~MaskDWord);
            int shift = (cast(size_t)ptr & MaskDWord);
            ubyte16 result;
            ubyte16 niddles;
            niddles.ptr[0..16] = cast(ubyte)value;
            int mask;

            if ((cast(size_t)ptr & MaskCacheLine) == 0)
            {
                num += shift;

                result = pcmpeqb(*ptr16, niddles);
                mask = pmovmskb(result);
                mask =  ((mask >> shift) << shift);

                mixin(CheckMask);

                num -= 16;
                ++ptr16;

                if (num > 0)
                    for (; cast(size_t)ptr16 & MaskCacheLine; ++ptr16)
                    {
                        result = pcmpeqb(*ptr16, niddles);
                        mask = pmovmskb(result);

                        mixin(CheckMask);

                        num -= 16;
                        if (num <= 0)
                        {
                            return null;
                        }
                    }
            }

            do
            {
                ubyte16 r1 = pcmpeqb(ptr16[0], niddles);
                ubyte16 r2 = pcmpeqb(ptr16[1], niddles);
                ubyte16 r3 = pcmpeqb(ptr16[2], niddles);
                ubyte16 r4 = pcmpeqb(ptr16[3], niddles);

                r3 = pmaxub(r1, r3);
                r4 = pmaxub(r2, r4);
                r4 = pmaxub(r3, r4);
                mask = pmovmskb(r4);

                if (mask != 0)
                {
                    mask = pmovmskb(r1);
                    mixin(CheckMask);

                    ++ptr16; num -= 16;
                    mask = pmovmskb(r2);
                    mixin(CheckMask);

                    ++ptr16; num -= 16;
                    r3 = pcmpeqb(*ptr16, niddles);
                    mask = pmovmskb(r3);
                    mixin(CheckMask);

                    ++ptr16; num -= 16;
                    r4 = pcmpeqb(*ptr16, niddles);
                    mask = pmovmskb(r4);
                    mixin(CheckMask);
                }

                num -= 64;
                ptr16 += 4;
            }
            while (num > 0);

            return null;
        }

        immutable ArraySize = 256 * 16;
        import std.range;
        import std.array;
        ubyte[] arr = (cast(ubyte)255).iota.cycle.take(ArraySize).array;

        void runSIMD()
        {
            auto testArr = arr[5 .. $ - 5];
            auto i = arr.length * 2 / 3;
            auto ptr = testArr.ptr + i++ % testArr.length;
            auto tmp = *ptr;
            *ptr = 255;
            assert(ptr == memchrSIMD(testArr.ptr, 255, testArr.length));
            *ptr = tmp;
        }

        runSIMD();
    }
}
