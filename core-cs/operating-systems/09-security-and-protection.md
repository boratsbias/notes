# Security and Protection

## Protection vs Security

**Protection:** Controls access of processes and users to resources defined by the OS. Internal mechanism.

**Security:** Defends the system from external and internal attacks. Broader concern including authentication, network threats, malware.

## Goals of Protection

- Prevent unauthorized access to resources
- Enforce policies that specify who can do what
- Support graceful error detection (detect violations and fail safely)
- Principle of least privilege: grant only the minimum permissions needed

## Access Control

### Access Control Matrix

Conceptual model: matrix where rows = domains (users/processes), columns = objects (files, devices, processes).

```
          File A    File B    Printer
Process 1  read     read,write  —
Process 2  read       —        print
```

Too large to store directly. Implemented as:

**Access Control Lists (ACLs):** Per object, list of (domain, rights). Stored with the object.
- Easy to check who can access an object
- Hard to revoke all access for a user across all objects

**Capability lists:** Per domain, list of (object, rights). Like a ticket/token.
- Easy to transfer/delegate access
- Hard to revoke — must find and invalidate all capabilities

**Linux Unix permissions:** Simplified ACL — owner/group/other × read/write/execute.
**Linux POSIX ACLs:** Extended per-file ACLs (via `getfacl`/`setfacl`).

### Role-Based Access Control (RBAC)

Assign permissions to roles, assign roles to users. Simpler administration for large organizations.

### Mandatory Access Control (MAC)

System enforces policy that users cannot override. Labels on subjects and objects. Examples: SELinux, AppArmor.

**Bell-LaPadula model** (confidentiality):
- No read up (can't read higher-classification data)
- No write down (can't write to lower-classification objects)

**Biba model** (integrity):
- No read down (can't read lower-integrity data)
- No write up (can't write to higher-integrity objects)

## Authentication

Verify identity. Three factors:
- Something you **know** — password, PIN
- Something you **have** — hardware token, phone (OTP)
- Something you **are** — fingerprint, face

**Multi-factor authentication (MFA):** Combine ≥2 factors.

### Passwords

**Hashing:** Store `hash(password + salt)`, not plaintext.
- Salt prevents rainbow table attacks
- Use slow hash functions: bcrypt, Argon2, scrypt (resist brute force)

**Common attacks:**
- Dictionary attack: try common words
- Brute force: try all combinations
- Phishing: trick user into revealing password
- Credential stuffing: use leaked passwords from other breaches

## Threats and Attacks

### Malware Types

| Type | Description |
|------|-------------|
| Virus | Attaches to programs, spreads on execution |
| Worm | Self-replicates across networks without host |
| Trojan horse | Appears legitimate, performs hidden malicious action |
| Ransomware | Encrypts files, demands payment for key |
| Rootkit | Hides malware from OS and users, often in kernel |
| Spyware | Monitors user activity, sends data to attacker |
| Adware | Delivers unwanted ads |

### Attack Techniques

**Buffer overflow:** Write past end of buffer, overwrite return address, execute injected code.
- Defense: stack canaries, ASLR, NX/DEP, bounds checking

**Address Space Layout Randomization (ASLR):** Randomize base addresses of stack, heap, libraries. Makes exploits that rely on fixed addresses harder.

**Stack canary:** Place random value before return address. Check before function returns. If changed → overflow detected, abort.

**NX/DEP (No-Execute / Data Execution Prevention):** Mark stack and heap as non-executable. Prevents injecting shellcode there.

**Return-Oriented Programming (ROP):** Bypass NX by chaining together existing code snippets (gadgets) ending in `ret`. Defense: Control Flow Integrity (CFI).

**SQL Injection:** Insert SQL code into input fields.
```sql
-- Vulnerable query:
SELECT * FROM users WHERE username = '$input';
-- If input = "' OR '1'='1":
SELECT * FROM users WHERE username = '' OR '1'='1';
```
Defense: parameterized queries / prepared statements.

**Cross-Site Scripting (XSS):** Inject malicious scripts into web pages viewed by other users. Defense: output encoding, Content Security Policy (CSP).

**Race condition / TOCTOU:** Time-Of-Check to Time-Of-Use. Check permissions, then by the time you use the resource, it has changed.

**Privilege escalation:** Exploit vulnerabilities to gain higher privileges (user → root).

### Denial of Service (DoS)

Overwhelm a system with requests to make it unavailable.

**DDoS:** Distributed DoS using many compromised machines (botnet).
**SYN flood:** Send many TCP SYN packets without completing handshake. Exhaust connection table.
Defense: SYN cookies.

## Cryptography in OS Security

**Symmetric encryption (AES):** Same key for encrypt/decrypt. Fast. Key distribution problem.

**Asymmetric encryption (RSA, ECC):** Public key encrypts, private key decrypts. Slow. Used for key exchange.

**TLS/SSL:** Combines asymmetric (for key exchange) and symmetric (for data). Secures network communication.

**Disk encryption:** Encrypt data at rest. Linux: LUKS/dm-crypt. macOS: FileVault. Windows: BitLocker.

**Secure boot:** Verify bootloader and kernel signatures before executing. Prevents boot-level rootkits.

## Kernel Security Mechanisms

**chroot:** Change root directory for a process. Limits visible filesystem. Partial isolation.

**Namespaces (Linux):** Isolate system resources: PID, network, mount, UTS, IPC, user. Foundation of containers.

**cgroups (Linux):** Limit resource usage (CPU, memory, I/O) per group of processes.

**Seccomp:** Filter system calls a process can make. Restrict attack surface.

**Capabilities (Linux):** Split root's privileges into individual capabilities (CAP_NET_BIND_SERVICE, CAP_SYS_ADMIN, etc.). Grant only what's needed.

**SELinux / AppArmor:** Mandatory access control frameworks. Define policies for which processes can access which resources.

## Vulnerability Management

**Principle of least privilege:** Minimize permissions granted.
**Defense in depth:** Multiple independent layers of security.
**Fail-safe defaults:** Default deny rather than default allow.
**Complete mediation:** Check every access, not just the first.
**Open design:** Security should not depend on secrecy of design (Kerckhoff's principle).

**CVE (Common Vulnerabilities and Exposures):** Standardized identifiers for known vulnerabilities.
**CVSS:** Common Vulnerability Scoring System — severity rating 0-10.
**Patch management:** Apply security patches promptly. Unpatched systems are primary attack vector.
