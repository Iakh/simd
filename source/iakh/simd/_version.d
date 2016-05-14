/// This module provieds compile time SIMD version/arch check
module iakh.simd._version;

enum X86SIMDVersion
{
    None,
    SSE,
    SSE2,
    SSE3,
    S_SSE3,
    SSE4_1,
    SSE4_2,
    AVX
}

version(X86)
{
    version = X86_OR_64;
}
else version(X86_64)
{
    version = X86_OR_64;
}

private X86SIMDVersion getX86SIMDVersion()
{
    version (X86_OR_64)
    {
        version (DigitalMars)
        {
            version (D_SIMD)
                return X86SIMDVersion.SSE4_2;
            else
                return X86SIMDVersion.None;
        }
        else version (GNU)
        {
            return X86SIMDVersion.SSE2;

            /*
            version(__SSE4_2__)
            {
                return X86SIMDVersion.SSE4_2;
            }
            else version(__SSE4_1__)
            {
                return X86SIMDVersion.SSE4_1;
            }
            else version(__SSSE3__)
            {
                return X86SIMDVersion.S_SSE3;
            }
            else version(__SSE3__)
            {
                return X86SIMDVersion.SSE3;
            }
            else version(GDC__SSE2__)
            {
                return X86SIMDVersion.SSE2;
            }
            else
            {
                return X86SIMDVersion.None;
            }
            */
        }
        else version(LDC)
        {
            return X86SIMDVersion.SSE4_2;
        }
    }
    else
        return X86SIMDVersion.None;

}

enum X86SIMDVersion x86SIMDVersion = getX86SIMDVersion();

enum SIMDArch {None, X86};

private SIMDArch getSIMDArch()
{
    static if (x86SIMDVersion != X86SIMDVersion.None)
    {
        return SIMDArch.X86;
    }
    else
    {
        return SIMDArch.None;
    }
}

enum simdArch = getSIMDArch();
