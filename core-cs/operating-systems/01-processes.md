# Processes

## What is a Process?

A process is a program in execution. It is the OS's unit of work. A program is passive (code on disk); a process is active (code loaded in memory with state).

**A process includes:**
- Code segment (text)
- Data segment (global/static variables)
- Heap (dynamically allocated memory)
- Stack (local variables, function frames, return addresses)
- Program counter and CPU registers
- OS metadata (open files, signal handlers, etc.)

## Process States

```
new → ready → running → terminated
                ↕
             waiting
```

| State | Description |
|-------|-------------|
| New | Process is being created |
| Ready | Waiting to be assigned to CPU |
| Running | Instructions are executing |
| Waiting | Waiting for an event (I/O, signal) |
| Terminated | Process has finished |

Transitions:
- **ready → running:** Scheduler dispatches process
- **running → ready:** Timer interrupt (preemption) or voluntarily yields
- **running → waiting:** Waits for I/O or event
- **waiting → ready:** I/O complete or event occurs
- **running → terminated:** Process exits

## Process Control Block (PCB)

The OS stores all information about a process in a PCB (also called task_struct in Linux).

**PCB contains:**
- Process ID (PID)
- Process state
- Program counter
- CPU registers
- CPU scheduling info (priority, queue pointers)
- Memory management info (page tables, segment tables)
- Accounting info (CPU time used, time limits)
- I/O status (open file list, I/O device list)

## Context Switch

When the CPU switches from one process to another:
1. Save state of current process into its PCB
2. Load state of next process from its PCB

Context switch is **pure overhead**; no useful work done during the switch. Modern hardware provides features (multiple register sets) to reduce cost.

## Process Creation

A process is created by another process (parent → child tree).

**Unix/Linux:**
```c
pid_t pid = fork();   // creates child as copy of parent
if (pid == 0) {
    exec("program");  // replace child image with new program
} else {
    wait(NULL);       // parent waits for child
}
```

- `fork()`: duplicates the calling process. Returns 0 to child, child's PID to parent.
- `exec()`: replaces the process image. Does not return on success.
- `wait()` / `waitpid()`: parent waits for child to terminate; collects exit status.

**Windows:** `CreateProcess()` combines fork + exec semantics.

## Process Termination

- Normal: process calls `exit()`, returning status to parent
- Abnormal: OS kills process due to error (segfault, illegal instruction)
- Parent can kill child via `kill()` system call

**Zombie process:** Child has exited but parent hasn't called `wait()`. PCB remains in process table.

**Orphan process:** Parent exits before child. Child is re-parented to `init`/`systemd` (PID 1).

## Inter-Process Communication (IPC)

Processes need to communicate and synchronize. Two main models:

### Shared Memory
- Processes share a region of memory
- Fast; no syscall overhead after setup
- Requires explicit synchronization (mutexes, semaphores)
- Example: `shmget()`, `shmat()` (POSIX: `shm_open()`)

### Message Passing
- Processes exchange messages via OS
- No shared memory needed; good for distributed systems
- Slower due to syscall overhead per message
- Variants: pipes, message queues, sockets

## Pipes

**Anonymous pipes:** Unidirectional. Only between related processes (parent-child).
```c
int fd[2];
pipe(fd);   // fd[0] = read end, fd[1] = write end
```

**Named pipes (FIFOs):** Exist as filesystem entry. Allow unrelated processes.
```bash
mkfifo /tmp/mypipe
```

## Signals

Asynchronous notifications sent to a process.

| Signal | Default action | Meaning |
|--------|---------------|---------|
| SIGINT | Terminate | Ctrl+C |
| SIGTERM | Terminate | Polite termination request |
| SIGKILL | Terminate | Force kill (cannot be caught) |
| SIGSEGV | Core dump | Segmentation fault |
| SIGCHLD | Ignore | Child stopped or terminated |
| SIGSTOP | Stop | Cannot be caught |

Processes can **catch**, **ignore**, or use the **default** handler for most signals (except SIGKILL and SIGSTOP).

## Threads vs Processes

| | Process | Thread |
|--|---------|--------|
| Memory | Separate address space | Shared address space |
| Creation cost | High | Low |
| Context switch | Expensive | Cheap |
| Communication | IPC needed | Direct memory access |
| Failure isolation | Strong | Weak (one crash kills all) |

## Process Scheduling Queues

- **Job queue:** All processes in the system
- **Ready queue:** Processes in memory ready to run
- **Device queues:** Processes waiting for specific I/O device

Scheduler moves processes between queues based on state transitions.
