# OS Fundamentals

## What is an Operating System?

An OS is system software that acts as an intermediary between hardware and user applications. It manages hardware resources and provides services to programs.

**Core roles:**
- Resource allocator: manages CPU, memory, I/O devices
- Control program: controls execution to prevent errors and misuse
- Kernel: the one program always running on the computer

## OS Structure

### Monolithic Kernel
All OS services run in kernel space as a single large binary.
- Fast (direct function calls, no context switching between components)
- Hard to maintain and extend
- A bug anywhere can crash the entire OS
- Examples: Linux, traditional Unix

### Microkernel
Only essential services in kernel space (IPC, basic scheduling, memory). Everything else runs as user-space servers.
- More reliable and modular
- Easier to port
- Slower due to IPC overhead
- Examples: Mach, QNX, MINIX

### Hybrid Kernel
Combines monolithic and microkernel approaches. Core services in kernel, others optionally in user space.
- Examples: Windows NT, macOS (XNU)

### Exokernel
Minimal kernel that exposes hardware directly to applications. Applications implement their own abstractions.
- Maximum flexibility, used mostly in research

## System Boot Process

1. Power on → CPU executes BIOS/UEFI from ROM
2. POST (Power-On Self Test) checks hardware
3. BIOS/UEFI loads bootloader from disk (MBR or GPT)
4. Bootloader (e.g., GRUB) loads kernel image into memory
5. Kernel initializes: hardware drivers, memory management, process scheduler
6. Kernel starts `init`/`systemd` (PID 1)
7. Init starts user-space services and login shell

## OS Services

| Service | Description |
|---------|-------------|
| Program execution | Load and run programs |
| I/O operations | Abstract device access |
| File system | Create, read, write, delete files |
| Communications | IPC between processes |
| Error detection | Detect and handle hardware/software errors |
| Resource allocation | Distribute CPU, memory across processes |
| Accounting | Track resource usage |
| Protection | Control access to resources |

## User Interface

- **CLI (Shell):** Direct command execution. Examples: bash, zsh, PowerShell
- **GUI:** Windowed interaction via mouse/keyboard
- **System calls:** Programmatic interface for user programs to request OS services

## Dual-Mode Operation

Hardware provides two modes to protect OS from user programs:

- **Kernel mode (ring 0):** Full hardware access, executes privileged instructions
- **User mode (ring 3):** Restricted access. Cannot execute privileged instructions directly.

Mode switch happens via:
- System calls (user → kernel)
- Interrupts (hardware → kernel)
- Exceptions (fault → kernel)
- Return from interrupt/syscall (kernel → user)

## Timer and CPU Protection

OS uses a hardware timer to prevent a process from monopolizing the CPU.
- Timer fires an interrupt after N ticks
- OS regains control on each timer interrupt
- Resets the timer for the next process

## Privileged Instructions

Only executable in kernel mode. Attempting them in user mode causes a **protection fault**.
- Halt instruction
- Direct I/O instructions
- Modify memory protection bits
- Disable/enable interrupts
- Load/modify base and limit registers

## Virtualization

Allows multiple OS instances to run on a single physical machine.

- **Type 1 (bare-metal):** Hypervisor runs directly on hardware. Examples: VMware ESXi, Xen, KVM
- **Type 2 (hosted):** Hypervisor runs on top of a host OS. Examples: VirtualBox, VMware Workstation

**Containers** (e.g., Docker) use OS-level virtualization. They share the host kernel and isolate user space via namespaces and cgroups.

## Key OS Abstractions

| Abstraction | Underlying resource |
|-------------|---------------------|
| Process | CPU + memory |
| File | Disk storage |
| Socket | Network connection |
| Virtual memory | Physical RAM + swap |
| Thread | CPU execution context |
