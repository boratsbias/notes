# OSI Model

The OSI (Open Systems Interconnection) model is a conceptual framework for understanding network communication. It divides the communication process into 7 layers, each with a specific responsibility, enabling different network technologies to interoperate.

## The Seven Layers

| Layer | Number | Name | PDU | Role |
|-------|--------|------|-----|------|
| Application | 7 | Application | Message/Data | User-facing protocols (HTTP, DNS, SMTP) |
| Presentation | 6 | Presentation | Message/Data | Encoding, encryption, compression |
| Session | 5 | Session | Message/Data | Session establishment and management |
| Transport | 4 | Transport | Segment | Reliable/unreliable end-to-end delivery |
| Network | 3 | Network | Packet | Routing between networks, IP addressing |
| Data Link | 2 | Data Link | Frame | Node-to-node delivery, MAC addressing |
| Physical | 1 | Physical | Bits | Electrical/optical/wireless bit transmission |

**PDU (Protocol Data Unit):** the unit of data at each layer. Upper layers work with messages; Transport with segments/datagrams; Network with packets; Data Link with frames; Physical with bits.

**Encapsulation:** each layer adds its own header (and sometimes trailer) to the data from the layer above.

```
Application:  [Data]
Transport:    [TCP header | Data]
Network:      [IP header | TCP header | Data]
Data Link:    [Frame header | IP header | TCP header | Data | Frame trailer]
Physical:     ....1010011010....
```

On the receiving side, each layer removes its header and passes the remainder up.

## Layer 7: Application

Provides network services directly to user applications. Defines how applications format and exchange data.

**Protocols:** HTTP/HTTPS (web), DNS (name resolution), SMTP/IMAP/POP3 (email), FTP/SFTP (file transfer), SSH (secure shell), DHCP (IP assignment), SNMP (network management).

Application layer protocols define message formats, sequences of requests/responses, and how to interpret the content.

## Layer 6: Presentation

Handles data translation between different formats. In practice, this layer is not distinct in TCP/IP; its functions are handled within application protocols.

**Functions:** character encoding (ASCII, UTF-8), data serialization (JSON, XML, Protobuf), compression (gzip, zstd), encryption (TLS/SSL is often considered here).

## Layer 5: Session

Manages the establishment, maintenance, and termination of communication sessions. Also not a distinct layer in TCP/IP.

**Functions:** session establishment and teardown; dialog control (half-duplex vs. full-duplex); synchronization (checkpoints in long data transfers).

**Examples:** RPC session management, NetBIOS.

## Layer 4: Transport

Provides end-to-end communication services. Multiplexes multiple applications over a single network connection via port numbers.

**TCP (Transmission Control Protocol):** reliable, ordered, connection-oriented. Provides: error detection and retransmission, flow control, congestion control, stream abstraction.

**UDP (User Datagram Protocol):** unreliable, unordered, connectionless. Low overhead; used for latency-sensitive applications (video, DNS, gaming).

**Port numbers:** identify applications on a host. 0-1023: well-known ports (HTTP: 80, HTTPS: 443, SSH: 22, DNS: 53). 1024-49151: registered ports. 49152-65535: dynamic/ephemeral.

## Layer 3: Network

Routes packets from source to destination across multiple networks. Provides logical (IP) addressing.

**IPv4:** 32-bit addresses; approximately 4.3 billion unique addresses. Written as dotted-decimal: `192.168.1.1`.

**IPv6:** 128-bit addresses; virtually unlimited address space. Written as colon-hexadecimal: `2001:db8::1`.

**IP routing:** each router maintains a routing table; forwards packets based on the destination IP address and the longest prefix match.

**Protocols:** IP, ICMP (ping, traceroute), IGMP (multicast), ARP (IP to MAC resolution, technically Layer 2.5).

## Layer 2: Data Link

Provides reliable node-to-node communication on a single link. Handles physical addressing (MAC addresses), framing, and error detection.

**MAC address:** 48-bit hardware address. Identifies a network interface card (NIC). Written as hex octets: `00:1A:2B:3C:4D:5E`.

**Ethernet:** dominant wired LAN protocol. Defines frame format and CSMA/CD (now replaced by full-duplex switched Ethernet).

**Wi-Fi (802.11):** wireless LAN. Uses CSMA/CA (collision avoidance) instead of CSMA/CD.

**Switches:** Layer 2 devices that forward frames based on MAC addresses. Learn MAC-to-port mappings from observed traffic.

**Error detection:** CRC (Cyclic Redundancy Check) in Ethernet frame trailer. Detects but does not correct bit errors; corrupted frames are discarded.

## Layer 1: Physical

Transmits raw bits over a physical medium.

**Wired:** Ethernet (copper twisted pair), fiber optic (single-mode for long distance, multi-mode for short), coaxial.

**Wireless:** Wi-Fi, Bluetooth, cellular (4G LTE, 5G), satellite.

**Specifications:** voltage levels, bit rate, connector types, wavelengths, modulation schemes.

**Modulation:** encode bits as physical signals. NRZ (Non-Return to Zero), Manchester encoding, QAM (Quadrature Amplitude Modulation) for high-speed links.

## OSI vs. TCP/IP

In practice, TCP/IP collapses the 7 OSI layers into 4:

| TCP/IP Layer | OSI Layers |
|-------------|-----------|
| Application | 5 + 6 + 7 |
| Transport | 4 |
| Internet | 3 |
| Link | 1 + 2 |

The OSI model is valuable as a conceptual reference; TCP/IP is the model actually implemented.
