/// Unified SIMD intrinsics for x86 and x86_64 architecture
module iakh.simd.x86;

public import core.simd;

version(X86)
{
    version(DigitalMars)
        version = NoSIMD; // DMD-x86 does not support SIMD
    else
        version = X86_SIMD;
}
else version(X86_64)
{
    version = X86_SIMD;
}

version(X86_SIMD)
{
    enum isAvailable = true;
}
else
{
    enum isAvailable = false;
}

version(X86_SIMD):

version(GNU)
{
    // GDC intrinsics
    import gcc.builtins;
}

version(LDC)
{
    import ldc.gccbuiltins_x86;
    import ldc.simd;
}

// Float point cmp immediate
private enum CmpPXImm : byte
{
    EQ = 0, LT = 1, LE = 2, UNORD = 3, NEQ = 4, NLT = 5, NLE = 6, ORD = 7
}

/// Namespace for sse intrinsics
struct sse
{
static:
//pragma(inline, true):

    //Arithmetic float:
    public
    {
        /// addps - Adds 4 single-precision (32bit) floating-point values to 4 other single-precision floating-point values.
        float4 addps(float4 v1, float4 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.ADDPS, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_addps(v1, v2);
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
            float4 a = [1, 2, 0, 0];
            float4 b = [3, 4, 0, 0];
            auto c = addps(a, b);
            assert(c.array == [4, 6, 0, 0]);
        }

        /// addss - Adds the lowest single-precision values, top 3 remain unchanged.
        float4 addss(float4 v1, float4 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.ADDSS, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_addss(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_addss(v1, v2);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example:
        unittest
        {
            float4 a = [1, 2, 0, 0];
            float4 b = [30, 40, 0, 0];
            auto c = addss(a, b);
            assert(c.array == [31, 2, 0, 0]);
        }

        /// subps - Subtracts 4 single-precision floating-point values from 4 other single-precision floating-point values.
        float4 subps(float4 v1, float4 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.SUBPS, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_subps(v1, v2);
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
            float4 a = [1, 2, 0, 0];
            float4 b = [30, 40, 0, 0];
            auto c = subps(a, b);
            assert(c.array == [-29, -38, 0, 0]);
        }

        /// subss - Subtracts the lowest single-precision values, top 3 remain unchanged.
        float4 subss(float4 v1, float4 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.SUBSS, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_subss(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_subss(v1, v2);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example:
        unittest
        {
            float4 a = [1, 2, 0, 0];
            float4 b = [30, 40, 0, 0];
            auto c = subss(a, b);
            assert(c.array == [-29, 2, 0, 0]);
        }

        /// mulps - Multiplies 4 single-precision floating-point values with 4 other single-precision values.
        float4 mulps(float4 v1, float4 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.MULPS, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_mulps(v1, v2);
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
            float4 a = [-1, -2, 0, 0];
            float4 b = [3, 3, 0, 0];
            auto c = mulps(a, b);
            assert(c.array == [-3, -6, 0, 0]);
        }

        /// mulss - Multiplies the lowest single-precision values, top 3 remain unchanged.
        float4 mulss(float4 v1, float4 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.MULSS, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_mulss(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_mulss(v1, v2);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example:
        unittest
        {
            float4 a = [-1, -2, 0, 0];
            float4 b = [3, 3, 0, 0];
            auto c = mulss(a, b);
            assert(c.array == [-3, -2, 0, 0]);
        }

        /// divps - Divides 4 single-precision floating-point values by 4 other single-precision floating-point values.
        float4 divps(float4 v1, float4 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.DIVPS, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_divps(v1, v2);
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
            float4 a = [3, 6, 0, 0];
            float4 b = [3, 3, 1, 1];
            auto c = divps(a, b);
            assert(c.array == [1, 2, 0 ,0]);
        }

        /// divss - Divides the lowest single-precision values, top 3 remain unchanged.
        float4 divss(float4 v1, float4 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.DIVSS, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_divss(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_divss(v1, v2);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example:
        unittest
        {
            float4 a = [3, 6, 0 ,0];
            float4 b = [3, 3, 0 ,0];
            auto c = divss(a, b);
            assert(c.array == [1, 6, 0 ,0]);
        }

        /// maxps - Returns maximum of 2 values in each of 4 single-precision values.
        float4 maxps(float4 v1, float4 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.MAXPS, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_maxps(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_maxps(v1, v2);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example:
        unittest
        {
            float4 a = [1, 20, 0, 0];
            float4 b = [2, 10, 0, 0];
            auto c = maxps(a, b);
            assert(c.array == [2, 20, 0, 0]);
        }

        /// maxss - Returns maximum of 2 values in the lowest single-precision value. Top 3 remain unchanged.
        float4 maxss(float4 v1, float4 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.MAXSS, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_maxss(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_maxss(v1, v2);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example:
        unittest
        {
            float4 a = [1, 20, 0, 0];
            float4 b = [2, 30, 0, 0];
            auto c = maxss(a, b);
            assert(c.array == [2, 20, 0, 0]);
        }

        /// minps - Returns minimum of 2 values in each of 4 single-precision values.
        float4 minps(float4 v1, float4 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.MINPS, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_minps(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_minps(v1, v2);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example:
        unittest
        {
            float4 a = [1, 20, 0, 0];
            float4 b = [2, 10, 0, 0];
            auto c = minps(a, b);
            assert(c.array == [1, 10, 0, 0]);
        }

        /// minss - Returns minimum of 2 values in the lowest single-precision value, top 3 remain unchanged.
        float4 minss(float4 v1, float4 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.MINSS, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_minss(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_minss(v1, v2);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example:
        unittest
        {
            float4 a = [1, 20, 0, 0];
            float4 b = [2, 10, 0, 0];
            auto c = minss(a, b);
            assert(c.array == [1, 20, 0, 0]);
        }

        //rcpps - Reciprocates (1/x) 4 single-precision floating-point values.
        //rcpss - Reciprocates the lowest single-precision values, top 3 remain unchanged.
        //sqrtps - Square root of 4 single-precision values.
        //sqrtss - Square root of lowest value, top 3 remain unchanged.
        //rsqrtps - Reciprocal square root of 4 single-precision floating-point values.
        //rsqrtss - Reciprocal square root of lowest single-precision value, top 3 remain unchanged.
    }

    //Arithmetic int:
    public
    {
        //pavgb - Returns average of 2 values in each of 16 bytes.
        //pavgw - Returns average of 2 values in each of 8 words.
        //psadbw - Returns sum of absolute differences of 16 8bit values. Result in bottom 16 bits.
        //pextrw - Extracts 1 of 8 words.
        //pinsrw - Inserts 1 of 8 words.

        /// pmaxsw - Returns maximum of 2 values in each of 8 signed word values.
        short8 pmaxsw(short8 v1, short8 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.PMAXSW, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_pmaxsw128(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_pmaxsw128(v1, v2);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example:
        unittest
        {
            short8 a = [1, 2, 0, 0, 0, 0, 1, 1];
            short8 b = [10, 20, 0, 0, 0, 0, 0, 1];
            auto c = pmaxsw(a, b);
            assert(c.array == [10, 20, 0, 0, 0, 0, 1, 1]);
        }

        /// pmaxub - Returns maximum of 2 values in each of 16 unsigned byte values.
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

        /// pminsw - Returns minimum of 2 values in each of 8 signed word values.
        short8 pminsw(short8 v1, short8 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.PMINSW, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_pminsw128(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_pminsw128(v1, v2);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example:
        unittest
        {
            short8 a = [1, 2, 0, 0, 0, 0, 1, 1];
            short8 b = [10, 20, 0, 0, 0, 0, 0, 1];
            auto c = pminsw(a, b);
            assert(c.array == [1, 2, 0, 0, 0, 0, 0, 1]);
        }

        /// pminub - Returns minimum of 2 values in each of 16 unsigned byte values.
        byte16 pminub(byte16 v1, byte16 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.PMINUB, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_pminub128(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_pminub128(v1, v2);
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
            auto c = pminub(a, b);
            assert(c.array == [1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]);
        }

        //pmovmskb - builds mask byte from top bit of 8 byte values.
        //pmulhuw - Multiplies 4 unsigned word values and stores the high 16bit result.
        //pshufw - Shuffles 4 word values. Takes 2 128bit values (source and dest) and an 8-bit immediate value, and then fills in each Dest 32-bit value from a Source 32-bit value specified by the immediate. The immediate byte is broken into 4 2-bit values.
    }

    //Logic:
    //andnps - Logically ANDs 4 single-precision values with the logical inverse (NOT) of 4 other single-precision values.
    //andps - Logically ANDs 4 single-precision values with 4 other single-precision values.
    //orps - Logically ORs 4 single-precision values with 4 other single-precision values.
    //xorps - Logically XORs 4 single-precision values with 4 other single-precision values.

    //Compare float:
    public
    {
        /++
        cmpxxps - Compares 4 pairs of 32bit floats.
        eq - Equal to.
        lt - Less than.
        le - Less than or equal to.
        ne - Not equal.
        nlt - Not less than.
        nle - Not less than or equal to.
        ord - Ordered.
        unord - Unordered.
        +/
        int4 cmpeqps(float4 v1, float4 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.CMPPS, v1, v2, CmpPXImm.EQ);
            }
            else version(GNU)
            {
                return __builtin_ia32_cmpeqps(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_cmpps(v1, v2, CmpPXImm.EQ);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example:
        unittest
        {
            float4 a = [float.nan, 4, 1, 1];
            float4 b = [3, 4, 0, 1];
            int4 c = cmpeqps(a, b);
            assert(c.array == [0, -1, 0, -1]);
        }

        /// ditto
        int4 cmpltps(float4 v1, float4 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.CMPPS, v1, v2, CmpPXImm.LT);
            }
            else version(GNU)
            {
                return __builtin_ia32_cmpltps(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_cmpps(v1, v2, CmpPXImm.LT);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example:
        unittest
        {
            float4 a = [float.nan, 4, 0, 1];
            float4 b = [3, 4, 1, 1];
            int4 c = cmpltps(a, b);
            assert(c.array == [0, 0, -1, 0]);
        }

        /// ditto
        int4 cmpleps(float4 v1, float4 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.CMPPS, v1, v2, CmpPXImm.LE);
            }
            else version(GNU)
            {
                return __builtin_ia32_cmpleps(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_cmpps(v1, v2, CmpPXImm.LE);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example:
        unittest
        {
            float4 a = [float.nan, 4, 0, 2];
            float4 b = [3, 4, 0, 1];
            int4 c = cmpleps(a, b);
            assert(c.array == [0, -1, -1, 0]);
        }

        /// ditto
        int4 cmpneqps(float4 v1, float4 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.CMPPS, v1, v2, CmpPXImm.NEQ);
            }
            else version(GNU)
            {
                return __builtin_ia32_cmpneqps(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_cmpps(v1, v2, CmpPXImm.NEQ);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example:
        unittest
        {
            float4 a = [float.nan, 4, 0, 0];
            float4 b = [3, 4, 0, 1];
            int4 c = cmpneqps(a, b);
            assert(c.array == [-1, 0, 0, -1]);
        }

        /// ditto
        int4 cmpnltps(float4 v1, float4 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.CMPPS, v1, v2, CmpPXImm.NLT);
            }
            else version(GNU)
            {
                return __builtin_ia32_cmpnltps(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_cmpps(v1, v2, CmpPXImm.NLT);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example:
        unittest
        {
            float4 a = [float.nan, 4, 0, 2];
            float4 b = [3, 4, 1, 1];
            int4 c = cmpnltps(a, b);
            assert(c.array == [-1, -1, 0, -1]);
        }

        /// ditto
        int4 cmpnleps(float4 v1, float4 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.CMPPS, v1, v2, CmpPXImm.NLE);
            }
            else version(GNU)
            {
                return __builtin_ia32_cmpnleps(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_cmpps(v1, v2, CmpPXImm.NLE);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example:
        unittest
        {
            float4 a = [float.nan, 4, 0, 2];
            float4 b = [3, 5, 0, 1];
            int4 c = cmpnleps(a, b);
            assert(c.array == [-1, 0, 0, -1]);
        }

        /// ditto
        int4 cmpordps(float4 v1, float4 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.CMPPS, v1, v2, CmpPXImm.ORD);
            }
            else version(GNU)
            {
                return __builtin_ia32_cmpordps(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_cmpps(v1, v2, CmpPXImm.ORD);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example:
        unittest
        {
            float4 a = [float.nan, 4, 1, -1];
            float4 b = [3, 4, 0, 1];
            int4 c = cmpordps(a, b);
            assert(c.array == [0, -1, -1, -1]);
        }

        /// ditto
        int4 cmpunordps(float4 v1, float4 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.CMPPS, v1, v2, CmpPXImm.UNORD);
            }
            else version(GNU)
            {
                return __builtin_ia32_cmpunordps(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_cmpps(v1, v2, CmpPXImm.UNORD);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example:
        unittest
        {
            float4 a = [float.nan, 4, float.infinity, 1];
            float4 b = [3, 4, float.infinity, float.nan];
            int4 c = cmpunordps(a, b);
            assert(c.array == [-1, 0, 0, -1]);
        }

        //cmpxxss - Compares lowest 2 single-precision values.
        //comiss - Compares lowest 2 single-recision values and stores result in EFLAGS.
        //ucomiss - Compares lowest 2 single-precision values and stores result in EFLAGS. (QNaNs don't throw exceptions with ucomiss, unlike comiss.)
    }

    //Conversion:
    //cvtpi2ps - Converts 2 32bit integers to 32bit floating-point values. Top 2 values remain unchanged.
    //cvtps2pi - Converts 2 32bit floating-point values to 32bit integers.
    //cvtsi2ss - Converts 1 32bit integer to 32bit floating-point value. Top 3 values remain unchanged.
    //cvtss2si - Converts 1 32bit floating-point value to 32bit integer.
    //cvttps2pi - Converts 2 32bit floating-point values to 32bit integers using truncation.
    //cvttss2si - Converts 1 32bit floating-point value to 32bit integer using truncation.

    //State:
    //fxrstor - Restores FP and SSE State.
    //fxsave - Stores FP and SSE State.
    //ldmxcsr - Loads the mxcsr register.
    //stmxcsr - Stores the mxcsr register.

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

    //Shuffling:
    //shufps - Shuffles 4 single-precision values. Complex.
    //unpckhps - Unpacks single-precision values from high halves.
    //unpcklps - Unpacks single-precision values from low halves.

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

    //Arithmetic double:
    public
    {
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

        //rcpps - Approximates the reciprocal of 4 32bit singles.
        //rcpss - Approximates the reciprocal of bottom 32bit single.
        //sqrtpd - Returns square root of 2 64bit doubles.
        //sqrtsd - Returns square root of bottom 64bit double.
    }

    //Arithmetic int:
    public
    {
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

        /// Example (overflow):
        unittest
        {
            byte16 a = [1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, byte.max];
            byte16 b = [10, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1];
            auto c = paddb(a, b);
            assert(c.array == [11, 22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, byte.min]);
        }

        /// paddw - Adds 8 16bit integers.
        short8 paddw(short8 v1, short8 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.PADDW, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_paddw128(v1, v2);
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

        /// Example (overflow):
        unittest
        {
            short8 a = [1, 2, 0, 0, 0, 0, 0, short.max];
            short8 b = [10, 20, 0, 0, 0, 0, 0, 1];
            auto c = paddw(a, b);
            assert(c.array == [11, 22, 0, 0, 0, 0, 0, short.min]);
        }

        /// paddd - Adds 4 32bit integers.
        int4 paddd(int4 v1, int4 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.PADDD, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_paddd128(v1, v2);
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
            int4 a = [1, 2, 0, 1];
            int4 b = [10, 20, 0, 1];
            auto c = paddd(a, b);
            assert(c.array == [11, 22, 0, 2]);
        }

        /// paddq - Adds 2 64bit integers.
        long2 paddq(long2 v1, long2 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.PADDQ, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_paddq128(v1, v2);
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
            long2 a = [1, 2];
            long2 b = [10, 20];
            auto c = paddq(a, b);
            assert(c.array == [11, 22]);
        }

        /// paddsb - Adds 16 8bit integers with saturation.
        byte16 paddsb(byte16 v1, byte16 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.PADDSB, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_paddsb128(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_paddsb128(v1, v2);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example (saturation):
        unittest
        {
            byte16 a = [1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, byte.max];
            byte16 b = [10, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1];
            auto c = paddsb(a, b);
            assert(c.array == [11, 22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, byte.max]);
        }

        /// paddsw - Adds 8 16bit integers using saturation.
        short8 paddsw(short8 v1, short8 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.PADDSW, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_paddsw128(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_paddsw128(v1, v2);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example (saturarion):
        unittest
        {
            short8 a = [1, 2, 0, 0, 0, 0, 0, short.max];
            short8 b = [10, 20, 0, 0, 0, 0, 0, 1];
            auto c = paddsw(a, b);
            assert(c.array == [11, 22, 0, 0, 0, 0, 0, short.max]);
        }

        /// paddusb - Adds 16 8bit unsigned integers using saturation.
        ubyte16 paddusb(ubyte16 v1, ubyte16 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.PADDUSB, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_paddusb128(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_paddusb128(v1, v2);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example (saturation):
        unittest
        {
            ubyte16 a = [1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ubyte.max];
            ubyte16 b = [10, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1];
            auto c = paddusb(a, b);
            assert(c.array == [11, 22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ubyte.max]);
        }

        /// paddusw - Adds 8 16bit unsigned integers using saturation.
        ushort8 paddusw(ushort8 v1, ushort8 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.PADDUSW, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_paddusw128(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_paddusw128(v1, v2);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example (saturarion):
        unittest
        {
            ushort8 a = [1, 2, 0, 0, 0, 0, 0, ushort.max];
            ushort8 b = [10, 20, 0, 0, 0, 0, 0, 1];
            auto c = paddusw(a, b);
            assert(c.array == [11, 22, 0, 0, 0, 0, 0, ushort.max]);
        }

        /// psubb - Subtracts 16 8bit integers.
        byte16 psubb(byte16 v1, byte16 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.PSUBB, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_psubb128(v1, v2);
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

        /// Example (overflow):
        unittest
        {
            byte16 a = [11, 22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, byte.min];
            byte16 b = [1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1];
            auto c = psubb(a, b);
            assert(c.array == [10, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, byte.max]);
        }

        /// psubw - Subtracts 8 16bit integers.
        short8 psubw(short8 v1, short8 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.PSUBW, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_psubw128(v1, v2);
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

        /// Example (overflow):
        unittest
        {
            short8 a = [11, 22, 0, 0, 0, 0, 0, short.min];
            short8 b = [1, 2, 0, 0, 0, 0, 0, 1];
            auto c = psubw(a, b);
            assert(c.array == [10, 20, 0, 0, 0, 0, 0, short.max]);
        }

        /// psubd - Subtracts 4 32bit integers.
        int4 psubd(int4 v1, int4 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.PSUBD, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_psubd128(v1, v2);
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
            int4 a = [11, 22, 0, 1];
            int4 b = [1, 2, 0, 1];
            auto c = psubd(a, b);
            assert(c.array == [10, 20, 0, 0]);
        }

        /// psubq - Subtracts 2 64bit integers.
        long2 psubq(long2 v1, long2 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.PSUBQ, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_psubq128(v1, v2);
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
            long2 a = [11, 22];
            long2 b = [1, 2];
            auto c = psubq(a, b);
            assert(c.array == [10, 20]);
        }

        /// psubsb - Subtracts 16 8bit integers using saturation.
        byte16 psubsb(byte16 v1, byte16 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.PSUBSB, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_psubsb128(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_psubsb128(v1, v2);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example (saturation):
        unittest
        {
            byte16 a = [11, 22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, byte.min];
            byte16 b = [1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1];
            auto c = psubsb(a, b);
            assert(c.array == [10, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, byte.min]);
        }

        /// psubsw - Subtracts 8 16bit integers using saturation.
        short8 psubsw(short8 v1, short8 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.PSUBSW, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_psubsw128(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_psubsw128(v1, v2);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example (saturarion):
        unittest
        {
            short8 a = [11, 22, 0, 0, 0, 0, 0, short.min];
            short8 b = [1, 2, 0, 0, 0, 0, 0, 1];
            auto c = psubsw(a, b);
            assert(c.array == [10, 20, 0, 0, 0, 0, 0, short.min]);
        }

        /// paddusb - Adds 16 8bit unsigned integers using saturation.
        ubyte16 psubusb(ubyte16 v1, ubyte16 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.PSUBUSB, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_psubusb128(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_psubusb128(v1, v2);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example (saturation):
        unittest
        {
            ubyte16 a = [11, 22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
            ubyte16 b = [1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1];
            auto c = psubusb(a, b);
            assert(c.array == [10, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);
        }

        /// psubusw - Subtracts 8 16bit unsigned integers using saturation.
        ushort8 psubusw(ushort8 v1, ushort8 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.PSUBUSW, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_psubusw128(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_psubusw128(v1, v2);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example (saturarion):
        unittest
        {
            ushort8 a = [11, 22, 0, 0, 0, 0, 0, ushort.min];
            ushort8 b = [1, 2, 0, 0, 0, 0, 0, 1];
            auto c = psubusw(a, b);
            assert(c.array == [10, 20, 0, 0, 0, 0, 0, ushort.min]);
        }

        //pmaddwd - Multiplies 16bit integers into 32bit results and adds results.
        //pmulhw - Multiplies 16bit integers and returns the high 16bits of the result.
        //pmullw - Multiplies 16bit integers and returns the low 16bits of the result.
        //pmuludq - Multiplies 2 32bit pairs and stores 2 64bit results.
    }

    /// pmovmskb - Generates a 16bit Mask from the sign bits of each byte in an XMM register.
    int pmovmskb(byte16 v)
    {
        version(DigitalMars)
        {
            version(none) // Should be like this
                return __simd_scalar(XMM.PMOVMSKB, v);

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

    //Logic:
    public
    {
        version(none) // unsupported by llvm
        /// andnpd - Logically NOT ANDs 2 64bit doubles.
        double2 andnpd(double2 v1, double2 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.ANDNPD, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_andnpd(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_andnpd(v1, v2);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        version(none) // unsupported by llvm
        /// Example:
        unittest
        {
            double2 a = [3, 0];
            double2 b = [3, 4];
            // ~a[i] && b[i]
            auto c = andnpd(a, b);
            assert(c.array == [0, 4]);
        }

        version(none) // unsupported by llvm
        /// andnps - Logically NOT ANDs 4 32bit singles.
        float4 andnps(float4 v1, float4 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.ANDNPS, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_andnps(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_andnps(v1, v2);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        version(none) // unsupported by llvm
        /// Example:
        unittest
        {
            float4 a = [3, 0, 0, 0];
            float4 b = [3, 4, 0, 0];
            // ~a[i] && b[i]
            auto c = andnps(a, b);
            assert(c.array == [0, 4, 0, 0]);
        }

        version(none) // unsupported by llvm
        /// andpd - Logically ANDs 2 64bit doubles.
        double2 andpd(double2 v1, double2 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.ANDPD, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_andpd(v1, v2);
            }
            else version(LDC)
            {
                return v1 & v2;
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        version(none) // unsupported by llvm
        /// Example:
        unittest
        {
            double2 a = [3, 0];
            double2 b = [3, 4];
            auto c = andpd(a, b);
            assert(c.array == [3, 0]);
        }

        //pand - Logically ANDs 2 128bit registers.
        void16 pand(void16 v1, void16 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.PAND, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_pand128(v1, v2);
            }
            else version(LDC)
            {
                return cast(ubyte16)v1 & cast(ubyte16)v2;
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example:
        unittest
        {
            int4 a = [2, 6, 0, 1];
            int4 b = [3, 4, 0, 2];
            int4 c = pand(a, b);
            assert(c.array == [2, 4, 0, 0]);
        }

        version(none) // unsupported by llvm
        //pandn - Logically Inverts the first 128bit operand and ANDs with the second.
        void16 pandn(void16 v1, void16 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.PANDN, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_pandn128(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_pandn(v1, v2);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        version(none) // unsupported by llvm
        /// Example:
        unittest
        {
            int4 a = [2, 6, 0, 1];
            int4 b = [3, 4, 0, 2];
            // ~a[i] && b[i]
            int4 c = pand(a, b);
            assert(c.array == [2, 4, 0, 0]);
        }

        /// por - Logically ORs 2 128bit registers.
        void16 por(void16 v1, void16 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.POR, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_por128(v1, v2);
            }
            else version(LDC)
            {
                return cast(ubyte16)v1 | cast(ubyte16)v2;
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example:
        unittest
        {
            int4 a = [2, 2, 0, 1];
            int4 b = [3, 4, -1, 2];
            int4 c = por(a, b);
            assert(c.array == [3, 6, -1, 3]);
        }

        /// pxor - Logically XORs 2 128bit registers.
        void16 pxor(void16 v1, void16 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.PXOR, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_pxor128(v1, v2);
            }
            else version(LDC)
            {
                return cast(ubyte16)v1 ^ cast(ubyte16)v2;
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example:
        unittest
        {
            int4 a = [2, 2, 0, 1];
            int4 b = [3, 4, -1, 2];
            int4 c = pxor(a, b);
            assert(c.array == [1, 6, -1, 3]);
        }

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

        //orpd - Logically ORs 2 64bit doubles.
        //xorpd - Logically XORs 2 64bit doubles.
    }

    //Compare double:
    public
    {
        /++
        cmpxxpd - Compares 2 pairs of 64bit doubles.
        eq - Equal to.
        lt - Less than.
        le - Less than or equal to.
        ne - Not equal.
        nlt - Not less than.
        nle - Not less than or equal to.
        ord - Ordered.
        unord - Unordered.
        +/
        long2 cmpeqpd(double2 v1, double2 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.CMPPD, v1, v2, CmpPXImm.EQ);
            }
            else version(GNU)
            {
                return __builtin_ia32_cmpeqpd(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_cmppd(v1, v2, CmpPXImm.EQ);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example:
        unittest
        {
            double2 a = [double.nan, 4];
            double2 b = [3, 4];
            long2 c = cmpeqpd(a, b);
            assert(c.array == [0, -1]);
        }

        /// ditto
        long2 cmpltpd(double2 v1, double2 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.CMPPD, v1, v2, CmpPXImm.LT);
            }
            else version(GNU)
            {
                return __builtin_ia32_cmpltpd(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_cmppd(v1, v2, CmpPXImm.LT);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example:
        unittest
        {
            double2 a = [double.nan, 4];
            double2 b = [3, 4];
            long2 c = cmpltpd(a, b);
            assert(c.array == [0, 0]);
        }

        /// ditto
        long2 cmplepd(double2 v1, double2 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.CMPPD, v1, v2, CmpPXImm.LE);
            }
            else version(GNU)
            {
                return __builtin_ia32_cmplepd(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_cmppd(v1, v2, CmpPXImm.LE);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example:
        unittest
        {
            double2 a = [double.nan, 4];
            double2 b = [3, 4];
            long2 c = cmplepd(a, b);
            assert(c.array == [0, -1]);
        }

        /// ditto
        long2 cmpneqpd(double2 v1, double2 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.CMPPD, v1, v2, CmpPXImm.NEQ);
            }
            else version(GNU)
            {
                return __builtin_ia32_cmpneqpd(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_cmppd(v1, v2, CmpPXImm.NEQ);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example:
        unittest
        {
            double2 a = [double.nan, 4];
            double2 b = [3, 4];
            long2 c = cmpneqpd(a, b);
            assert(c.array == [-1, 0]);
        }

        /// ditto
        long2 cmpnltpd(double2 v1, double2 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.CMPPD, v1, v2, CmpPXImm.NLT);
            }
            else version(GNU)
            {
                return __builtin_ia32_cmpnltpd(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_cmppd(v1, v2, CmpPXImm.NLT);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example:
        unittest
        {
            double2 a = [double.nan, 4];
            double2 b = [3, 4];
            long2 c = cmpnltpd(a, b);
            assert(c.array == [-1, -1]);
        }

        /// ditto
        long2 cmpnlepd(double2 v1, double2 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.CMPPD, v1, v2, CmpPXImm.NLE);
            }
            else version(GNU)
            {
                return __builtin_ia32_cmpnlepd(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_cmppd(v1, v2, CmpPXImm.NLE);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example:
        unittest
        {
            double2 a = [double.nan, 4];
            double2 b = [3, 5];
            long2 c = cmpnlepd(a, b);
            assert(c.array == [-1, 0]);
        }

        /// ditto
        long2 cmpordpd(double2 v1, double2 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.CMPPD, v1, v2, CmpPXImm.ORD);
            }
            else version(GNU)
            {
                return __builtin_ia32_cmpordpd(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_cmppd(v1, v2, CmpPXImm.ORD);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example:
        unittest
        {
            double2 a = [double.nan, 4];
            double2 b = [3, 4];
            long2 c = cmpordpd(a, b);
            assert(c.array == [0, -1]);
        }

        /// ditto
        long2 cmpunordpd(double2 v1, double2 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.CMPPD, v1, v2, CmpPXImm.UNORD);
            }
            else version(GNU)
            {
                return __builtin_ia32_cmpunordpd(v1, v2);
            }
            else version(LDC)
            {
                return __builtin_ia32_cmppd(v1, v2, CmpPXImm.UNORD);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }

        /// Example:
        unittest
        {
            double2 a = [double.nan, 4];
            double2 b = [3, 4];
            long2 c = cmpunordpd(a, b);
            assert(c.array == [-1, 0]);
        }

        //cmpsd - Compares bottom 64bit doubles.
        //comisd - Compares bottom 64bit doubles and stores result in EFLAGS.
        //ucomisd - Compares bottom 64bit doubles and stores result in EFLAGS. (QNaNs don't throw exceptions with ucomisd, unlike comisd.
    }

    //Compare int types:
    public
    {
        /++
        pcmpxxb - Compares 16 8bit integers.
        pcmpxxw - Compares 8 16bit integers.
        pcmpxxd - Compares 4 32bit integers.
        Compare Codes (the xx parts above):
            eq - Equal to.
            gt - greater than.
        +/
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

        /// ditto
        byte16 pcmpgtb(byte16 v1, byte16 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.PCMPGTB, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_pcmpgtb128(v1, v2);
            }
            else version(LDC)
            {
                return greaterMask!byte16(v1, v2);
            }
            else
            {
                static assert(0, "Unsupported on this architecture");
            }
        }

        /// Example:
        unittest
        {
            byte16 a = [2, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1];
            byte16 b = [1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1];
            auto c = pcmpgtb(a, b);
            assert(c.array == [-1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);
        }

        /// ditto
        short8 pcmpeqw(short8 v1, short8 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.PCMPEQW, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_pcmpeqw128(v1, v2);
            }
            else version(LDC)
            {
                return equalMask!short8(v1, v2);
            }
            else
            {
                static assert(0, "Unsupported on this architecture");
            }
        }

        /// Example:
        unittest
        {
            short8 a = [1, 2, 1, 1, 1, 1, 1, 1];
            short8 b = [1, 2, 0, 0, 0, 0, 0, 1];
            auto c = pcmpeqw(a, b);
            assert(c.array == [-1, -1, 0, 0, 0, 0, 0, -1]);
        }

        /// ditto
        short8 pcmpgtw(short8 v1, short8 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.PCMPGTW, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_pcmpgtw128(v1, v2);
            }
            else version(LDC)
            {
                return greaterMask!short8(v1, v2);
            }
            else
            {
                static assert(0, "Unsupported on this architecture");
            }
        }

        /// Example:
        unittest
        {
            short8 a = [2, 3, 0, 0, 0, 0, 0, 1];
            short8 b = [1, 2, 0, 0, 0, 0, 0, 1];
            auto c = pcmpgtw(a, b);
            assert(c.array == [-1, -1, 0, 0, 0, 0, 0, 0]);
        }

        /// ditto
        int4 pcmpeqd(int4 v1, int4 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.PCMPEQD, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_pcmpeqd128(v1, v2);
            }
            else version(LDC)
            {
                return equalMask!int4(v1, v2);
            }
            else
            {
                static assert(0, "Unsupported on this architecture");
            }
        }

        /// Example:
        unittest
        {
            int4 a = [1, 2, 1, 1];
            int4 b = [1, 2, 0, 1];
            auto c = pcmpeqd(a, b);
            assert(c.array == [-1, -1, 0, -1]);
        }

        /// ditto
        int4 pcmpgtd(int4 v1, int4 v2)
        {
            version(DigitalMars)
            {
                return __simd(XMM.PCMPGTD, v1, v2);
            }
            else version(GNU)
            {
                return __builtin_ia32_pcmpgtd128(v1, v2);
            }
            else version(LDC)
            {
                return greaterMask!int4(v1, v2);
            }
            else
            {
                static assert(0, "Unsupported on this architecture");
            }
        }

        /// Example:
        unittest
        {
            int4 a = [2, 3, 0, 1];
            int4 b = [1, 2, 0, 1];
            auto c = pcmpgtd(a, b);
            assert(c.array == [-1, -1, 0, 0]);
        }
    }

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

    //Cache Control:
    //clflush - Flushes a Cache Line from all levels of cache.
    //lfence - Guarantees that all memory loads issued before the lfence instruction are completed before anyloads after the lfence instruction.
    //mfence - Guarantees that all memory reads and writes issued before the mfence instruction are completed before any reads or writes after the mfence instruction.
    //pause - Pauses execution for a set amount of time.

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

                r3 = sse.pmaxub(r1, r3);
                r4 = sse.pmaxub(r2, r4);
                r4 = sse.pmaxub(r3, r4);
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

/// Namespace for sse3 intrinsics
struct sse3
{
    //Arithmetic:
    //addsubpd - Adds the top two doubles and subtracts the bottom two.
    //addsubps - Adds top singles and subtracts bottom singles.
    //haddpd - Top double is sum of top and bottom, bottom double is sum of second operand's top and bottom.
    //haddps - Horizontal addition of single-precision values.
    //hsubpd - Horizontal subtraction of double-precision values.
    //hsubps - Horizontal subtraction of single-precision values.

    //Load/Store:
    //lddqu - Loads an unaligned 128bit value.
    //movddup - Loads 64bits and duplicates it in the top and bottom halves of a 128bit register.
    //movshdup - Duplicates the high singles into high and low singles.
    //movsldup - Duplicates the low singles into high and low singles.
    //fisttp - Converts a floating-point value to an integer using truncation.
    //
    //Process Control:
    //monitor - Sets up a region to monitor for activity.
    //mwait - Waits until activity happens in a region specified by monitor.

}

/// Namespace for ssse3 intrinsics
struct s_sse3
{
    //Arithmetic:
    //psignd - Gives 32bit integer magnitudes the sign of the 2nd operand.
    //psignw - Gives 16bit integer magnitudes the sign of the 2nd operand.
    //psignb - Gives 8bit integer magnitudes the sign of the 2nd operand.
    //phaddd - Horizontal addition of unsigned 32bit integers.
    //phaddw - Horizontal addition of unsigned 16bit integers.
    //phaddsw - Horizontal saturated addition of 16bit integers.
    //phsubd - Horizontal subtraction of unsigned 32bit integers.
    //phsubw - Horizontal subtraction of unsigned 16bit integers.
    //phsubsw - Horizontal saturated subtraction of 16bit words.
    //pmaddubsw - Multiply-accumulate instruction (finally).
    //pabsd - abs() for 32bit integers.
    //pabsw - abs() for 16bit integers.
    //pabsb - abs() for 8bit integers.
    //pmulhrsw - 16bit integer multiplication, stores top 16bits of result.
    //pshufb - Another complex shuffle instruction.
    //palignr - Combines two register values, and extracts a register-width value from it, based on an offset.

}

/// Namespace for sse4.1 intrinsics
struct sse4_1
{
static:
    //mpsadbw - Sum of absolute differences.
    //phminposuw - minimum+index extraction (16bit word).
    //pmuldq - packed multiply.
    //pmulld - packed multiply.
    //dpps - dot product, single precision.
    //dppd - dot product, double precision.
    //blendps - conditional copy.
    //blendpd - conditional copy.
    //blendvps - conditional copy.
    //blendvpd - conditional copy.

    /// pblendvb - conditional copy: res[i] = mask[i] ? v[2] : v[1].
    byte16 pblendvb(byte16 v1, byte16 v2, byte16 mask)
    {
        version(DigitalMars)
        {
            version(none)
                return __simd(XMM.PBLENDVB, v2, v1, mask);
            return sse2.pxor(v1, sse2.pand(mask, sse2.pxor(v1, v2)));
        }
        else version(GNU)
        {
            return __builtin_ia32_pblendvb128(v2, v1, mask);
        }
        else version(LDC)
        {
            return __builtin_ia32_pblendvb128(v2, v1, mask);
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    /// Example:
    unittest
    {
        int4 a = [2, 2, 1, 1];
        int4 b = [3, 4, 5, 2];
        int4 mask = [0, 0, -1, 0];
        int4 c = pblendvb(a, b, mask);
        assert(c.array == [2, 2, 5, 1]);
    }

    //pblendw - conditional copy.
    //pminsb - packed minimum signed byte.
    //pmaxsb - packed maximum signed byte.
    //pminuw - packed minimum unsigned word.
    //pmaxuw - packed maximum unsigned word.
    //pminud - packed minimum unsigned dword.
    //pmaxud - packed maximum unsigned dword.
    //pminsd - packed minimum signed dword.
    //pmaxsd - packed maximum signed dword.
    //roundps - packed round single precision float to integer.
    //roundss - scalar round single precision float to integer.
    //roundpd - packed round double precision float to integer.
    //roundsd - scalar round double precision float to integer.
    //insertps - complex data shuffling.
    //pinsrb - complex data shuffling.
    //pinsrd - complex data shuffling.
    //pinsrq - complex data shuffling.
    //extractps - complex data shuffling.
    //pextrb - complex data shuffling.
    //pextrw - complex data shuffling.
    //pextrd - complex data shuffling.
    //pextrq - complex data shuffling.
    //pmovsxbw - packed sign extension.
    //pmovzxbw - packed zero extension.
    //pmovsxbd - packed sign extension.
    //pmovzxbd - packed zero extension.
    //pmovsxbq - packed sign extension.
    //pmovzxbq - packed zero extension.
    //pmovxswd - packed sign extension.
    //pmovzxwd - packed zero extension.
    //pmovsxwq - packed sign extension.
    //pmovzxwq - packed zero extension.
    //pmovsxdq - packed sign extension.
    //pmovzxdq - packed zero extension.
    //ptest - same as test, but for sse registers.

    /// pcmpeqq - quadword compare for equality.
    byte16 pcmpeqq(long2 v1, long2 v2)
    {
        version(DigitalMars)
        {
            return __simd(XMM.PCMPEQQ, v1, v2);
        }
        else version(GNU)
        {
            return __builtin_ia32_pcmpeqq(v1, v2);
        }
        else version(LDC)
        {
            return equalMask!long2(v1, v2);
        }
        else
        {
            static assert(0, "Unsupported on this architecture");
        }
    }

    //packusdw - saturating signed dwords to unsigned words.
    //movntdqa - Non-temporal aligned move (this uses write-combining for efficiency).

}

/// Namespace for sse4.2 intrinsics
struct sse4_2
{
    //crc32 - CRC32C function (using 0x11edc6f41 as the polynomial).
    //pcmpestri - Packed compare explicit length string, Index.
    //pcmpestrm - Packed compare explicit length string, Mask.
    //pcmpistri - Packed compare implicit length string, Index.
    //pcmpistrm - Packed compare implicit length string, Mask.
    //pcmpgtq - Packed compare, greater than.
    //popcnt - Population count.
}

/// Namespace for sse4a intrinsics
struct sse4a
{
    //lzcnt - Leading Zero count.
    //popcnt - Population count.
    //extrq - Mask-shift operation.
    //inserq - Mask-shift operation.
    //movntsd - Non-temporal double precision move.
    //movntss - Non-temporal single precision move.
}
