# Transport Layer

The transport layer (Layer 4) provides end-to-end communication services between applications on different hosts. It multiplexes multiple application flows over a single network connection using port numbers, and provides either reliable (TCP) or unreliable (UDP) delivery.

## Ports and Multiplexing

A single host runs many applications simultaneously. Port numbers distinguish them.

**Socket:** identified by the 5-tuple: (protocol, local IP, local port, remote IP, remote port).

**Well-known ports (0-1023):** HTTP=80, HTTPS=443, SSH=22, FTP=20/21, SMTP=25, DNS=53, DHCP=67/68.

**Registered ports (1024-49151):** assigned by IANA to specific services.

**Ephemeral ports (49152-65535):** dynamically assigned to client sockets by the OS.

**Demultiplexing:** the transport layer uses the destination port to deliver a received segment to the correct application process.

## TCP In Depth

### Three-Way Handshake

```
Client                     Server
  |-------- SYN (seq=x) ----->|
  |<- SYN-ACK (seq=y, ack=x+1)|
  |------ ACK (ack=y+1) ----->|
         ESTABLISHED
```

**Initial Sequence Numbers (ISNs):** chosen randomly to prevent spoofing and old segment confusion. Each side has its own ISN.

**SYN cookies:** server encodes connection state into the ISN when under SYN-flood attack. Avoids maintaining state for half-open connections.

### Reliability: Sequence Numbers and Acknowledgments

**Sequence number:** the byte offset of the first byte in the segment's payload.

**Acknowledgment number:** the next byte the receiver expects. All bytes before this have been received.

**Cumulative acknowledgment:** one ACK covers all data up to the ACK number.

**Selective acknowledgment (SACK):** the receiver can acknowledge out-of-order blocks. TCP option (3 SACK blocks in a typical header extension). Enables efficient recovery of multiple losses.

### Retransmission

**Retransmission timeout (RTO):** if no ACK is received within RTO, retransmit the segment. RTO is estimated using RTT:

$$\text{SRTT} = (1-\alpha)\text{SRTT} + \alpha \text{RTT}_{\text{sample}}, \quad \alpha = 0.125$$

$$\text{DevRTT} = (1-\beta)\text{DevRTT} + \beta |RTT_{\text{sample}} - SRTT|, \quad \beta = 0.25$$

$$\text{RTO} = \text{SRTT} + 4 \times \text{DevRTT}$$

**Fast retransmit:** if the sender receives 3 duplicate ACKs, it retransmits the missing segment immediately (without waiting for RTO).

### Flow Control

Prevents the sender from overwhelming a slow receiver.

**Receive window (rwnd):** advertised in every TCP segment. The sender may not have more than `rwnd` unacknowledged bytes in flight.

$$\text{Send window} = \min(\text{rwnd}, \text{cwnd})$$

Where `cwnd` is the congestion window (see below).

### Congestion Control

Prevents the sender from overwhelming the network.

**Slow Start:** begin with `cwnd = 1 MSS`; double `cwnd` every RTT until `ssthresh` (slow start threshold) is reached.

**Congestion Avoidance:** after `ssthresh`, increase `cwnd` by 1 MSS per RTT (additive increase).

**On loss (RTO timeout):** `ssthresh = cwnd/2`; `cwnd = 1 MSS`; restart slow start.

**On loss (3 dup ACKs, TCP Reno):** `ssthresh = cwnd/2`; `cwnd = ssthresh`; enter congestion avoidance.

**TCP CUBIC (Linux default):** uses a cubic function of time since last congestion event to set `cwnd`. Better for high-bandwidth, long-delay networks.

**BBR (Bottleneck Bandwidth and Round-trip propagation time):** estimates actual bottleneck bandwidth and minimum RTT; targets optimal operating point. Used in Google's infrastructure and YouTube.

**ECN (Explicit Congestion Notification):** routers mark packets (instead of dropping) when queues are building. Receivers echo the mark via the ECE flag; senders reduce `cwnd` without packet loss.

### TCP Connection Termination

**Active close:** sends FIN; enters FIN_WAIT_1; receives ACK (FIN_WAIT_2); receives FIN; sends ACK; enters TIME_WAIT for 2×MSL (60-120 s) before CLOSED.

**TIME_WAIT:** ensures the final ACK reaches the other side; prevents delayed packets from a closed connection from being interpreted as a new connection.

**RST (Reset):** abrupt termination. Sent when receiving a packet for a non-existent connection, or when an application wants to abort.

## UDP In Depth

**Header:** 8 bytes: source port (2B), destination port (2B), length (2B), checksum (2B).

**Checksum:** optional in IPv4; mandatory in IPv6. Covers pseudo-header (src IP, dst IP, protocol, UDP length) + UDP header + data.

**No connection state:** a server can handle requests from many clients without maintaining per-client state.

**Use cases:** DNS (fast single-request-response), DHCP, streaming (RTP/RTSP), gaming (position updates), QUIC (HTTP/3 runs over UDP).

## QUIC

A modern transport protocol designed by Google, now standardized (RFC 9000). Runs over UDP.

**Key features:**
- 0-RTT and 1-RTT connection establishment (vs. TCP's 1 RTT + TLS's 1-2 RTTs).
- Built-in TLS 1.3 encryption (no separate TLS handshake).
- Multiple independent streams within a connection (no head-of-line blocking).
- Connection migration: a connection can survive changing IP addresses (mobile users switching between Wi-Fi and cellular).
- Better congestion control flexibility (per-connection).

**HTTP/3:** uses QUIC as the transport. Reduces page load times, especially on lossy or high-latency connections.

## TCP vs. UDP

| Property | TCP | UDP |
|----------|-----|-----|
| Connection | Yes (3-way handshake) | No |
| Reliability | Guaranteed delivery | Best effort |
| Ordering | In-order delivery | No ordering |
| Flow control | Yes | No |
| Congestion control | Yes | No |
| Header size | 20+ bytes | 8 bytes |
| Latency | Higher | Lower |
| Use cases | HTTP, SSH, email | DNS, streaming, gaming |
