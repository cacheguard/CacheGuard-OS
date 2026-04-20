# CacheGuard-OS

**The open-source all-in-one network security appliance for startups and small businesses.**

> Firewall · VPN · WAF · Antivirus · URL Filtering · SSL Inspection · QoS · Reverse Proxy — in a single ISO you install in minutes.

[![License](https://img.shields.io/badge/license-CacheGuard%20Open%20Source-blue)](./LICENSE)
[![Latest Release](https://img.shields.io/github/v/release/cacheguard/CacheGuard-OS)](https://github.com/cacheguard/CacheGuard-OS/releases)
[![SourceForge Downloads](https://img.shields.io/sourceforge/dw/webgateway.svg)](https://sourceforge.net/projects/webgateway/)

---

## Why CacheGuard?

Most network security solutions are either **too complex** (pfSense, OPNsense) or **too expensive** (FortiGate, Sophos XG). CacheGuard sits right in between: enterprise-grade protection, designed to be set up by anyone with basic networking knowledge — in under an hour.

| | CacheGuard | pfSense | FortiGate |
|---|---|---|---|
| All-in-one (UTM + WAF + QoS) | ✅ | ❌ (plugins needed) | ✅ |
| Free & open source | ✅ | ✅ | ❌ |
| Setup time | ~30 min | Several hours | Days + vendor |
| Web GUI for non-experts | ✅ | Moderate | ✅ |
| Built-in web antivirus | ✅ | ❌ | ✅ |
| Built-in WAF | ✅ | ❌ | ✅ |

---

## What's included

CacheGuard-OS turns any x86/x64 machine or VM into a full network appliance:

- **Firewall** — stateful packet filtering with fine-grained rules
- **VPN server** — IPsec & SSL VPN, ready for remote teams
- **Web antivirus** — real-time gateway-level malware scanning (ClamAV)
- **URL filtering** — block unwanted categories and specific domains
- **SSL inspection** — inspect encrypted HTTPS traffic
- **Reverse proxy + WAF** — protect your web apps with ModSecurity
- **Load balancer** — distribute traffic across multiple backends
- **Multi-WAN QoS** — traffic shaping, bandwidth prioritization, WAN failover
- **Web caching** — reduce bandwidth usage and speed up browsing

All features run simultaneously on the same machine. No plugins, no add-ons, no surprises.

---

## Quick start

### Requirements
- Any x86/x64 machine or hypervisor (VMware, VirtualBox, Proxmox, KVM, Hyper-V, Azure, AWS)
- At least **2 network interfaces**
- 4 CPU cores · 8 GB RAM · 250 GB disk (for up to 100 users)

### Install in 3 steps

```bash
# 1. Download the latest ISO
https://github.com/cacheguard/CacheGuard-OS/releases/latest

# 2. Boot your machine from the ISO and follow the installer

# 3. Access the Web GUI at:
https://<your-cacheguard-ip>:8090
```

The installer configures everything automatically based on your hardware. After first boot, the appliance is ready to configure via CLI or Web GUI.

Full installation guide: [cacheguard.net/doc](https://www.cacheguard.net/doc/guide/)

---

## Who is it for?

- **Startups** setting up their network security for the first time
- **Small and medium businesses** that need enterprise protection without enterprise cost
- **Schools and institutions** looking for content filtering and safe browsing
- **MSPs and IT consultants** who want a repeatable, easy-to-deploy solution for clients
- **Homelabbers** who want a real UTM without the complexity of pfSense

---

## Screenshots

*The CacheGuard Web GUI — Configure everything from your browser*

<img width="1337" height="1167" alt="CacheGuard-Gateway-Dashboard" src="https://github.com/user-attachments/assets/ed99d979-cdf4-4e8c-ab88-83b9a74a65b4" />

---

*The CacheGuard Web GUI — Create simple firewall rules*

<img width="1235" height="735" alt="CacheGuard-Screenshot-Firewall" src="https://github.com/user-attachments/assets/58727af3-7ee4-4c7d-bbe8-9eecb592581c" />

---

*The CacheGuard Web GUI — Automatically generate client side VPN profile files or scripts (for Apple, Android, Windows & Linux)*

<img width="1335" height="1159" alt="CacheGuard-Gateway-VPN-Script" src="https://github.com/user-attachments/assets/2e824782-4d77-4a91-9a7f-87db87205d55" />

---

## Built on proven open-source technology

CacheGuard-OS integrates and orchestrates best-in-class open source components:

[OpenSSL](https://www.openssl.org/) · [NetFilter](https://www.netfilter.org/) · [StrongSwan](https://www.strongswan.org/) · [ClamAV](https://www.clamav.net/) · [Squid](http://www.squid-cache.org/) · [Apache](https://httpd.apache.org/) · [ModSecurity](https://modsecurity.org/) · [IProute2](https://wiki.linuxfoundation.org/networking/iproute2)

Over 200,000 lines of original open-source code tie these components into a single, coherent, secure system.

---

## Licensing & support

CacheGuard-OS is **free and open source** (since v2.4.1). You can use it with any number of users, on any number of machines, at no cost.

**Need professional support?** We offer paid support plans for businesses that need guaranteed response times and expert assistance:

👉 [View support options at cacheguard.com](https://www.cacheguard.com/)

Support plans help sustain the project and fund continued development.

---

## Documentation

- [Getting started guide](https://www.cacheguard.net/doc/guide/)
- [Full user manual (PDF)](https://www.cacheguard.net/pdf/CacheGuard-Users-Guide.pdf)
- [Community forum](https://help.cacheguard.net/)
- [YouTube demos](https://www.youtube.com/@cacheguard)

---

## Contributing

CacheGuard-OS is open source and contributions are welcome. Feel free to:

- Open an issue to report bugs or suggest features
- Submit a pull request
- Share CacheGuard with your network — it helps more than you think

---

## Stay in touch

- Website: [cacheguard.com](https://www.cacheguard.com/)
- Forum: [help.cacheguard.net](https://help.cacheguard.net/)
- LinkedIn: [CacheGuard on LinkedIn](https://www.linkedin.com/company/cacheguard-technologies-sas/)

---

*CacheGuard — Enterprise-grade network security, without the enterprise price tag.*
