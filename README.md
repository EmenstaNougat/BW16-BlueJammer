<h1 align="center">BW16-BlueJammer - by @emensta</h1>

<p align="center">
  <img src="" alt="BW16-BlueJammer" width="600">
</p>

<p align="center">
  <b>Jamming is ILLEGAL - Educational purposes only!</b>
</p>

<p align="center">
  <a href="https://github.com/EmenstaNougat/BW16-BlueJammer">
    <img src="https://img.shields.io/static/v1?label=EmenstaNougat&message=BW16-BlueJammer&color=black&logo=github" alt="repo">
  </a>
  &nbsp;
  <a href="https://github.com/EmenstaNougat/BW16-BlueJammer">
    <img src="https://img.shields.io/github/stars/EmenstaNougat/BW16-BlueJammer?style=social" alt="stars">
  </a>
  &nbsp;
  <a href="https://github.com/EmenstaNougat/BW16-BlueJammer">
    <img src="https://img.shields.io/github/forks/EmenstaNougat/BW16-BlueJammer?style=social" alt="forks">
  </a>
</p>

<p align="center">
  <a href="#-about">About</a> &nbsp;·&nbsp;
  <a href="#-why-the-bw16--and-why-is-it-so-hard">Why BW16?</a> &nbsp;·&nbsp;
  <a href="#-key-features">Features</a> &nbsp;·&nbsp;
  <a href="#-why-5-ghz-control-matters">5 GHz Control</a> &nbsp;·&nbsp;
  <a href="#-jamming-modes">Modes</a> &nbsp;·&nbsp;
  <a href="#-web-interface">Web Interface</a> &nbsp;·&nbsp;
  <a href="#-wiring">Wiring</a> &nbsp;·&nbsp;
  <a href="#-flashing">Flashing</a> &nbsp;·&nbsp;
  <a href="#-stability">Stability</a> &nbsp;·&nbsp;
  <a href="#-support-me">Support</a>
</p>

---

<h2> 📌 About</h2>

**BW16-BlueJammer** is a research-grade 2.4 GHz jamming platform built on the **Realtek RTL8720DN (BW16)** microcontroller, running dual NRF24L01+PA+LNA transceiver modules simultaneously. Controlled entirely through a built-in **5 GHz WiFi access point and web interface** - meaning you stay connected to the controller even while the 2.4 GHz spectrum is being disrupted.

This project is the result of **over a year of deep hardware and firmware research**. It is closed source.

> [!WARNING]
> Intended strictly for **authorized research and educational use**. Jamming radio frequencies is **illegal** in most jurisdictions. You are solely responsible for how you use this.

---

<h2>🔬 Why the BW16 - and why is it so hard?</h2>

The **RTL8720DN (BW16)** is a dual-band WiFi + BLE SoC with a native 5 GHz radio, built around two ARM cores - a high-performance **KM4** and a low-power **KM0**. That native 5 GHz capability is exactly what makes it ideal here: the control interface lives on a completely separate band from the jamming, something no other common microcontroller can do natively.

**The catch? Getting it to actually work is brutal.**

The NRF24L01 runs on basically every other platform without issue. On the BW16, **it simply did not work.** Not out of the box, not with any existing library, not with any existing approach. The Ameba SDK's entire communication stack, task structure, and hardware abstraction layer all required **significant rework** before a single byte could be exchanged reliably with an NRF24 module.

Running **two** NRF24 modules simultaneously - each driven through a completely different bus implementation - wasn't even on the radar as a solved problem for this platform. Getting both to function reliably required designing a completely new abstraction layer from scratch: an interface that lets both buses operate transparently through the same driver at runtime. The secondary bus implementation relies on deeply internal SDK primitives rather than anything exposed at the Arduino level - a deliberate consequence of the SDK rework needed to achieve stable operation. An entirely custom NRF24 library also had to be written specifically for the RTL8720DN's architecture.

The whole stack - abstraction layer, custom library, SDK patches - is **original work**. Nobody had done this before on this chip. That's kind of the point.

---

<h2>⚡ Key Features</h2>

| | Feature | Detail |
|---|---|---|
| 📡 | **Platform** | Realtek RTL8720DN (BW16) |
| 📻 | **Dual radio** | NRF24L01+PA+LNA x 2, running simultaneously |
| ⚡ | **Radio 1** | Primary bus - maximum throughput |
| 🔧 | **Radio 2** | Secondary custom bus - proprietary implementation |
| 📶 | **Control band** | 5 GHz WiFi AP - completely separate from jam band |
| 🎯 | **Jam band** | 2.4 GHz - Bluetooth, BLE, WiFi ch 1-14, RC/ISM |
| 🌐 | **Web interface** | Fully featured, mobile-friendly UI |
| 🖥️ | **Serial monitor** | Live device log accessible directly from the web UI |
| 🔄 | **Jamming** | Continuous dual-radio channel hopping, per mode |
| 💡 | **LED feedback** | Onboard RGB - colour-coded per active mode |
| 🔘 | **Physical button** | Short press cycles modes - Long press goes idle |
| 🔒 | **Safety lock** | Web jamming auto-disabled if AP is on 2.4 GHz |
| ⚙️ | **OTA AP config** | SSID, password, channel, hidden - all from web |

---

<h2>📶 Why 5 GHz Control Matters</h2>

Every other project like this runs its control interface over **2.4 GHz WiFi**. The moment jamming starts, the controller disconnects. You lose access. You have to physically reboot the device to stop it.

**BW16-BlueJammer uses a 5 GHz access point** for the control interface. Since the NRF24 modules only operate on 2.4 GHz, the 5 GHz control channel is completely unaffected by jamming. You stay connected at all times - start jamming, stop jamming, switch modes, monitor logs, all live.

> [!NOTE]
> The BW16 **does not jam 5 GHz**. The RTL8720DN's 5 GHz radio is used exclusively as a control channel. The NRF24L01 transceivers are physically incapable of operating above 2.5 GHz. Microcontrollers cannot generate jamming signals directly - that is handled exclusively by the NRF24 modules on the 2.4 GHz band.

---

<h2>🎯 Jamming Modes</h2>

| Mode | Target | Channel range |
|---|---|---|
| 🔵 **BLUETOOTH** | Classic Bluetooth hopping spectrum | CH 0 - 78 |
| 🟣 **BLE** | Bluetooth Low Energy advertising + data | CH 0 - 38 |
| 🟠 **WIFI** | 2.4 GHz WiFi channels 1 - 14 | CH 0 - 14 |
| 🟤 **RC** | RC remotes, drones, ISM band | CH 0 - 124 |
| ⚫ **IDLE** | Radios powered down | - |

Both NRF24 modules hop channels simultaneously and independently, covering the spectrum with two overlapping randomised sweep patterns.

---

<h2>🌐 Web Interface</h2>

Connect to the **BW16-BlueJ_by_@emensta** WiFi network and open **http://192.168.1.1** in any browser.  
Password: `NoConn1337`

<details>
<summary><b>Show all interface features</b></summary>
<br>

| Feature | Description |
|---|---|
| **Mode buttons** | Tap to switch jamming mode instantly |
| **NRF status** | Live radio health (OK / FAIL) for both modules |
| **Status bar** | Current mode with animated live indicator |
| **Command log** | Timestamped record of every mode change and command |
| **Serial monitor** | Live internal device log - pauseable, clearable |
| **AP settings** | Reconfigure SSID, password, channel and hidden mode live |
| **Safety banner** | Warns and locks jamming if AP is moved to 2.4 GHz |
| **Counterfeit warning** | Permanent alert visible on every resold unit |

</details>

<img src="https://dwdwpld.pages.dev/BW16-BlueJammer-WebServer.jpg" alt="BW16-BlueJammer" width="300">

---

<h2>🔌 Wiring</h2>

| Pin | Radio 1 | Radio 2 |
|---|---|---|
| MOSI | PA12 | PA25 |
| MISO | PA13 | PA26 |
| SCK | PA14 | PA27 |
| CSN | PB2 | PA15 |
| CE | PB3 | PB1 |

**Button:** `PA30 -> GND`  
**LED:** Onboard RGB - `PA12 / PA13 / PA14` (active LOW, shares pins with Radio 1 - non-functional while radios are active)

> [!TIP]
> Use NRF24L01 **+PA+LNA** variants with an external antenna for significantly better range and coverage density.

---

<h2>🚀 Flashing</h2>

Flashing is done via pre-compiled `.bin` files - **no source code is required or provided**.

Releases and full flashing instructions are in the [**Releases**](../../releases) section. Future updates will be distributed the same way.

<details>
<summary><b>Important flashing notes</b></summary>
<br>

- Use the Realtek image tool or a compatible flasher - step-by-step instructions are included in every release
- Do **not** attempt to compile or flash via Arduino IDE - this project uses a custom-patched SDK that will not build from source
- After flashing, connect to the 5 GHz AP and verify both NRF modules show **OK** in the web interface before use
- If a radio shows **FAIL**, check wiring and power supply - NRF+PA+LNA modules draw significant current at full transmit power

</details>

---

<h2>🔧 Stability</h2>

The BW16 is a powerful but unusual platform. Getting this far - dual NRF24 modules, 5 GHz control AP, continuous jamming, real-time web interface - on a chip with zero prior support for any of this, required solving problems from first principles.

**Jamming performance may be less consistent than on ESP32-based implementations.** The reasons are architectural:

- The RTL8720DN gives user code access to only one core (KM4), shared between the WiFi stack, the web server, and the radio task
- The Ameba SDK has quirks around task scheduling that required careful workarounds
- The secondary radio bus introduces overhead vs the primary

These are known limitations and active areas of development. **Expect significant stability and performance improvements in future releases.**

<details>
<summary><b>Roadmap</b></summary>
<br>

- [ ] Improved hop timing and spectrum coverage density
- [ ] Per-mode hop rate tuning from the web UI
- [ ] Persistent settings saved across reboots
- [ ] OTA firmware update from the web interface
- [ ] RSSI / signal activity monitoring panel
- [ ] Expanded RC band sub-modes

</details>

---

<h2>⚠️ Counterfeit Warning</h2>

> [!CAUTION]
> **This project is 100% free to build yourself.**  
> If you purchased this device anywhere other than **[emensta.pages.dev](https://emensta.pages.dev)** - you have been scammed. Resellers are not authorised. Future updates and support are void for purchased units.

---

<h2>💬 Discord</h2>

Join the Discord server [here](https://discord.gg/emensta).

<h2>🔗 Portfolio & Links</h2>

Find everything at [emensta.pages.dev](https://emensta.pages.dev).

<h2>☕ Support me</h2>

If you'd like to support future projects, leave a tip [here](https://ko-fi.com/emensta). Thank you! :)

---

<h1 align="center">DISCLAIMER</h1>
<h4 align="center">Please note that the use of this tool is entirely at your own risk. It is intended strictly for educational purposes and should not be used for any illegal or unethical activities. Jamming is illegal and can get you in big trouble!</h4>
<h4 align="center">I'm not responsible for your actions!</h4>
