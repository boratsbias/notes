# Physical Layer

The physical layer (Layer 1) is responsible for transmitting raw bits over a communication medium. It defines how bits are converted to physical signals (electrical, optical, or electromagnetic) and transmitted across a link.

## Transmission Media

### Twisted Pair Copper

Pairs of copper wires twisted together to reduce electromagnetic interference (EMI). Used for Ethernet and telephone.

**Categories:**
- Cat5e: 1 Gbps up to 100 m.
- Cat6: 10 Gbps up to 55 m.
- Cat6a: 10 Gbps up to 100 m.
- Cat8: 25/40 Gbps, data centers.

**UTP (Unshielded Twisted Pair):** standard office/home wiring.

**STP (Shielded Twisted Pair):** shielded for environments with high EMI.

### Coaxial Cable

Central conductor surrounded by insulator and mesh shield. Higher bandwidth and noise immunity than twisted pair.

**Uses:** cable TV (CATV), broadband internet (DOCSIS), older Ethernet (10BASE2).

### Fiber Optic

Transmits light pulses through a glass or plastic core. Very high bandwidth; immune to EMI; very low attenuation.

**Single-mode (SMF):** narrow core (~8 µm); laser light source; low attenuation; long-distance (up to hundreds of km). Used in WAN and metro fiber.

**Multi-mode (MMF):** wider core (~50 µm); LED or VCSEL source; higher attenuation; short-distance (up to ~500 m). Used in data center.

**Bandwidth:** 100 Gbps per wavelength; terabits per second with WDM (Wavelength Division Multiplexing, multiple wavelengths per fiber).

### Wireless

**Wi-Fi (IEEE 802.11):** 2.4 GHz (longer range, more interference), 5 GHz (shorter range, less interference, faster), 6 GHz (Wi-Fi 6E, less congestion).

| Standard | Max speed | Frequency |
|---------|----------|-----------|
| 802.11n (Wi-Fi 4) | 600 Mbps | 2.4/5 GHz |
| 802.11ac (Wi-Fi 5) | 3.5 Gbps | 5 GHz |
| 802.11ax (Wi-Fi 6/6E) | 9.6 Gbps | 2.4/5/6 GHz |
| 802.11be (Wi-Fi 7) | 46 Gbps | 2.4/5/6 GHz |

**Cellular:** 4G LTE (100 Mbps average), 5G (sub-6 GHz: 100-900 Mbps; mmWave: 1-10 Gbps).

**Bluetooth:** short range (10 m typical); 2.4 GHz; low power. Used for personal devices.

## Signal Encoding

Physical bits must be encoded as physical signals.

**NRZ (Non-Return to Zero):** 1 = high voltage, 0 = low voltage. Simple; but long runs of the same bit cause DC drift and loss of clock synchronization.

**NRZI (NRZ Inverted):** a transition = 1, no transition = 0 (or vice versa). Better for long runs of 1s.

**Manchester encoding:** each bit has a transition in the middle. 1 = high-to-low, 0 = low-to-high. Self-clocking; halves bandwidth (each bit uses two signal periods).

**4B/5B encoding:** encode every 4 bits as 5 bits such that no more than one leading zero and no more than two trailing zeros appear (ensures transitions). Used by Fast Ethernet.

**8B/10B encoding:** 8 bits -> 10 bits. Used by Gigabit Ethernet, Fibre Channel.

**64B/66B encoding:** more efficient (3% overhead vs. 20% for 8B/10B). Used by 10 Gbps+ Ethernet.

## Modulation

For wireless and high-speed wired links, bits are modulated onto a carrier wave.

**AM (Amplitude Modulation):** vary signal amplitude to represent bits.

**FM (Frequency Modulation):** vary signal frequency.

**PSK (Phase Shift Keying):** vary signal phase. BPSK (1 bit/symbol), QPSK (2 bits/symbol).

**QAM (Quadrature Amplitude Modulation):** vary both amplitude and phase. 16-QAM (4 bits/symbol), 64-QAM (6), 256-QAM (8), 1024-QAM (10), 4096-QAM (12). Higher-order QAM requires better signal-to-noise ratio.

**OFDM (Orthogonal Frequency Division Multiplexing):** divide the channel into many narrow subcarriers; modulate each independently. Robust to multipath fading. Used in Wi-Fi, LTE, 5G, ADSL.

## Shannon's Theorem

The theoretical maximum data rate (channel capacity) of a noisy channel:

$$C = B \log_2\left(1 + \frac{S}{N}\right)$$

Where:
- $C$: channel capacity in bits/second.
- $B$: bandwidth in Hz.
- $S/N$: signal-to-noise ratio (linear, not dB).

**Example:** 1 MHz bandwidth, SNR = 1000 (30 dB):

$$C = 10^6 \times \log_2(1001) \approx 10^6 \times 10 = 10 \text{ Mbps}$$

Real systems cannot exceed Shannon capacity, but modern coding schemes (turbo codes, LDPC, polar codes) come within a fraction of a dB.

## Nyquist Rate

For a noiseless channel with bandwidth $B$ Hz and $M$ signal levels:

$$\text{Max rate} = 2B \log_2 M$$

Example: 3000 Hz telephone channel with 8 signal levels: $2 \times 3000 \times 3 = 18{,}000$ bps. This is the Nyquist limit; noise further limits achievable rate to the Shannon capacity.

## Multiplexing

Allow multiple signals to share a single physical medium.

**FDM (Frequency Division Multiplexing):** divide the frequency band into sub-bands, one per signal. Used in cable TV, radio, ADSL.

**TDM (Time Division Multiplexing):** each signal gets the full bandwidth for a time slot in rotation. Used in T1/E1, SONET.

**WDM (Wavelength Division Multiplexing):** each signal uses a different wavelength of light. DWDM (Dense WDM): 80-160 channels per fiber, each at 100 Gbps. Used in long-haul optical networks.

**CDM (Code Division Multiplexing / CDMA):** each user has a unique spreading code; all transmit on the same frequency simultaneously. Used in 3G cellular, GPS.

**OFDMA (Orthogonal FDM with Multiple Access):** assign different subcarriers to different users dynamically. Used in LTE, 5G, Wi-Fi 6.
