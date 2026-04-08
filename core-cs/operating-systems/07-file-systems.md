# File Systems

## File Concepts

A **file** is a named collection of related data stored persistently on a storage device.

**File attributes:** Name, identifier (inode number), type, location, size, protection, timestamps (created, modified, accessed).

**File operations:** create, write, read, seek, delete, truncate, open, close.

**Open file table:** OS maintains a table of open files per process (file descriptors). System-wide open file table also exists. Each entry tracks: file position, access mode, reference count.

## File Types

| Type | Unix extension | Identified by |
|------|---------------|---------------|
| Regular | .txt, .c, .exe | Content |
| Directory | — | Inode type |
| Symbolic link | .lnk | Inode type |
| Special files (devices) | — | /dev/, inode type |
| Pipe | — | Created via mkfifo |
| Socket | .sock | Created via socket() |

**Magic numbers:** Unix identifies file type by first bytes (e.g., `#!` for scripts, `ELF` for executables, `PK` for ZIP).

## File Access Methods

**Sequential access:** Read bytes in order, one after another. Natural for tapes; efficient for streaming.

**Random (direct) access:** Seek to any position, read/write at that offset. Required for databases.

**Index-sequential:** Index file points into sequential data file. Efficient range queries (B-trees are the modern form).

## Directory Structure

### Single-Level Directory
All files in one directory. Simple, but name conflicts across users.

### Two-Level Directory
One directory per user. Separate namespaces but no grouping within a user.

### Tree-Structured Directory
Hierarchical. Files have path names (absolute and relative). Most modern systems.

### Acyclic Graph Directory
Allow shared subdirectories/files via hard links or symbolic links.

### General Graph Directory
Allow cycles. Requires garbage collection for deletion.

## Directory Implementation

**Linear list:** Array of (name, inode) pairs. Simple but O(n) search.

**Hash table:** Map file name to directory entry. O(1) average search. Collisions possible.

## File System Implementation

### Disk Layout

| Region | Contents |
|--------|---------|
| Boot block | Bootloader |
| Superblock | FS metadata (size, free block count, inode count) |
| Inode table | Array of inodes |
| Data blocks | File and directory contents |

**Superblock** stores critical metadata. Corrupting it destroys the entire filesystem. Typically replicated.

### Inodes (Index Nodes)

Each file has an inode containing:
- File type, permissions, owner, group
- Size, timestamps
- Link count (number of hard links)
- Pointers to data blocks

**Block pointers in Unix inodes:**
- 12 direct block pointers (12 × 4KB = 48KB)
- 1 single indirect (4KB/4B = 1024 pointers → 4MB)
- 1 double indirect (1024² = 4GB)
- 1 triple indirect (1024³ = 4TB)

### Directory Entries

A directory is a file whose content is a list of `(name → inode number)` mappings.

### Free Space Management

- **Bitmap:** One bit per block (1=free, 0=used). Efficient for finding contiguous free space.
- **Free list:** Linked list of free blocks. Simple but slow to find contiguous space.
- **Grouping/Counting:** Store (first free block, count) pairs.

## Common File Systems

| FS | OS | Notable features |
|----|-----|-----------------|
| ext4 | Linux | Journaling, extents, 1 exabyte max |
| XFS | Linux | High performance, 8 exabyte max |
| Btrfs | Linux | COW, snapshots, checksums, RAID |
| NTFS | Windows | Journaling, ACLs, compression |
| APFS | macOS | COW, snapshots, native encryption |
| FAT32 | Cross-platform | Simple, 4GB file limit |
| exFAT | Cross-platform | FAT32 successor, larger files |
| ZFS | Solaris/FreeBSD | COW, checksums, integrated RAID, snapshots |

## Journaling

Log changes before applying them. On crash, replay journal to restore consistency.

**Write-ahead logging:**
1. Write journal entry (transaction begin + changes)
2. Commit journal entry
3. Apply changes to filesystem
4. Mark journal entry as done

**Journal modes (ext3/ext4):**
- **Writeback:** Only journal metadata. Fast but data may be lost.
- **Ordered (default):** Journal metadata, but write data before metadata commits.
- **Journal:** Journal both data and metadata. Slow but safest.

## Virtual File System (VFS)

Abstraction layer allowing the kernel to support multiple filesystem types with a common interface.

```
User space: open(), read(), write(), close()
     ↓
VFS layer: file operations → inode operations
     ↓
Concrete FS: ext4, XFS, NFS, procfs...
```

VFS defines: `inode`, `dentry` (directory entry cache), `file`, `super_block` objects and their operation tables.

## Buffer Cache / Page Cache

Disk reads/writes are cached in memory (page cache).

- Read: check cache first, read from disk on miss
- Write: write to cache (dirty), flush to disk later (writeback)
- `sync()` / `fsync()` forces dirty pages to disk

**Unified page cache:** Modern Linux uses the same cache for file data and memory-mapped files.

## RAID

Redundant Array of Independent Disks — combine multiple disks for performance and/or reliability.

| Level | Description | Min Disks | Overhead |
|-------|-------------|-----------|---------|
| RAID 0 | Striping, no redundancy | 2 | 0% |
| RAID 1 | Mirroring | 2 | 50% |
| RAID 5 | Striping + distributed parity | 3 | 1/n |
| RAID 6 | Striping + 2 parity blocks | 4 | 2/n |
| RAID 10 | Mirror + stripe | 4 | 50% |

## NFS (Network File System)

Allows a client to mount a remote filesystem over a network. Client VFS calls are translated to RPC calls to the NFS server.

- **Stateless server (NFSv2/v3):** Server doesn't remember open files. Each request is self-contained.
- **Stateful server (NFSv4):** Better locking, better performance.

## File System Consistency

**fsck (file system check):** Scans entire filesystem for inconsistencies after crash. Slow for large disks.

Replaced by journaling in modern filesystems (journal guarantees consistency without full scan).

**Copy-on-Write filesystems (ZFS, Btrfs, APFS):** Never overwrite data in place. Write new version, then atomically update pointers. No need for journaling — always consistent.
