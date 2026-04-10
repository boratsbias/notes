# Data Representation

Computers represent all information as bits. Understanding data representation is essential for reasoning about integer overflow, floating-point rounding, character encoding, and efficient data layout.

## Bits, Bytes, and Words

**Bit:** the fundamental unit of information. 0 or 1.

**Byte:** 8 bits. The smallest addressable unit in most architectures.

**Word:** the natural data size of the CPU. 64-bit on modern x86-64 and ARM64 CPUs. Determines register width and pointer size.

**Endianness:**
- **Big-endian:** most significant byte at the lowest address. Network byte order (TCP/IP); Motorola 68k, SPARC.
- **Little-endian:** least significant byte at the lowest address. x86-64, ARM (default), RISC-V.

For the 32-bit value `0x12345678` stored at address `0x100`:

| Address | Big-endian | Little-endian |
|---------|-----------|--------------|
| 0x100 | 0x12 | 0x78 |
| 0x101 | 0x34 | 0x56 |
| 0x102 | 0x56 | 0x34 |
| 0x103 | 0x78 | 0x12 |

## Integer Representation

### Unsigned Integers

$n$ bits represent values $0$ to $2^n - 1$.

$n = 8$: 0 to 255. $n = 16$: 0 to 65535. $n = 32$: 0 to $2^{32}-1 \approx 4.3 \times 10^9$. $n = 64$: 0 to $\approx 1.8 \times 10^{19}$.

**Arithmetic:** wraps modulo $2^n$. Overflow is well-defined for unsigned integers.

### Two's Complement (Signed Integers)

The universal representation for signed integers on modern hardware.

**$n$-bit range:** $-2^{n-1}$ to $2^{n-1} - 1$.

$n = 8$: -128 to 127. $n = 32$: $-2^{31}$ to $2^{31}-1$.

**Encoding:** positive numbers have the same bit pattern as unsigned. To negate: flip all bits and add 1.

$$-x = \sim x + 1$$

**MSB (most significant bit) = sign bit:** 0 for non-negative, 1 for negative.

**Arithmetic advantages:** addition and subtraction use the same hardware as unsigned arithmetic. No need for separate signed/unsigned adder.

**Overflow:** signed overflow is undefined behavior in C. In hardware, the result wraps; the overflow flag is set.

### One's Complement and Sign-Magnitude

Historically used; not common in modern hardware. Two's complement is universal.

## Floating-Point Representation (IEEE 754)

### Binary Floating-Point Format

$$(-1)^s \times 1.M \times 2^{E - \text{bias}}$$

**Components:**

| Format | Sign | Exponent | Mantissa | Bias |
|--------|------|---------|---------|------|
| FP32 (float) | 1 bit | 8 bits | 23 bits | 127 |
| FP64 (double) | 1 bit | 11 bits | 52 bits | 1023 |
| FP16 | 1 bit | 5 bits | 10 bits | 15 |
| BF16 | 1 bit | 8 bits | 7 bits | 127 |

**Implicit leading 1:** normalized numbers have an implicit `1.` before the mantissa bits. Gains one extra bit of precision.

### Special Values

| Pattern | Value |
|---------|-------|
| Exponent all 0, mantissa 0 | $\pm 0$ |
| Exponent all 0, mantissa nonzero | Subnormal (denormalized) |
| Exponent all 1, mantissa 0 | $\pm \infty$ |
| Exponent all 1, mantissa nonzero | NaN (Not a Number) |

### Floating-Point Precision and Error

FP32 has about 7 significant decimal digits. FP64 has about 15.

**Rounding modes:** round to nearest even (default), round up, round down, round toward zero.

**Machine epsilon $\epsilon$:** the smallest value such that $1 + \epsilon \neq 1$. For FP32: $\epsilon \approx 1.19 \times 10^{-7}$. For FP64: $\epsilon \approx 2.22 \times 10^{-16}$.

**Catastrophic cancellation:** subtracting two nearly equal floating-point numbers loses significant digits. $1.000001 - 1.000000 = 0.000001$ but in FP32, digits beyond the 7th are gone.

**Non-associativity:** $(a + b) + c \neq a + (b + c)$ in general. Floating-point arithmetic is not associative.

## Character Encoding

**ASCII:** 7-bit encoding of 128 characters (English letters, digits, punctuation, control characters). Still embedded in all modern encodings.

**Latin-1 (ISO 8859-1):** 8-bit extension of ASCII for Western European characters.

**Unicode:** standard for representing text in all writing systems. Over 140,000 characters.

**UTF-8:** variable-length encoding. ASCII characters encoded as 1 byte (backward compatible). Other characters use 2-4 bytes. Dominant encoding for web and file storage.

**UTF-16:** used internally by Java, JavaScript, Windows. 2 bytes for most characters; 4 bytes (surrogate pairs) for characters outside the Basic Multilingual Plane.

**UTF-32:** fixed 4 bytes per code point. Simple but wasteful.

## Alignment and Padding

Many architectures require multi-byte values to be aligned to addresses that are multiples of their size.

- `int` (4 bytes) must be at an address divisible by 4.
- `double` (8 bytes) must be at an address divisible by 8.

**Struct padding example:**

```c
struct {
    char  a;   // 1 byte at offset 0
    // 3 bytes padding
    int   b;   // 4 bytes at offset 4
    char  c;   // 1 byte at offset 8
    // 7 bytes padding
    double d;  // 8 bytes at offset 16
};             // total: 24 bytes
```

Rearranging fields by decreasing size minimizes padding. `__attribute__((packed))` removes padding but may cause unaligned accesses (slow or illegal on some architectures).
