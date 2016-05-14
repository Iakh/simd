/++
Architecture independent high level SIMD wrapers.
+/
module iakh.simd;

import std.algorithm;
import std.range;
import std.traits : isSIMDVector, Signed, isSigned, isUnsigned;

import iakh.simd.x86;
import iakh.simd._version;

static if (simdArch == simdArch.X86)
{
    version = X86_SIMD;
}

private alias ElemOf(Vec : __vector(T[N]), T, size_t N) = T;
private alias LengthOf(Vec : __vector(T[N]), T, size_t N) = N;

version(GNU)
{
    import std.typetuple : staticIndexOf;
    private enum isInSet(T, TSet...) = staticIndexOf!(T, TSet) != -1;
}
else
{
    import std.meta : staticIndexOf;
    private enum isInSet(T, TSet...) = staticIndexOf!(T, TSet) != -1;
}

/++
This function represents simdVec as ordinal array.
It is introdused as workaround to DCD compiler bug with Vec.array[].
+/
private auto vecToArray(T)(ref T simdVec)
{
    version (GNU)
    {
        return simdVec.ptr[0 .. LengthOf!(T)];
    }
    else
    {
        return simdVec.array[];
    }
}

// Cmp mask double
public
{
    auto maskLess(double2 a, double2 b)
    {
        version (X86_SIMD)
        {
            return Mask128Bit!long(sse2.cmpltpd(a, b));
        }
        else
        {
            double2 res;
            res.array = zip(a.vecToArray, b.vecToArray).map!"a[0] < a[1]";
            return res;
        }
    }

    auto maskEqual(double2 a, double2 b)
    {
        version (X86_SIMD)
        {
            return Mask128Bit!long(sse2.cmpeqpd(a, b));
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    auto maskLessOrEqual(double2 a, double2 b)
    {
        version (X86_SIMD)
        {
            return Mask128Bit!long(sse2.cmplepd(a, b));
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    auto maskNotLess(double2 a, double2 b)
    {
        version (X86_SIMD)
        {
            return Mask128Bit!long(sse2.cmpnltpd(a, b));
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    auto maskNotEqual(double2 a, double2 b)
    {
        version (X86_SIMD)
        {
            return Mask128Bit!long(sse2.cmpneqpd(a, b));
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    auto maskNotLessOrEqual(double2 a, double2 b)
    {
        version (X86_SIMD)
        {
            return Mask128Bit!long(sse2.cmpnlepd(a, b));
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

}

// Cmp mask float
public
{
    auto maskLess(float4 a, float4 b)
    {
        version (X86_SIMD)
        {
            return Mask128Bit!long(sse.cmpltps(a, b));
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    auto maskEqual(float4 a, float4 b)
    {
        version (X86_SIMD)
        {
            return Mask128Bit!long(sse2.cmpeqpd(a, b));
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    auto maskLessOrEqual(float4 a, float4 b)
    {
        version (X86_SIMD)
        {
            return Mask128Bit!long(sse2.cmplepd(a, b));
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    auto maskNotLess(float4 a, float4 b)
    {
        version (X86_SIMD)
        {
            return Mask128Bit!long(sse2.cmpnltpd(a, b));
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    auto maskNotEqual(float4 a, float4 b)
    {
        version (X86_SIMD)
        {
            return Mask128Bit!long(sse2.cmpneqpd(a, b));
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    auto maskNotLessOrEqual(float4 a, float4 b)
    {
        version (X86_SIMD)
        {
            return Mask128Bit!long(sse2.cmpnlepd(a, b));
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

}

// Cmp mask integral
public
{
    Mask128Bit!byte maskEqual(byte16 a, byte16 b)
    {
        version (X86_SIMD)
        {
            return Mask128Bit!byte(sse2.pcmpeqb(a, b));
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    Mask128Bit!short maskEqual(short8 a, short8 b)
    {
        version (X86_SIMD)
        {
            return Mask128Bit!short(sse2.pcmpeqw(a, b));
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    Mask128Bit!int maskEqual(int4 a, int4 b)
    {
        version (X86_SIMD)
        {
            return Mask128Bit!int(sse2.pcmpeqd(a, b));
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    Mask128Bit!long maskEqual(long2 a, long2 b)
    {
        version (X86_SIMD)
        {
            static if (x86SIMDVersion >= X86SIMDVersion.SSE4_1)
            {
                return Mask128Bit!long(sse4_1.pcmpeqq(a, b));
            }
            else static if (x86SIMDVersion >= X86SIMDVersion.SSE2)
            {
                long2 res;
                zip(a.vecToArray, b.vecToArray).map!"(a[0] != a[1]) - 1".copy(res.vecToArray);
                return Mask128Bit!long(res);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    Mask128Bit!byte maskGreater(byte16 a, byte16 b)
    {
        version (X86_SIMD)
        {
            return Mask128Bit!byte(sse2.pcmpgtb(a, b));
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    Mask128Bit!short maskGreater(short8 a, short8 b)
    {
        version (X86_SIMD)
        {
            return Mask128Bit!short(sse2.pcmpgtw(a, b));
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    Mask128Bit!int maskGreater(int4 a, int4 b)
    {
        version (X86_SIMD)
        {
            return Mask128Bit!int(sse2.pcmpgtd(a, b));
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    Mask128Bit!long maskGreater(long2 a, long2 b)
    {
        version (X86_SIMD)
        {
            static if (x86SIMDVersion >= X86SIMDVersion.SSE4_1)
            {
                return Mask128Bit!long(sse4_2.pcmpgtq(a, b));
            }
            else static if (x86SIMDVersion >= X86SIMDVersion.SSE2)
            {
                long2 res;
                zip(a.vecToArray, b.vecToArray).map!"(a[0] <= a[1]) - 1".copy(res.vecToArray);
                return Mask128Bit!long(res);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    Mask128Bit!byte maskLess(byte16 a, byte16 b)
    {
        version (X86_SIMD)
        {
            return maskGreater(b, a);
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    Mask128Bit!short maskLess(short8 a, short8 b)
    {
        version (X86_SIMD)
        {
            return maskGreater(b, a);
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    Mask128Bit!int maskLess(int4 a, int4 b)
    {
        version (X86_SIMD)
        {
            return maskGreater(b, a);
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    Mask128Bit!long maskLess(long2 a, long2 b)
    {
        version (X86_SIMD)
        {
            static if (x86SIMDVersion >= X86SIMDVersion.SSE4_1)
            {
                return maskGreater(b, a);
            }
            else static if (x86SIMDVersion >= X86SIMDVersion.SSE2)
            {
                long2 res;
                zip(a.vecToArray, b.vecToArray).map!"(a[0] >= a[1]) - 1".copy(res.vecToArray);
                return Mask128Bit!long(res);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    Mask128Bit!byte maskLessOrEqual(byte16 a, byte16 b)
    {
        version (X86_SIMD)
        {
            return ~maskGreater(a, b);
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    Mask128Bit!short maskLessOrEqual(short8 a, short8 b)
    {
        version (X86_SIMD)
        {
            return ~maskGreater(a, b);
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    Mask128Bit!int maskLessOrEqual(int4 a, int4 b)
    {
        version (X86_SIMD)
        {
            return ~maskGreater(a, b);
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    Mask128Bit!long maskLessOrEqual(long2 a, long2 b)
    {
        version (X86_SIMD)
        {
            static if (x86SIMDVersion >= X86SIMDVersion.SSE4_1)
            {
                return ~maskGreater(a, b);
            }
            else static if (x86SIMDVersion >= X86SIMDVersion.SSE2)
            {
                long2 res;
                zip(a.vecToArray, b.vecToArray).map!"(a[0] > a[1]) - 1".copy(res.vecToArray);
                return Mask128Bit!long(res);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    Mask128Bit!byte maskGreaterOrEqual(byte16 a, byte16 b)
    {
        version (X86_SIMD)
        {
            return ~maskGreater(b, a);
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    Mask128Bit!short maskGreaterOrEqual(short8 a, short8 b)
    {
        version (X86_SIMD)
        {
            return ~maskGreater(b, a);
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    Mask128Bit!int maskGreaterOrEqual(int4 a, int4 b)
    {
        version (X86_SIMD)
        {
            return ~maskGreater(b, a);
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    Mask128Bit!long maskGreaterOrEqual(long2 a, long2 b)
    {
        version (X86_SIMD)
        {
            static if (x86SIMDVersion >= X86SIMDVersion.SSE4_1)
            {
                return ~maskGreater(b, a);
            }
            else static if (x86SIMDVersion >= X86SIMDVersion.SSE2)
            {
                long2 res;
                zip(a.vecToArray, b.vecToArray).map!"(a[0] < a[1]) - 1".copy(res.vecToArray);
                return Mask128Bit!long(res);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    Mask128Bit!byte maskNotEqual(byte16 a, byte16 b)
    {
        version (X86_SIMD)
        {
            return ~maskEqual(a, b);
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    Mask128Bit!short maskNotEqual(short8 a, short8 b)
    {
        version (X86_SIMD)
        {
            return ~maskEqual(a, b);
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    Mask128Bit!int maskNotEqual(int4 a, int4 b)
    {
        version (X86_SIMD)
        {
            return ~maskEqual(a, b);
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    Mask128Bit!long maskNotEqual(long2 a, long2 b)
    {
        version (X86_SIMD)
        {
            static if (x86SIMDVersion >= X86SIMDVersion.SSE4_1)
            {
                return ~maskEqual(a, b);
            }
            else static if (x86SIMDVersion >= X86SIMDVersion.SSE2)
            {
                long2 res;
                zip(a.vecToArray, b.vecToArray).map!"(a[0] == a[1]) - 1".copy(res.vecToArray);
                return Mask128Bit!long(res);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

}

version (unittest)
{
    struct TTestRow(ArrayT)
    {
        ArrayT a;
        ArrayT b;
        ArrayT maskEqual;
        ArrayT maskNotEqual;
        ArrayT maskGreater;
        ArrayT maskGreaterOrEqual;
        ArrayT maskLess;
        ArrayT maskLessOrEqual;
    }

    void testMaskT(Int, Vec, Array)(TTestRow!Array[] data)
    {
        static ref Vec toVec(ref Array a)
        {
            return *cast(Vec*)a.ptr;
        }

        foreach (row; data)
        {
            Vec v1 = toVec(row.a);
            Vec v2 = toVec(row.b);
            assert(maskEqual(v1, v2).pack == Mask128Bit!Int(toVec(row.maskEqual)).pack);
            assert(maskNotEqual(v1, v2).pack == Mask128Bit!Int(toVec(row.maskNotEqual)).pack);
            assert(maskGreater(v1, v2).pack == Mask128Bit!Int(toVec(row.maskGreater)).pack);
            assert(maskGreaterOrEqual(v1, v2).pack == Mask128Bit!Int(toVec(row.maskGreaterOrEqual)).pack);
            assert(maskLess(v1, v2).pack == Mask128Bit!Int(toVec(row.maskLess)).pack);
            assert(maskLessOrEqual(v1, v2).pack == Mask128Bit!Int(toVec(row.maskLessOrEqual)).pack);
        }

    }

    // byte
    unittest
    {
        enum arraySize = 16;
        alias Int = byte;
        alias Array = Int[arraySize];
        alias TestRow = TTestRow!(Array);
        alias vec = __vector(Array);
        enum Int T = -1;
        enum Int F = 0;

        TestRow[] data = [
        {
            a :                     [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            b :                     [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            maskEqual :             [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
            maskNotEqual :          [F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F],
            maskGreater :           [F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F],
            maskGreaterOrEqual :    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
            maskLess :              [F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F],
            maskLessOrEqual :       [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T]
        }
        , {
            a :                     [1, 5, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, -5, 0, Int.max, Int.min],
            b :                     [8, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 19, -1, Int.min, Int.max],
            maskEqual :             [F, T, F, T, T, T, T, T, T, T, T, T, F, F, F, F],
            maskNotEqual :          [T, F, T, F, F, F, F, F, F, F, F, F, T, T, T, T],
            maskGreater :           [F, F, T, F, F, F, F, F, F, F, F, F, F, T, T, F],
            maskGreaterOrEqual :    [F, T, T, T, T, T, T, T, T, T, T, T, F, T, T, F],
            maskLess :              [T, F, F, F, F, F, F, F, F, F, F, F, T, F, F, T],
            maskLessOrEqual :       [T, T, F, T, T, T, T, T, T, T, T, T, T, F, F, T]
        }
        ];

        testMaskT!(Int, vec, Array)(data);
    }

    // short
    unittest
    {
        enum arraySize = 8;
        alias Int = short;
        alias Array = Int[arraySize];
        alias TestRow = TTestRow!(Array);
        alias vec = __vector(Array);
        enum Int T = -1;
        enum Int F = 0;

        TestRow[] data = [
        {
            a :                     [0, 0, 0, 0, 0, 0, 0, 0],
            b :                     [0, 0, 0, 0, 0, 0, 0, 0],
            maskEqual :             [T, T, T, T, T, T, T, T],
            maskNotEqual :          [F, F, F, F, F, F, F, F],
            maskGreater :           [F, F, F, F, F, F, F, F],
            maskGreaterOrEqual :    [T, T, T, T, T, T, T, T],
            maskLess :              [F, F, F, F, F, F, F, F],
            maskLessOrEqual :       [T, T, T, T, T, T, T, T]
        }
        , {
            a :                     [1, 5, 9, 0, -5, 0, Int.max, Int.min],
            b :                     [8, 5, 0, 0, 19, -1, Int.min, Int.max],
            maskEqual :             [F, T, F, T, F, F, F, F],
            maskNotEqual :          [T, F, T, F, T, T, T, T],
            maskGreater :           [F, F, T, F, F, T, T, F],
            maskGreaterOrEqual :    [F, T, T, T, F, T, T, F],
            maskLess :              [T, F, F, F, T, F, F, T],
            maskLessOrEqual :       [T, T, F, T, T, F, F, T]
        }
        ];

        testMaskT!(Int, vec, Array)(data);
    }

    // int
    unittest
    {
        enum arraySize = 4;
        alias Int = int;
        alias Array = Int[arraySize];
        alias TestRow = TTestRow!(Array);
        alias vec = __vector(Array);
        enum Int T = -1;
        enum Int F = 0;

        TestRow[] data = [
        {
            a :                     [0, 0, 0, 0],
            b :                     [0, 0, 0, 0],
            maskEqual :             [T, T, T, T],
            maskNotEqual :          [F, F, F, F],
            maskGreater :           [F, F, F, F],
            maskGreaterOrEqual :    [T, T, T, T],
            maskLess :              [F, F, F, F],
            maskLessOrEqual :       [T, T, T, T]
        }
        , {
            a :                     [-5, 0, Int.max, Int.min],
            b :                     [19, -1, Int.min, Int.max],
            maskEqual :             [F, F, F, F],
            maskNotEqual :          [T, T, T, T],
            maskGreater :           [F, T, T, F],
            maskGreaterOrEqual :    [F, T, T, F],
            maskLess :              [T, F, F, T],
            maskLessOrEqual :       [T, F, F, T]
        }
        , {
            a :                     [1, 5, 9, 0],
            b :                     [8, 5, 0, 0],
            maskEqual :             [F, T, F, T],
            maskNotEqual :          [T, F, T, F],
            maskGreater :           [F, F, T, F],
            maskGreaterOrEqual :    [F, T, T, T],
            maskLess :              [T, F, F, F],
            maskLessOrEqual :       [T, T, F, T]
        }
        ];

        testMaskT!(Int, vec, Array)(data);
    }

    // long
    unittest
    {
        enum arraySize = 2;
        alias Int = long;
        alias Array = Int[arraySize];
        alias TestRow = TTestRow!(Array);
        alias vec = __vector(Array);
        enum Int T = -1;
        enum Int F = 0;

        TestRow[] data = [
        {
            a :                     [0, 0],
            b :                     [0, 0],
            maskEqual :             [T, T],
            maskNotEqual :          [F, F],
            maskGreater :           [F, F],
            maskGreaterOrEqual :    [T, T],
            maskLess :              [F, F],
            maskLessOrEqual :       [T, T]
        }
        , {
            a :                     [Int.max, Int.min],
            b :                     [Int.min, Int.max],
            maskEqual :             [F, F],
            maskNotEqual :          [T, T],
            maskGreater :           [T, F],
            maskGreaterOrEqual :    [T, F],
            maskLess :              [F, T],
            maskLessOrEqual :       [F, T]
        }
        , {
            a :                     [-5, 0],
            b :                     [19, -1],
            maskEqual :             [F, F],
            maskNotEqual :          [T, T],
            maskGreater :           [F, T],
            maskGreaterOrEqual :    [F, T],
            maskLess :              [T, F],
            maskLessOrEqual :       [T, F]
        }
        , {
            a :                     [9, 0],
            b :                     [0, 0],
            maskEqual :             [F, T],
            maskNotEqual :          [T, F],
            maskGreater :           [T, F],
            maskGreaterOrEqual :    [T, T],
            maskLess :              [F, F],
            maskLessOrEqual :       [F, T]
        }
        , {
            a :                     [1, 5],
            b :                     [8, 5],
            maskEqual :             [F, T],
            maskNotEqual :          [T, F],
            maskGreater :           [F, F],
            maskGreaterOrEqual :    [F, T],
            maskLess :              [T, F],
            maskLessOrEqual :       [T, T]
        }
        ];

        testMaskT!(Int, vec, Array)(data);
    }
}

// Cmp mask unsigned
public
{
    Mask128Bit!byte maskEqual(ubyte16 a, ubyte16 b)
    {
        version (X86_SIMD)
        {
            return Mask128Bit!byte(sse2.pcmpeqb(a, b));
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    Mask128Bit!short maskEqual(ushort8 a, ushort8 b)
    {
        version (X86_SIMD)
        {
            return Mask128Bit!short(sse2.pcmpeqw(a, b));
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    Mask128Bit!int maskEqual(uint4 a, uint4 b)
    {
        version (X86_SIMD)
        {
            return Mask128Bit!int(sse2.pcmpeqd(a, b));
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    Mask128Bit!long maskEqual(ulong2 a, ulong2 b)
    {
        version (X86_SIMD)
        {
            static if (x86SIMDVersion >= X86SIMDVersion.SSE4_1)
            {
                return Mask128Bit!long(sse4_1.pcmpeqq(a, b));
            }
            else static if (x86SIMDVersion >= X86SIMDVersion.SSE2)
            {
                long2 res;
                zip(a.vecToArray, b.vecToArray).map!"(a[0] != a[1]) - 1".copy(res.vecToArray);
                return Mask128Bit!long(res);
            }
            else
            {
                static assert(false, "Unsupported on this architecture");
            }
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

}

/++
Mask represents result of some SIMD operations such as comparison.
Each element of mask represents true or false.
+/
struct Mask128Bit(TInt)
    if (isInSet!(TInt, byte, short, int, long))
{
    enum size = 16;
    enum length = size / TInt.sizeof;
    enum log2SizeOfT = log2SizeOf!TInt();
    alias ThisType = typeof(this);
    alias BaseVector = Vector!(TInt[length]);
    BaseVector vector;

    /// Build Mask128Bit from bool range
    this(Range)(Range range)
        if (isInputRange!Range && is(ElementType!Range == bool) && hasLangth!Range)
    {
        assert(range.length == length);

        foreach(i, v; range.takeExactly(length).enumerate)
        {
            this[i] = v;
        }
    }

    /// Build Mask128Bit from bit mask
    this(ushort bitMask)
    {
        enum EndBit = 2 ^^ length;
        assert(bitMask < EndBit, "Parameter bitMask shoud set only Mask.length first bits");

        for (int it = 1, i = 0; it < EndBit; ++i, it <<= 1)
        {
            this[i] = cast(bool)(bitMask & it);
        }
    }

    unittest
    {
        enum EndBit = 2 ^^ length;
        ushort mask = EndBit - 1;
        auto m = ThisType(mask);
        assert(m.all);
        m = ThisType(0);
        assert(!m.any);
        m = ThisType(2);
        assert(m.any);
    }

    bool any()
    {
        version (X86_SIMD)
        {
            return cast(bool)pack();
        }
        else
        {
            static assert(false, "Unsupported by this compiler");
        }
    }

    /// Example
    unittest
    {
        auto b = Mask128Bit!int(int4([0, 0, 0, 0]));
        assert(!b.any);
        b = Mask128Bit!int(int4([0, -1, 0, 0]));
        assert(b.any);
    }

    bool all()
    {
        version (X86_SIMD)
        {
            enum int maskAll = (1 << 16) - 1;
            return pack() == maskAll;
        }
        else
        {
            static assert(false, "Unsupported by this compiler");
        }
    }

    /// Example
    unittest
    {
        auto b = Mask128Bit!int(int4([0, 0, 0, 0]));
        assert((~b).all);
        b = Mask128Bit!int(int4([0, -1, 0, 0]));
        assert(!(~b).all);
    }

    bool isFront()
    {
        version (X86_SIMD)
        {
            enum maskFront = 1;
            return cast(bool)(pack() & maskFront);
        }
        else
        {
            static assert(false, "Unsupported by this compiler");
        }
    }

    bool isBack()
    {
        version (X86_SIMD)
        {
            enum maskBack = 1 << 15;
            return cast(bool)(pack() & maskBack);
        }
        else
        {
            static assert(false, "Unsupported by this compiler");
        }
    }

    int indexOfFirst()
    {
        version (X86_SIMD)
        {
            import core.bitop;

            int mask = pack();

            if (mask)
            {
                return bsf(mask) >> log2SizeOfT;
            }
            else
            {
                return -1;
            }
        }
        else
        {
            static assert(false, "Unsupported by this compiler");
        }
    }

    int indexOfLast()
    {
        version (X86_SIMD)
        {
            import core.bitop;

            int mask = pack();

            if (mask)
            {
                return bsr(mask) >> log2SizeOfT;
            }
            else
            {
                return -1;
            }
        }
        else
        {
            static assert(false, "Unsupported by this compiler");
        }

    }

    int count()
    {
        version (X86_SIMD)
        {
            import core.bitop;
            return popcnt(pack()) >> log2SizeOfT;
        }
        else
        {
            static assert(false, "Unsupported by this compiler");
        }

    }

    Mask128Bit!TInt opUnary(string op : "~")()
    {
        return Mask128Bit!TInt(~vector);
    }

    unittest
    {
        auto a = Mask128Bit!byte(byte16([-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]));
        auto b = Mask128Bit!byte(byte16([0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]));
        assert(~a == b);
        /*a = Mask128Bit!byte(byte16([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1]));
        b = Mask128Bit!byte(byte16([-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 0]));
        assert(~a == b);
        a = Mask128Bit!byte(byte16([0, 0, 0, -1, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, -1]));
        b = Mask128Bit!byte(byte16([-1, -1, -1, 0, -1, -1, 0, 0, -1, -1, -1, -1, -1, -1, -1, 0]));
        assert(~a == b);
        a = Mask128Bit!byte(byte16([-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]));
        b = Mask128Bit!byte(byte16([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]));
        assert(~a == b);*/
    }

    Mask128Bit!TInt opBinary(string op)(Mask128Bit!TInt b)
    {
        static if (op == "|") return Mask128Bit!TInt(vector | b.vector);
        else static if (op == "&") return Mask128Bit!TInt(vector & b.vector);
        else static if (op == "^") return Mask128Bit!TInt(vector ^ b.vector);
        else static assert(false, "Unsupported operation " ~ op);
    }

    unittest
    {
        auto a = Mask128Bit!byte(byte16([-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]));
        auto b = Mask128Bit!byte(byte16([0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]));
        assert((a | b).all);
        assert(!(a & b).any);
        assert((a ^ b).all);

        a = Mask128Bit!byte(byte16([0, 0, -1, -1, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, -1]));
        b = Mask128Bit!byte(byte16([-1, -1, -1, 0, -1, -1, 0, 0, -1, -1, 0, -1, -1, -1, -1, 0]));
        assert((a | b).any);
        assert((a & b).any);
        assert((a ^ b).any);
    }

    Mask128Bit!TInt opOpAssign(string op)(Mask128Bit!TInt b)
    {
        static if (op == "|") return Mask128Bit!TInt(vector |= b.vector);
        else static if (op == "&") return Mask128Bit!TInt(vector &= b.vector);
        else static if (op == "^") return Mask128Bit!TInt(vector ^= b.vector);
        else static assert(false, "Unsupported operation " ~ op);
    }

    unittest
    {
        auto a = Mask128Bit!byte(byte16([-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]));
        auto b = Mask128Bit!byte(byte16([0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]));
        auto tmp = a;
        assert((a |= b).all);
        a = tmp;
        assert(!(a &= b).any);
        a = tmp;
        assert((a ^= b).all);

        a = Mask128Bit!byte(byte16([0, 0, -1, -1, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, -1]));
        b = Mask128Bit!byte(byte16([-1, -1, -1, 0, -1, -1, 0, 0, -1, -1, 0, -1, -1, -1, -1, 0]));
        tmp = a;
        assert((a |= b).any);
        a = tmp;
        assert((a &= b).any);
        a = tmp;
        assert((a ^= b).any);
        a = tmp;
    }

    bool opIndex(size_t i)
    {
        return cast(bool)vector.vecToArray[i];
    }

    unittest
    {
        auto a = Mask128Bit!byte(byte16([-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]));
        assert(a[0] == true);
        assert(a[1] == false);

        a = Mask128Bit!byte(byte16([-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 0]));
        assert(a[0] == true);
        assert(a[15] == false);
    }

    void opIndexAssign(bool a, size_t i)
    {
        version(none)
        {
            if (a)
            {
                vector.array[i] = -1;
            }
            else
            {
                return vector.array[i] = 0;
            }
        }

        TInt val = cast(TInt)!a - 1;
        vector.vecToArray[i] = val;
    }

    unittest
    {
        auto a = Mask128Bit!byte(byte16([-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]));
        a[0] = false;
        assert(!a.any);

        a = Mask128Bit!byte(byte16([-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 0]));
        a[15] = true;
        assert(a.all);
    }

    void opIndexOpAssign(string op)(bool a, size_t i)
    {
        TInt val = cast(TInt)!a - 1;
        vector.vecToArray[i] = val;

        static if (op == "|") vector.vecToArray[i] |= val;
        else static if (op == "&") vector.vecToArray[i] &= val;
        else static if (op == "^") vector.vecToArray[i] ^= val;
        else static assert(false, "Unsupported operation " ~ op);
    }

    unittest
    {
        auto a = Mask128Bit!byte(byte16([-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]));
        a[0] &= false;
        assert(!a.any);

        a = Mask128Bit!byte(byte16([-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 0]));
        a[15] |= true;
        assert(a.all);
    }

    bool opEquals(ThisType rhs)
    {
        return maskEqual(vector, rhs.vector).all;
    }

    Vec select(Vec)(Vec a, Vec b)
        if(isSIMDVector!(Vec) && ElemOf!(Vec).sizeof == TInt.sizeof && LengthOf!(Vec) == LengthOf!(BaseVector))
    {
        version (X86_SIMD)
        {
            static if (x86SIMDVersion >= X86SIMDVersion.SSE4_1)
            {
                return sse4_1.pblendvb(a, b, vector);
            }
            else static if (x86SIMDVersion >= X86SIMDVersion.SSE2)
            {
                return sse2.pxor(a, sse2.pand(vector, sse2.pxor(a, b)));
            }
            else
            {
                static assert(false, "Unsupported by this compiler");
            }
        }
        else
        {
            static assert(false, "Unsupported by this compiler");
        }
    }

    auto select(ThisType a, ThisType b)
    {
        return ThisType(this.select(a.vector, b.vector));
    }

    unittest
    {
        auto a = Mask128Bit!byte(byte16([-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]));
        auto b = Mask128Bit!byte(byte16([0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]));
        auto c = b.select(b, a);
        assert(!c.any);
        c = b.select(a, b);
        assert(c.all);
    }
package:
    package this(void16 mask)
    {
        vector = mask;
    }

private:
    static int log2SizeOf(T)()
    {
        import core.bitop;
        return bsf(T.sizeof);
    }

    version(X86_SIMD)
    int pack()
    {
        version (X86_SIMD)
        {
            return sse2.pmovmskb(vector);
        }
        else
        {
            static assert(false, "Unsupported by this compiler");
        }
    }

}

unittest
{
    Mask128Bit!long a1;
    Mask128Bit!int a2;
    Mask128Bit!short a3;
    Mask128Bit!byte a4;
}

unittest
{
    struct TestRow
    {
        bool any;
        bool all;
        bool isFront;
        bool isBack;
        int indexOfFirst;
        int indexOfLast;
        int count;
        byte[16] mask;
    }

    TestRow[] testArray = [
    {any : true, all : false, isFront : true, isBack : false
        , indexOfFirst : 0, indexOfLast : 0, count : 1
            , [-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]},
    {any : true, all : false, isFront : false, isBack : true
        , indexOfFirst : 15, indexOfLast : 15, count : 1
            , [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1]},
    {any : true, all : false, isFront : false, isBack : true
        , indexOfFirst : 3, indexOfLast : 15, count : 4
            , [0, 0, 0, -1, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, -1]},
    {any : true, all : true, isFront : true, isBack : true
        , indexOfFirst : 0, indexOfLast : 15, count : 16
            , [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]},
    {any : true, all : false, isFront : true, isBack : false
        , indexOfFirst : 0, indexOfLast : 14, count : 15
            , [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 0]},
    {any : true, all : false, isFront : false, isBack : true
        , indexOfFirst : 1, indexOfLast : 15, count : 15
            , [0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]},
    {any : false, all : false, isFront : false, isBack : false
        , indexOfFirst : -1, indexOfLast : -1, count : 0
            , [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]}
    ];

    foreach (n, t ; testArray)
    {
        byte16 b;
        t.mask[].copy(b.vecToArray);
        auto a = Mask128Bit!byte(b);
        import std.string;
        auto msg = "Test number %s".format(n);
        assert(a.any == t.any, msg);
        assert(a.all == t.all, msg);
        assert(a.isFront == t.isFront, msg);
        assert(a.isBack == t.isBack, msg);
        assert(a.indexOfLast == t.indexOfLast, msg);
        assert(a.indexOfFirst == t.indexOfFirst, msg);
        assert(a.count == t.count, msg);
    }
}

/++
Allows to compare unsigned integers(ubyte, ushort, uint, ulong)
on any architecture. It supports comparation only (mask operations).
+/
struct Comparable(VecUInt : __vector(UInt[N]), UInt, size_t N)
    if (isUnsigned!UInt)
{
    this(VecUInt vec)
    {
        static if (isNativeUintCmp)
        {
            m_vector = vec;
        }
        else
        {
            m_vector = vec - getCastVec;
        }
    }

    /++ Returns original unsigned vector.
    +/
    VecUInt get()
    {
        static if (isNativeUintCmp)
        {
            return m_vector;
        }
        else
        {
            return cast(VecUInt)m_vector + getCastVec;
        }
    }
private:
    static if (!isNativeUintCmp)
    VecUInt getCastVec() pure @safe
    {
        VecUInt res;
        res = cast(UInt)SignedInt.min;
        return res;
    }

    auto getActual()
    {
        return m_vector;
    }
private:
    static if (isNativeUintCmp)
    {
        alias ImplVecT = VecUInt;
        ImplVecT m_vector;
    }
    else
    {
        alias ImplVecT = Vector!(Signed!UInt[N]);
        alias SignedInt = Signed!UInt;
        ImplVecT m_vector;
    }

    /++ Check is current support of comparison for UInt vector is not worse
        than for signed one. E. g. if simd is not supported simulation makes no
        sense, but for SSE2 it does.
    +/
    static bool checkNativeUintCmp()
    {
        return ((simdArch == SIMDArch.None) || (x86SIMDVersion < X86SIMDVersion.SSE2));
    }

    enum bool isNativeUintCmp = checkNativeUintCmp;
}

auto comparable(Vec : __vector(UInt[N]), UInt, size_t N)(Vec a)
    if (isUnsigned!UInt)
{
    alias UInt = ElemOf!(Vec);
    enum size = LengthOf!(Vec);
    return Comparable!(Vector!(UInt[size]))(a);
}

unittest
{
    import std.conv;
    uint4 a = [1, 5, 0xFFF, 0xFFFF];
    auto b = a.comparable.get;
    assert(maskEqual(b, a).all, b.vecToArray.to!string ~ ", " ~ a.vecToArray.to!string);
}

public
{
    auto maskEqual(Vec : Comparable!UInt, UInt)(Vec a, Vec b)
    {
        return maskEqual(a.m_vector, b.m_vector);
    }

    unittest
    {
        uint4 a = [uint.max, 0, 3, 7];
        uint4 b = [1, 1, 3, 3];
        auto res = maskEqual(a.comparable, b.comparable);
        auto expected = Mask128Bit!int(int4([0, 0, -1, 0]));
        import std.string;
        assert(res == expected, "%s".format(res.vector.vecToArray));
    }

    auto maskNotEqual(Vec : Comparable!UInt, UInt)(Vec a, Vec b)
    {
        return maskNotEqual(a.m_vector, b.m_vector);
    }

    unittest
    {
        uint4 a = [uint.max, 0, 3, 7];
        uint4 b = [1, 1, 3, 3];
        auto res = maskNotEqual(a.comparable, b.comparable);
        auto expected = Mask128Bit!int(int4([-1, -1, 0, -1]));
        import std.string;
        assert(res == expected, "%s".format(res.vector.vecToArray));
    }

    auto maskGreater(Vec : Comparable!UInt, UInt)(Vec a, Vec b)
    {
        return maskGreater(a.m_vector, b.m_vector);
    }

    unittest
    {
        uint4 a = [uint.max, 0, 3, 7];
        uint4 b = [1, 1, 7, 3];
        auto res = maskGreater(a.comparable, b.comparable);
        auto expected = Mask128Bit!int(int4([-1, 0, 0, -1]));
        import std.string;
        assert(res == expected, "%s".format(res.vector.vecToArray));
    }

    auto maskLess(Vec : Comparable!UInt, UInt)(Vec a, Vec b)
    {
        return maskLess(a.m_vector, b.m_vector);
    }

    unittest
    {
        uint4 a = [uint.max, 0, 3, 7];
        uint4 b = [1, 1, 3, 3];
        auto res = maskLess(a.comparable, b.comparable);
        auto expected = Mask128Bit!int(int4([0, -1, 0, 0]));
        import std.string;
        assert(res == expected, "%s".format(res.vector.vecToArray));
    }

    auto maskLessOrEqual(Vec : Comparable!UInt, UInt)(Vec a, Vec b)
    {
        return maskLessOrEqual(a.m_vector, b.m_vector);
    }

    unittest
    {
        uint4 a = [uint.max, 0, 3, 7];
        uint4 b = [1, 1, 3, 3];
        auto res = maskLessOrEqual(a.comparable, b.comparable);
        auto expected = Mask128Bit!int(int4([0, -1, -1, 0]));
        import std.string;
        assert(res == expected, "%s".format(res.vector.vecToArray));
    }

    auto maskGreaterOrEqual(Vec : Comparable!UInt, UInt)(Vec a, Vec b)
    {
        return maskGreaterOrEqual(a.m_vector, b.m_vector);
    }

    unittest
    {
        uint4 a = [uint.max, 0, 3, 7];
        uint4 b = [1, 1, 3, 3];
        auto res = maskGreaterOrEqual(a.comparable, b.comparable);
        auto expected = Mask128Bit!int(int4([-1, 0, -1, -1]));
        import std.string;
        assert(res == expected, "%s".format(res.vector.vecToArray));
    }

}

