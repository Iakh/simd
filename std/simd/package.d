/++
High level SIMD wrapers.
+/

import std.simd.x86;
import std.meta : staticIndexOf;

enum SIMDArch : int {NoSIMD, X86};

static if (std.simd.x86.isAvailable)
{
    version = X86_SIMD;
}

private alias ElemOf(Vec : Vector!(Arr), Arr : T[N], N : size_t) = T;
private enum isInSet(T, TSet...) = staticIndexOf!(T, TSet) != -1;

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

// auto byNByteChunkst()(){} // returns range of resulting chunks

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
    Vector!(TInt[length]) vector;

    package this(void16 mask)
    {
        vector = mask;
    }

    /// Build Mask128Bit from bit mask
    version(none)
    this(ushort mask)
    {

    }

    /// Build Mask128Bit from bool range
    version(none)
    this(Range)(Range range)
    {

    }

    private static int log2SizeOf(T)()
    {
        import core.bitop;
        return bsf(T.sizeof);
    }

    private version(X86_SIMD)
    int pack()
    {
        version (X86_SIMD)
        {
            return sse2.pmovmskb(vector);
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
        }
    }

    bool any()
    {
        version (X86_SIMD)
        {
            return cast(bool)pack();
        }
        else
        {
            static assert(false, "Unsupported on this architecture");
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
            static assert(false, "Unsupported on this architecture");
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
            static assert(false, "Unsupported on this architecture");
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
            static assert(false, "Unsupported on this architecture");
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
            static assert(false, "Unsupported on this architecture");
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
            static assert(false, "Unsupported on this architecture");
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
            static assert(false, "Unsupported on this architecture");
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
        a = Mask128Bit!byte(byte16([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1]));
        b = Mask128Bit!byte(byte16([-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 0]));
        assert(~a == b);
        a = Mask128Bit!byte(byte16([0, 0, 0, -1, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, -1]));
        b = Mask128Bit!byte(byte16([-1, -1, -1, 0, -1, -1, 0, 0, -1, -1, -1, -1, -1, -1, -1, 0]));
        assert(~a == b);
        a = Mask128Bit!byte(byte16([-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]));
        b = Mask128Bit!byte(byte16([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]));
        assert(~a == b);
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

    Vec select(Vec)(Vec a, Vec b)
        if(ElemOf(Vec).sizeof == TInt.sizeof)
    {
        static assert(false, "Unsupported on this architecture");
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
        b.array = t.mask;
        auto a = Mask128Bit!byte(b);
        import std.format;
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

