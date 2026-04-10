# Network Layer

The network layer (Layer 3) is responsible for routing packets from source to destination across multiple interconnected networks. It provides logical (IP) addressing and determines the path packets travel through the internet.

## IP Addressing

An IP address identifies an interface on a network. IPv4 uses 32 bits; IPv6 uses 128 bits.

**Subnet:** a contiguous block of IP addresses sharing a common prefix. Defined by a network address and subnet mask.

**CIDR notation:** `192.168.1.0/24` means the first 24 bits are the network prefix; the last 8 bits identify hosts. Supports $2^8 - 2 = 254$ hosts (excluding network and broadcast addresses).

**Subnet mask:** `255.255.255.0` for `/24`. Bitwise AND of IP with mask gives the network address.

**Special addresses:**
- `127.0.0.0/8`: loopback (localhost).
- `0.0.0.0`: unspecified.
- `255.255.255.255`: limited broadcast.
- `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`: private.

**IPv6 addressing:** `::1` is loopback. `fe80::/10` is link-local. `2000::/3` is global unicast.

## Routing

Routing is the process of selecting a path for packets through the network. Each router maintains a **routing table** mapping destination prefixes to next-hop addresses (or outgoing interfaces).

**Longest prefix match:** when multiple routes match a destination, use the most specific (longest prefix) route.

**Static routing:** routes configured manually. Simple; no overhead; doesn't adapt to failures.

**Dynamic routing:** routers exchange routing information and compute routes automatically. Adapts to topology changes.

### Interior vs. Exterior Routing

**Intra-AS (interior) routing:** within an Autonomous System (organization). Optimize for shortest path.

**Inter-AS (exterior) routing:** between ASes. Consider policy, business relationships, and contracts. BGP is the only exterior routing protocol.

## Routing Algorithms

### Dijkstra's Algorithm (Link-State)

**Input:** a complete graph with link costs. **Output:** shortest path from a source to all other nodes.

**Algorithm:** greedily select the unvisited node with the lowest known distance; update neighbors.

**Time complexity:** $O(V^2)$ or $O((V + E) \log V)$ with a priority queue.

**OSPF (Open Shortest Path First):** uses Dijkstra. Each router floods its link-state information (Link State Advertisement) to all routers in the AS. Every router has a complete topology map.

### Bellman-Ford Algorithm (Distance-Vector)

**Update rule:** node $v$ updates distance to destination $d$ via neighbor $u$:

$$D_v(d) = \min_{u \in \text{neighbors}} (c_{v,u} + D_u(d))$$

Each node only knows distances to its immediate neighbors; converges through iterative exchange.

**RIP (Routing Information Protocol):** uses Bellman-Ford. Routers broadcast their full routing table every 30 seconds. Max hop count: 15 (infinity = 16). Simple but slow to converge; count-to-infinity problem.

**Count-to-infinity problem:** after a link failure, incorrect routes propagate gradually. Mitigated by split horizon and poison reverse.

## OSPF (Open Shortest Path First)

The most widely used intra-AS routing protocol.

**Link-state flooding:** each router sends its Link State Advertisement (LSA) to all other routers in the AS (using flooding). Every router has the complete topology.

**SPF (Shortest Path First):** each router runs Dijkstra on its link-state database to compute the shortest path to all destinations.

**Areas:** large networks are divided into OSPF areas to reduce LSA flooding overhead. Area 0 is the backbone; all areas connect to the backbone.

**Fast convergence:** OSPF converges in seconds to sub-seconds after a topology change (with BFD for fast failure detection).

## BGP (Border Gateway Protocol)

The inter-AS routing protocol of the internet. Every ISP, CDN, and large organization runs BGP.

**Path vector protocol:** BGP advertises routes with the full AS path. Avoids routing loops (if own ASN appears in path, discard).

**BGP attributes:** AS_PATH, NEXT_HOP, LOCAL_PREF (prefer a path within an AS), MED (suggest ingress point to neighboring AS), COMMUNITY (tag routes for policy).

**eBGP (external BGP):** between routers in different ASes.

**iBGP (internal BGP):** distribute routes within an AS (between border routers).

**BGP decision process:** prefer routes with: highest LOCAL_PREF, then shortest AS_PATH, then lowest MED, then eBGP over iBGP, then lowest IGP metric to NEXT_HOP, then router ID as tiebreaker.

**BGP hijacking:** an AS announces another AS's prefix, attracting traffic. A major security concern. RPKI (Resource Public Key Infrastructure) cryptographically validates route origins.

## ICMP (Internet Control Message Protocol)

Used for diagnostics and error reporting at the network layer.

**Ping:** sends ICMP Echo Request to a host; host replies with Echo Reply. Measures RTT.

**Traceroute:** sends packets with TTL=1, 2, 3, ...; each router decrements TTL; when TTL reaches 0, the router sends ICMP Time Exceeded back to the sender. Maps the path.

**Common error messages:** Destination Unreachable (no route, port closed), Time Exceeded (TTL=0), Redirect (better route exists).

## NAT (Network Address Translation)

Maps multiple private IP addresses to one (or a few) public IP addresses.

**How it works:** the NAT router maintains a translation table mapping {private IP, private port} to {public IP, public port}. Outbound packets are rewritten; inbound packets are reverse-translated.

**Problems:** breaks end-to-end connectivity; complicates peer-to-peer applications; requires ALGs (Application Layer Gateways) for protocols that embed IP in the payload (FTP, SIP). IPv6 eliminates the need for NAT.

## IP Forwarding

When a router receives a packet:
1. Check TTL; if 0, discard and send ICMP Time Exceeded.
2. Look up destination IP in routing table (longest prefix match).
3. Decrement TTL; recompute IP checksum.
4. Forward packet to next hop via the outgoing interface.

**FIB (Forwarding Information Base):** the optimized data structure (typically a radix trie or TCAM lookup) used for fast packet forwarding. Separate from the RIB (Routing Information Base) used by routing protocols.
