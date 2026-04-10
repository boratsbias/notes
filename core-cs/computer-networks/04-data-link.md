# Data Link Layer

The data link layer (Layer 2) provides node-to-node communication on a single link. It handles framing, physical addressing (MAC), error detection, and media access control: determining which node can transmit when multiple nodes share the same medium.

## Framing

The data link layer wraps network-layer packets in **frames** by adding a header (and usually a trailer). Framing gives the receiver a way to find the beginning and end of each packet in the bit stream.

**Framing methods:**
- **Fixed-size frames:** simple; no overhead. Used in ATM cells (53 bytes).
- **Byte count:** header field specifies frame length. Error in the count corrupts sync.
- **Flag bytes with byte stuffing:** a special byte (flag) marks frame boundaries. If the flag byte appears in the data, it is escaped (stuffed). Used in PPP.
- **Bit stuffing:** insert a 0 after every 5 consecutive 1s in the data stream; remove on receive. Flag is `01111110`. Used in HDLC.
- **Physical layer coding violations:** use otherwise-illegal signal patterns as delimiters.

## MAC Addresses

A MAC (Media Access Control) address is a 48-bit hardware address assigned to a network interface card.

**Format:** 6 bytes written in hex: `AA:BB:CC:DD:EE:FF`. First 3 bytes: OUI (Organizationally Unique Identifier, assigned to the manufacturer). Last 3 bytes: device identifier.

**Special addresses:**
- `FF:FF:FF:FF:FF:FF`: broadcast; received by all nodes on the LAN.
- Multicast: first byte has LSB = 1 (e.g., `01:00:5E:xx:xx:xx` for IPv4 multicast).

MAC addresses are used for delivery within a single LAN. IP addresses are used for routing across networks.

## Error Detection and Correction

Transmission errors flip bits. The data link layer detects (and sometimes corrects) errors.

**Parity bit:** append 1 bit such that the total number of 1s is even (even parity) or odd. Detects 1-bit errors; cannot detect 2-bit errors.

**Checksum:** sum the data bytes (modulo 256 or 2^16); send the complement. Used in TCP/IP headers.

**CRC (Cyclic Redundancy Check):** treat the data as a polynomial; divide by a generator polynomial; the remainder is the CRC. CRC-32 (Ethernet): detects all 1-3 bit errors, all burst errors up to 32 bits. Very efficient in hardware.

**FEC (Forward Error Correction):** adds enough redundancy to correct errors without retransmission. Used in wireless (802.11, LTE, 5G), optical links, RAID.
- Hamming codes: correct 1-bit errors; detect 2-bit errors.
- Reed-Solomon: correct burst errors. Used in QR codes, CDs, deep-space communication.
- LDPC, Turbo codes, Polar codes: near-Shannon-limit performance. Used in 5G, Wi-Fi 6.

## Medium Access Control (MAC)

When multiple nodes share the same medium (Ethernet bus, wireless channel), they need a protocol to avoid collisions.

### CSMA/CD (Carrier Sense Multiple Access with Collision Detection)

Used in classic (half-duplex) Ethernet.

1. **Carrier sense:** listen before transmitting; wait if channel is busy.
2. **Transmit:** send the frame.
3. **Collision detection:** if two nodes transmit simultaneously, both detect the collision (garbled signal).
4. **Jam signal:** both send a jam signal to ensure all nodes detect the collision.
5. **Binary exponential backoff:** wait a random time (0 to $2^k - 1$ slot times, where $k$ is the collision count) before retrying.

Modern Ethernet uses full-duplex point-to-point links with switches; no collisions; CSMA/CD is not needed.

### CSMA/CA (Collision Avoidance)

Used in Wi-Fi (802.11).

Collision detection is not feasible for wireless (can't detect collision while transmitting). Use avoidance instead.

1. **DIFS wait:** before transmitting, wait a DIFS (DCF Interframe Space) period.
2. **Random backoff:** pick a random backoff counter; count down while channel is idle; reset if channel becomes busy.
3. **Transmit** when counter reaches 0.
4. **ACK:** receiver sends an ACK after a SIFS (Short IFS). If no ACK, assume collision; retry with increased backoff window.

**RTS/CTS (optional):** send a Request to Send; receiver replies with Clear to Send. Solves the hidden terminal problem.

## Ethernet

The dominant wired LAN standard. Defined by IEEE 802.3.

**Ethernet frame format:**

```
| Preamble (7B) | SFD (1B) | Dst MAC (6B) | Src MAC (6B) | EtherType/Length (2B) | Payload (46-1500B) | CRC (4B) |
```

**EtherType:** identifies the network-layer protocol. `0x0800` = IPv4, `0x86DD` = IPv6, `0x0806` = ARP.

**MTU (Maximum Transmission Unit):** 1500 bytes payload. Jumbo frames: up to 9000 bytes (data center).

**Ethernet speeds:** 10 Mbps, 100 Mbps, 1 Gbps, 10 Gbps, 25 Gbps, 40 Gbps, 100 Gbps.

## Switches

A Layer 2 switch forwards frames based on destination MAC address.

**MAC address table (CAM table):** maps destination MAC to the outgoing port. Built dynamically by observing source MACs on incoming frames.

**Flooding:** if destination MAC is unknown (or broadcast), flood the frame to all ports except the incoming one.

**Forwarding:** if destination MAC is known, forward only to the correct port.

**Loop prevention (STP):** the Spanning Tree Protocol disables redundant links to prevent broadcast storms. RSTP (Rapid STP) converges faster.

**VLANs:** logically divide a switch into multiple isolated networks. Tagged with 802.1Q headers (4-byte VLAN tag in the Ethernet frame). Ports can be access (untagged, single VLAN) or trunk (tagged, multiple VLANs).

## PPP (Point-to-Point Protocol)

Used for direct connections (serial links, dial-up, DSL). Supports multiple network-layer protocols, authentication (PAP, CHAP), compression, and error detection. Replaced by Ethernet for most access networks.
