# I/O Systems

## I/O Hardware Overview

Computers interact with devices through:
- **Ports:** Connection points (USB port, serial port)
- **Buses:** Shared data pathway (PCIe, USB, SATA)
- **Device controllers:** Electronic components that operate the device and present a register interface to the CPU

**Device registers (mapped into I/O address space or memory space):**
- Status register: Device state (busy, error, ready)
- Control register: Commands to the device
- Data-in register: Data read from device
- Data-out register: Data to write to device

**Memory-mapped I/O:** Device registers mapped into physical memory address space. CPU reads/writes registers using normal load/store instructions.

**Port-mapped I/O:** Device registers in a separate I/O address space. Requires special instructions (x86: `IN`, `OUT`).

## Polling vs Interrupts

### Polling (Busy Waiting)
CPU repeatedly checks device status register until operation completes.
- Simple, low latency for fast devices
- Wastes CPU cycles for slow devices

### Interrupts
Device signals CPU when operation is complete via an interrupt line.

1. CPU issues I/O command, continues other work
2. Device completes I/O, raises interrupt
3. CPU's interrupt controller signals CPU
4. CPU saves state, jumps to interrupt handler (ISR)
5. ISR processes completion, re-enables interrupts
6. CPU restores state and resumes

**Interrupt vector table:** Maps interrupt numbers to handler addresses.

**Non-maskable interrupt (NMI):** Cannot be disabled. Used for critical events (memory errors, hardware failure).

**Software interrupt / trap:** Software-triggered interrupt. Used for system calls (`int 0x80`, `syscall` on x86-64).

## DMA (Direct Memory Access)

For bulk data transfers, having the CPU copy data byte-by-byte is wasteful.

DMA controller handles the transfer directly between device and memory:
1. CPU programs DMA controller: source, destination, count
2. DMA transfers data independently
3. DMA raises interrupt when done
4. CPU resumes

CPU is free to do other work during the transfer. Used for disks, network cards, GPUs.

**Cache coherency issue:** DMA writes to memory behind the CPU's back. Cache may have stale data. Hardware cache coherency protocols or explicit cache flush/invalidate required.

## Kernel I/O Subsystem

### I/O Scheduling
OS reorders I/O requests for efficiency (especially for HDDs).

**Disk scheduling algorithms:**
- **FCFS:** Process requests in arrival order. Simple but poor performance.
- **SSTF (Shortest Seek Time First):** Service nearest request first. Good throughput, starvation possible.
- **SCAN (Elevator):** Move head in one direction, service all requests, reverse. No starvation.
- **C-SCAN (Circular SCAN):** Move in one direction, jump back to start. More uniform wait times.
- **LOOK / C-LOOK:** Like SCAN/C-SCAN but only go as far as the last request (don't travel to disk edge).

Modern SSDs have no seek time — FCFS or simple queuing is fine.

### Buffering

Store data in memory while transferring to/from device.

**Single buffering:** OS provides one buffer. Device fills it while user copies from it (overlap I/O with processing).
**Double buffering:** Two buffers. One being filled while other is being consumed. Continuous pipeline.
**Circular buffering:** Ring of buffers. Used for streaming data (audio, network).

**Why buffer:**
- Speed mismatch between device and CPU
- Transfer unit mismatch (device transfers blocks, application reads bytes)
- Copy semantics (ensure data is in buffer before `write()` returns so application can modify its buffer)

### Caching

Buffer cache / page cache keeps recently used disk data in memory to avoid repeated disk reads.

Different from buffering: a cache is a copy of data that exists elsewhere (on disk). A buffer holds data in transit.

### Spooling

Simultaneous Peripheral Operations Online. Queue output to slow devices (printers) in a spool directory. Jobs processed in order. Multiple applications can "print" concurrently — the spooler serializes access.

### Error Handling

OS detects device errors from status registers. Strategies:
- Retry the operation
- Return error code to application
- Log the error
- For persistent media errors: remap bad sectors (done by disk firmware or ZFS/Btrfs)

### I/O Protection

User processes cannot issue raw I/O instructions (privileged). All I/O goes through OS via system calls. Prevents bypass of access controls.

## Device Drivers

Kernel modules that control specific hardware. Presents a uniform interface (character device, block device, network interface) to the rest of the kernel.

```
Application → VFS / socket layer
             ↓
         Device driver
             ↓
         Hardware device
```

**Character devices:** Accessed as a stream of bytes (terminals, serial ports, keyboards).
**Block devices:** Accessed in blocks, support random access (disks, SSDs).

## UNIX I/O Model

Everything is a file: regular files, directories, devices (`/dev/sda`), pipes, sockets.

Common interface: `open()`, `read()`, `write()`, `close()`, `ioctl()` (device-specific control).

**File descriptor:** Integer that references an open file table entry. Inherited by child processes after `fork()`.

**Standard streams:**
- 0: stdin
- 1: stdout
- 2: stderr

## Asynchronous I/O

**Synchronous I/O:** System call blocks until operation completes. Simple programming model.

**Asynchronous I/O (AIO):** System call returns immediately. Application gets notification (callback, signal, or polling) when complete.

Linux interfaces:
- POSIX AIO (`aio_read`, `aio_write`) — user-space thread simulation, not truly async
- `io_uring` (Linux 5.1+) — true kernel async I/O with shared ring buffers between kernel and user space. Very low overhead. Used in high-performance servers.

**Non-blocking I/O:** `O_NONBLOCK` flag. System call returns immediately with `EAGAIN` if no data available. Application must retry. Used with `select()`, `poll()`, `epoll()`.

## I/O Performance

| Method | CPU usage | Latency | Throughput |
|--------|-----------|---------|-----------|
| Polling | High | Very low | Medium |
| Interrupt | Low | Medium | Good |
| DMA | Very low | Low | High |
| io_uring | Very low | Very low | Very high |

**Kernel bypass (DPDK, RDMA):** For extreme performance, bypass the OS kernel entirely. Application directly programs the NIC. Used in HFT, cloud networking, HPC.
