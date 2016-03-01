/++
Architecture independent high level SIMD wrapers.
+/
module iakh.simd;

import iakh.simd.x86;

import std.range;
import std.traits : isSIMDVector;

enum SIMDArch : int {NoSIMD, X86};

static if (iakh.simd.x86.isAvailable)
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
            static assert(false, "Unsupported on this architecture");
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
    auto maskEqual(byte16 a, byte16 b)
    {
        version (X86_SIMD)
        {
            return Mask128Bit!long(sse2.pcmpeqb(a, b));
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    auto maskEqual(short8 a, short8 b)
    {
        version (X86_SIMD)
        {
            return Mask128Bit!long(sse2.pcmpeqw(a, b));
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    auto maskEqual(int4 a, int4 b)
    {
        version (X86_SIMD)
        {
            return Mask128Bit!long(sse2.pcmpeqd(a, b));
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    auto maskEqual(long2 a, long2 b)
    {
        version (X86_SIMD)
        {
            return Mask128Bit!long(sse4_1.pcmpeqq(a, b));
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
        return cast(bool)vector.array[i];
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
        vector.array[i] = val;
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
        vector.array[i] = val;

        static if (op == "|") vector.array[i] |= val;
        else static if (op == "&") vector.array[i] &= val;
        else static if (op == "^") vector.array[i] ^= val;
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
            return sse4_1.pblendvb(a, b, vector);
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
        b.array[] = t.mask;
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

