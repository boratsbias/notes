# TCP/IP Model

The TCP/IP model is the practical networking architecture that underlies the internet. It defines a four-layer stack and the key protocols at each layer. Unlike the OSI model, TCP/IP emerged from real-world implementation (ARPANET) and remains the foundation of all modern networking.

## The Four Layers

| Layer | Name | Key Protocols | PDU |
|-------|------|--------------|-----|
| 4 | Application | HTTP, DNS, SMTP, SSH, FTP | Message |
| 3 | Transport | TCP, UDP | Segment / Datagram |
| 2 | Internet | IP, ICMP, ARP | Packet |
| 1 | Link | Ethernet, Wi-Fi, PPP | Frame |

## IPv4

The Internet Protocol version 4. Provides logical addressing and routing for packets across networks.

**IPv4 address:** 32 bits, written in dotted-decimal notation: `192.168.1.100`.

**Address space:** $2^{32} \approx 4.3$ billion addresses. Exhausted in 2011 for IANA allocations.

**IPv4 header fields:**

| Field | Bits | Purpose |
|-------|------|---------|
| Version | 4 | Always 4 for IPv4 |
| IHL | 4 | Header length in 32-bit words |
| DSCP | 6 | QoS / traffic class |
| Total length | 16 | Entire packet length |
| TTL | 8 | Hop limit (decremented at each router) |
| Protocol | 8 | 6=TCP, 17=UDP, 1=ICMP |
| Header checksum | 16 | Header integrity |
| Source IP | 32 | Sender address |
| Destination IP | 32 | Receiver address |

**Fragmentation:** if a packet exceeds the MTU (Maximum Transmission Unit) of a link, it is fragmented. Reassembled at the destination. Path MTU Discovery avoids fragmentation.

**CIDR (Classless Inter-Domain Routing):** addresses are represented as prefix/length (e.g., `10.0.0.0/8`). Replaces classful addressing. Enables efficient allocation and aggregation.

**Private address ranges (RFC 1918):** `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`. Not routable on the public internet; require NAT.

**NAT (Network Address Translation):** a router maps private addresses to a single public IP. Masks many devices behind one public address; breaks end-to-end connectivity; complicated by some protocols.

## IPv6

The successor to IPv4 with 128-bit addresses.

**Address space:** $2^{128} \approx 3.4 \times 10^{38}$. Enough for every grain of sand on Earth to have a trillion addresses.

**IPv6 address notation:** 8 groups of 4 hex digits: `2001:0db8:85a3:0000:0000:8a2e:0370:7334`. Leading zeros and consecutive all-zero groups can be omitted: `2001:db8:85a3::8a2e:370:7334`.

**Key improvements over IPv4:** no fragmentation in routers (Path MTU Discovery mandatory); no broadcast (uses multicast); simplified header (fixed 40 bytes); IPsec integration; stateless address autoconfiguration (SLAAC).

**Adoption:** ~45% of global internet traffic as of 2024. Dual-stack deployment (both IPv4 and IPv6 simultaneously) is the transition strategy.

## TCP (Transmission Control Protocol)

Provides reliable, ordered, bidirectional byte streams over IP.

**Connection establishment (3-way handshake):**

```
Client                Server
  |------ SYN -------->|   Client sends SYN (sequence number x)
  |<--- SYN-ACK --------|   Server responds with SYN-ACK (seq y, ack x+1)
  |------ ACK -------->|   Client sends ACK (ack y+1)
  |  [connection open]  |
```

**Connection teardown (4-way):**

```
  |------ FIN -------->|
  |<------ ACK --------|
  |<------ FIN --------|
  |------- ACK ------->|
```

**TCP header key fields:** source port, destination port, sequence number, acknowledgment number, flags (SYN, ACK, FIN, RST, PSH, URG), window size.

**Reliability:** sequence numbers and acknowledgments; retransmission on timeout or duplicate ACKs.

**Flow control:** the receiver advertises a receive window size; the sender does not exceed it.

**Congestion control:** TCP infers network congestion from packet loss or ECN marks; reduces sending rate. Algorithms: Reno, CUBIC (Linux default), BBR.

**TCP state machine:** LISTEN, SYN_SENT, SYN_RCVD, ESTABLISHED, FIN_WAIT_1, FIN_WAIT_2, TIME_WAIT, CLOSE_WAIT, LAST_ACK, CLOSED.

**TIME_WAIT:** after closing, the socket waits 2×MSL (Maximum Segment Lifetime, ~60 s) to ensure delayed packets don't confuse a new connection.

## UDP (User Datagram Protocol)

Connectionless, unreliable, minimal overhead. No handshake, no retransmission, no ordering.

**Use cases:** DNS (fast queries), streaming video/audio (loss tolerable; latency critical), online games, VoIP, QUIC.

**Header:** only 8 bytes (source port, destination port, length, checksum).

## ICMP (Internet Control Message Protocol)

Used by IP and network utilities for error reporting and diagnostics.

**`ping`:** sends ICMP Echo Request; measures RTT.

**`traceroute`:** sends packets with TTL = 1, 2, 3, ...; each router that discards a TTL=0 packet sends an ICMP Time Exceeded; reveals the path.

**ICMP error types:** Destination Unreachable (host or port not reachable), Time Exceeded (TTL expired), Redirect (better route available).

## ARP (Address Resolution Protocol)

Maps an IPv4 address to a MAC address within a local network.

**Mechanism:** broadcast "Who has IP 192.168.1.5?" The owner replies with its MAC address. Result cached in the ARP table.

**Gratuitous ARP:** a host ARPs for its own IP to announce its MAC (used after IP change or during failover).

**Proxy ARP:** a router responds on behalf of hosts in another network.

ARP is not used with IPv6; replaced by NDP (Neighbor Discovery Protocol) using ICMPv6.
