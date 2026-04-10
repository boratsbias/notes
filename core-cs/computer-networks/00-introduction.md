# Introduction to Computer Networks

A computer network is a collection of interconnected devices that can exchange data. Networks enable resource sharing, communication, distributed computation, and access to the internet.

## What a Network Is

A network consists of **nodes** (computers, routers, switches, phones) connected by **links** (wired: Ethernet, fiber; wireless: Wi-Fi, cellular). Data is exchanged as packets or streams.

**Network types by scale:**

| Type | Scale | Example |
|------|-------|---------|
| PAN | Personal (1-10 m) | Bluetooth, USB |
| LAN | Local (building) | Ethernet, Wi-Fi |
| MAN | Metropolitan (city) | Cable TV, fiber rings |
| WAN | Wide (country/global) | Internet, MPLS |

**Internet:** a global network of networks. Connects billions of devices using the TCP/IP protocol suite.

## Key Design Principles

**Packet switching:** data is divided into packets; each packet is independently routed through the network. Efficient: links can be shared by many flows. Used by the internet.

**Circuit switching:** a dedicated path is established before communication begins (traditional telephone networks). Guaranteed bandwidth; wastes capacity when idle.

**Store-and-forward:** a router receives the entire packet before forwarding it. Adds per-hop latency.

**Cut-through switching:** a switch starts forwarding as soon as the destination address is read. Lower latency; used in high-speed data centers.

**Best-effort delivery:** the internet does not guarantee delivery, ordering, or timing. Higher layers (TCP) add reliability.

**End-to-end principle:** implement complex functions (reliability, encryption) at the endpoints, not in the network. Keeps the core simple; endpoints add what they need.

## Bandwidth, Latency, and Throughput

**Bandwidth (link capacity):** maximum data rate in bits/second. 1 Gbps Ethernet, 100 Gbps optical fiber.

**Latency (delay):** time for a bit to travel from source to destination.

$$\text{Total delay} = \text{Propagation delay} + \text{Transmission delay} + \text{Processing delay} + \text{Queuing delay}$$

- **Propagation delay:** distance / speed of light in medium. Fiber: $\approx 2 \times 10^8$ m/s.
- **Transmission delay:** packet size / link bandwidth. 1500-byte packet on 1 Gbps link: 12 µs.
- **Processing delay:** time to examine header and make forwarding decision.
- **Queuing delay:** time waiting in router queue. Variable; depends on congestion.

**RTT (Round-Trip Time):** propagation delay in both directions. New York to London: ~70 ms RTT.

**Throughput:** actual data rate achieved. Limited by the bottleneck link and congestion.

**Bandwidth-delay product:** $\text{BDP} = \text{Bandwidth} \times \text{RTT}$. How much data "in flight" at any time. A 1 Gbps link with 100 ms RTT has BDP = 12.5 MB: TCP must keep this much data in-flight for full utilization.

## Layered Architecture

Networking is organized in layers. Each layer uses services from the layer below and provides services to the layer above. Layering enables modularity and independent evolution.

**Two models:**
- **OSI model:** 7 layers (theoretical reference model).
- **TCP/IP model:** 4-5 layers (practical, in use).

Layering adds overhead (headers at each layer) but enables interoperability and modularity.

## Network Devices

**Hub:** broadcasts all received frames to all ports. Obsolete; replaced by switches.

**Switch:** forwards frames based on MAC address. Learns MAC-to-port mappings dynamically. Operates at Layer 2.

**Router:** forwards packets based on IP address. Connects networks. Operates at Layer 3.

**Firewall:** filters traffic based on rules (IP addresses, ports, protocol, state). Can be hardware or software.

**Load balancer:** distributes incoming traffic across multiple servers. Layer 4 (TCP) or Layer 7 (HTTP).

**Access point (AP):** connects wireless devices to a wired network. Operates at Layer 2.

## Circuit Switching vs. Packet Switching

**Circuit switching pros:** guaranteed bandwidth and latency; simple for real-time communication.

**Circuit switching cons:** setup delay; wasted capacity during silence; scales poorly.

**Packet switching pros:** efficient link utilization (statistical multiplexing); handles burst traffic; scalable.

**Packet switching cons:** variable delay; packets can be lost or reordered; requires buffering in routers.

Modern telephony (VoIP) uses packet switching with QoS to achieve circuit-like properties.

## Internet Structure

**ISPs (Internet Service Providers):** organizations that provide internet access. Organized in tiers:
- **Tier 1:** global backbone providers (AT&T, Tata, NTT). Interconnect at major IXPs.
- **Tier 2:** regional providers. Buy transit from Tier 1; peer with others.
- **Tier 3:** local ISPs (access providers). Buy transit from Tier 2.

**IXP (Internet Exchange Point):** physical location where ISPs interconnect and exchange traffic directly (peering). Lower cost and latency than going through a Tier 1.

**CDN (Content Delivery Network):** distribute content to servers close to users. Reduces latency and backbone traffic. Cloudflare, Akamai, AWS CloudFront.

**AS (Autonomous System):** a network under single administrative control, identified by an ASN. BGP is used for inter-AS routing.
