# Application Layer

The application layer (Layer 7) is where network services are directly consumed by user applications. It defines the protocols that structure how applications exchange data over the network.

## HTTP and HTTPS

**HTTP (HyperText Transfer Protocol):** the foundation of the web. A request-response protocol where clients (browsers) request resources and servers respond.

**HTTP/1.1:** persistent connections (keep-alive); pipelining (send multiple requests without waiting for responses, but responses must be in order).

**HTTP/2:** binary framing; multiplexed streams over one TCP connection (no head-of-line blocking at HTTP level); header compression (HPACK); server push.

**HTTP/3:** runs over QUIC (UDP); true multiplexing with no head-of-line blocking at transport level; 0-RTT connections.

**HTTP methods:** GET, POST, PUT, DELETE, PATCH, HEAD, OPTIONS.

**HTTP status codes:**
- 2xx: success (200 OK, 201 Created, 204 No Content).
- 3xx: redirection (301 Moved Permanently, 302 Found, 304 Not Modified).
- 4xx: client error (400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found, 429 Too Many Requests).
- 5xx: server error (500 Internal Server Error, 502 Bad Gateway, 503 Service Unavailable).

**HTTPS:** HTTP over TLS. Provides encryption, authentication (server certificate), and integrity.

**TLS handshake (TLS 1.3):**
1. Client sends ClientHello (supported ciphers, key share).
2. Server sends ServerHello (selected cipher, key share, certificate).
3. Client verifies certificate; both derive session keys.
4. Application data exchanged encrypted.

TLS 1.3 achieves 1-RTT (and 0-RTT for resumed sessions).

## DNS (Domain Name System)

Translates human-readable hostnames (e.g., `www.example.com`) to IP addresses.

**Hierarchical distributed database:** organized as a tree. Root zone -> TLD (`.com`, `.org`, `.uk`) -> second-level domains (`example.com`) -> subdomains.

**DNS resolution (recursive):**

```
Client -> Recursive Resolver (ISP or 8.8.8.8)
       -> Root nameserver     (returns .com NS)
       -> .com TLD nameserver (returns example.com NS)
       -> example.com NS      (returns 93.184.216.34)
```

**DNS record types:**

| Type | Purpose |
|------|---------|
| A | IPv4 address |
| AAAA | IPv6 address |
| CNAME | Canonical name (alias) |
| MX | Mail exchange |
| TXT | Text (SPF, DKIM, DMARC, domain verification) |
| NS | Nameserver |
| SOA | Start of Authority (zone metadata) |
| PTR | Reverse lookup (IP to name) |
| SRV | Service location (port, priority, weight) |

**TTL (Time to Live):** how long a resolver may cache the record.

**DNS over HTTPS (DoH) / DNS over TLS (DoT):** encrypt DNS queries to prevent eavesdropping and tampering.

**DNSSEC:** cryptographically sign DNS records to prevent spoofing (cache poisoning).

## SMTP, IMAP, and POP3

**SMTP (Simple Mail Transfer Protocol):** sends email between mail servers and from client to server. Port 25 (server-to-server), port 587 (client submission). Uses TLS (STARTTLS or SMTPS).

**IMAP (Internet Message Access Protocol):** client retrieves mail from the server; messages stay on the server; supports folders, search, flags. Port 993 (IMAPS). Most email clients use IMAP.

**POP3 (Post Office Protocol 3):** download-and-delete model; messages removed from server after download. Port 995 (POP3S). Simpler but less flexible than IMAP.

**SPF (Sender Policy Framework):** DNS TXT record listing authorized mail servers for a domain. Prevents spoofing.

**DKIM (DomainKeys Identified Mail):** cryptographic signature on outgoing messages. Receiving server verifies the signature against the public key in DNS.

**DMARC:** policy specifying what to do if SPF/DKIM checks fail. Can instruct receivers to quarantine or reject failing messages.

## FTP and SSH

**FTP (File Transfer Protocol):** transfers files between client and server. Separate control (port 21) and data (port 20 or ephemeral) connections. Unencrypted; largely replaced by SFTP and HTTPS.

**SFTP (SSH File Transfer Protocol):** file transfer over an SSH connection. Encrypted; the standard for secure file transfer.

**SCP (Secure Copy):** copies files over SSH. Simpler than SFTP; less flexible.

**SSH (Secure Shell):** encrypted terminal access and tunneling. Port 22. Uses public-key cryptography for authentication. Supports port forwarding, SOCKS proxy, and X11 forwarding.

## DHCP (Dynamic Host Configuration Protocol)

Automatically assigns IP addresses and network configuration to hosts.

**DORA process:**
1. **Discover:** client broadcasts `DHCPDISCOVER`.
2. **Offer:** server responds with `DHCPOFFER` (IP, subnet mask, gateway, DNS, lease time).
3. **Request:** client broadcasts `DHCPREQUEST` (accepting the offer).
4. **Acknowledge:** server sends `DHCPACK` confirming the lease.

**Lease:** the IP is assigned for a finite time; the client must renew before it expires.

**DHCP relay:** forwards DHCP broadcasts between VLANs/subnets so that one DHCP server can serve multiple networks.

## REST and Web APIs

**REST (Representational State Transfer):** architectural style for web APIs. Resources identified by URLs; operations expressed as HTTP methods (GET, POST, PUT, DELETE); stateless; responses typically JSON.

**GraphQL:** query language for APIs; clients specify the exact data they need. Reduces over- and under-fetching.

**WebSocket:** full-duplex communication over a single TCP connection. Starts as HTTP; upgrades via `Upgrade: websocket` header. Used for real-time applications (chat, live dashboards, games).

**gRPC:** high-performance RPC framework using Protocol Buffers (binary serialization) over HTTP/2. Used in microservices for efficient inter-service communication.

## CDN (Content Delivery Network)

Distributes content to edge servers close to users.

**How it works:** DNS returns the IP of a nearby edge server. The edge server caches the content (images, videos, static assets). Cache miss: fetches from origin. Cache hit: serves directly.

**Benefits:** lower latency, reduced origin load, DDoS mitigation, higher availability.

**Examples:** Cloudflare, Akamai, AWS CloudFront, Fastly.
