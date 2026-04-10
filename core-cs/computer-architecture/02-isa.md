# Instruction Set Architecture

The ISA is the interface between hardware and software. It defines the set of instructions a processor can execute, the registers it provides, how memory is addressed, and the data types it supports natively.

## What the ISA Defines

**Instruction set:** the complete list of operations the processor can perform.

**Registers:** general-purpose registers, special-purpose registers (PC, stack pointer, flags/status register), and floating-point/SIMD registers.

**Data types:** supported widths (8, 16, 32, 64 bits) and types (integer, float, vector).

**Addressing modes:** how operand addresses are computed.

**Instruction encoding:** how instructions are encoded as bits.

**Memory model:** how memory reads and writes are ordered across threads.

**Privilege levels:** user mode, kernel mode, hypervisor mode.

## x86-64 ISA

The dominant ISA for desktops, servers, and laptops. Backward-compatible extension of x86 (32-bit) and 8086 (16-bit).

**Registers:**
- 16 general-purpose 64-bit registers: RAX, RBX, RCX, RDX, RSI, RDI, RSP, RBP, R8-R15.
- Instruction pointer: RIP.
- Flags register: RFLAGS (carry, zero, sign, overflow, parity flags).
- 16 SIMD registers: XMM0-XMM15 (128-bit SSE); YMM0-YMM15 (256-bit AVX); ZMM0-ZMM31 (512-bit AVX-512).

**Addressing modes (x86):**

| Mode | Syntax | Effective address |
|------|--------|------------------|
| Immediate | `mov rax, 42` | 42 (not an address) |
| Register | `mov rax, rbx` | rbx |
| Direct | `mov rax, [addr]` | addr |
| Register indirect | `mov rax, [rbx]` | rbx |
| Base + displacement | `mov rax, [rbx+8]` | rbx + 8 |
| Scaled index | `mov rax, [rbx+rcx*4]` | rbx + rcx×4 |
| Full SIB | `mov rax, [rbx+rcx*4+8]` | rbx + rcx×4 + 8 |

**Variable-length encoding:** x86-64 instructions are 1-15 bytes. Legacy encoding with many prefixes and ModRM bytes.

## ARM64 (AArch64) ISA

The dominant ISA for mobile devices, Apple Silicon, and increasingly servers.

**Registers:** 31 general-purpose 64-bit registers X0-X30 (W0-W30 for 32-bit access); XZR/WZR (zero register); SP (stack pointer); PC.

**Load/store architecture:** arithmetic and logic operate only on registers; memory access only via LOAD and STORE instructions.

**Fixed 32-bit instruction encoding:** simpler decoder; easier pipelining.

**Addressing modes:** base register, base + offset, base + register, pre/post-indexed.

**Condition codes:** ARM supports conditional execution of most instructions. `MOVNE` (move if not equal) avoids branches.

## RISC-V ISA

Open-source, royalty-free RISC ISA designed for education and embedded systems.

**Base integer ISA (RV32I/RV64I):** minimal 47 instructions. Extensions: M (multiply/divide), A (atomics), F/D (float), C (compressed 16-bit), V (vector).

**32 registers (x0-x31):** x0 is hardwired to zero.

**Simple fixed 32-bit encoding** (or 16-bit compressed C extension).

## Instruction Types

**Data movement:** LOAD, STORE, MOV, push/pop.

**Arithmetic:** ADD, SUB, MUL, DIV, shift left/right.

**Logic:** AND, OR, XOR, NOT.

**Comparison:** CMP (sets flags), TEST.

**Branch/jump:** unconditional JMP; conditional Jcc (JE, JNE, JL, JGE, ...); CALL and RET for functions.

**System:** SYSCALL (enter kernel mode), INT (software interrupt), CPUID.

## Addressing Modes

Determine how the effective address of a memory operand is computed.

**Immediate addressing:** the operand is a constant encoded in the instruction.

**Register addressing:** the operand is a register.

**Memory addressing:** the operand is at a computed memory address.

More addressing modes = more flexible assembly; but more decoder complexity.

## ISA Design Tradeoffs

| Property | RISC | CISC |
|----------|------|------|
| Instruction count | More instructions needed | Fewer |
| Instruction complexity | Simple, uniform | Complex, varied |
| Encoding | Fixed-width | Variable-width |
| Registers | Many (16-32) | Fewer (8-16) |
| Memory access | Load/store only | Direct memory ops |
| Decoder complexity | Simple | Complex |
| Compiler complexity | Higher (explicit loads) | Lower |

Both approaches achieve similar performance in modern implementations. The microarchitecture (pipeline, cache, OoO) matters more than the ISA for real-world performance.

## Privilege Levels

**User mode:** application code. Limited access to hardware; cannot execute privileged instructions (I/O port access, interrupt control, page table modification).

**Kernel mode:** OS kernel. Full hardware access.

**Ring system (x86):** rings 0-3. Ring 0 = kernel; ring 3 = user. Rings 1-2 rarely used.

**Hypervisor mode (VMX/EL2):** hardware virtualization support; virtualizes the kernel mode.

A user-mode program requests kernel services via system calls (`syscall`/`sysenter` on x86-64; `SVC` on ARM). The CPU switches to kernel mode, validates the request, performs the service, and returns.
