# CacheGuard-OS Source Code

This directory contains all CacheGuard-OS source code developed by CacheGuard Technologies. It is published under the GPL v3 license with the hope of inspiring other open-source developers and giving the community full transparency into how CacheGuard-OS works at every level.

---

## About the Source Code

CacheGuard-OS is not a conventional application — it is a fully custom network appliance oriented operating system built entirely from scratch since 2002. The source code in this directory represents over 5,000 man days of research and development and covers every aspect of the system, from the OS foundation to the web interface.

The codebase is primarily written in Bash scripts, which makes it highly readable and auditable by any system administrator without requiring compiled code expertise. This transparency is intentional — for a security product, being able to read and verify every line of code that runs on your network is not a nice-to-have, it is a fundamental requirement.

---

## License

The CacheGuard-OS source code is subject to the **GNU General Public License v3 (GPL v3)**. This means you are free to:

- **Study** the source code and learn from it
- **Modify** it for your personal use
- **Contribute** improvements back to the project

However the following restrictions apply:

- You may not create derivative commercial or non-commercial works from CacheGuard-OS without prior authorization from CacheGuard Technologies
- You are expressly not allowed to install CacheGuard-OS on a hardware or virtual machine and sell the resulting appliance and/or services without having obtained prior written authorization from CacheGuard Technologies
- Reselling a hard drive image file of an installed CacheGuard-OS appliance on a public or private cloud is subject to the same restriction
- Any modifications you make are used entirely at your own risk — no support will be granted by CacheGuard Technologies for modified versions

If you modify any CacheGuard-OS source code or any of the integrated open-source components, you acknowledge that all your contributions are used at your own risk and that CacheGuard Technologies strongly recommends leaving the source code as is.

For the complete license agreement, please refer to the [CacheGuard-OS License Agreement](../Documentation/CacheGuard-OS-License-Agreement.pdf) or read it online at [cacheguard.net/doc/command/license.html](https://www.cacheguard.net/doc/command/license.html).

---

## Structure

The CacheGuard-OS source code is organized into the following directories:

- **Sources/ETC** — various files used by CacheGuard-OS
- **Sources/GUI** — the web UI source code
- **Sources/Embedded** — source code for the embedded applications within CacheGuard-OS
- **Sources/Documentation** — source code for inline documentation
- **Sources/Shared** — common (shared) programs used by different modules
- **Sources/Scripts** — various script files used by CacheGuard-OS
- **Sources/Commands** — all command-line (CLI) programs
- **Sources/Configurator** — programs that generate low-level configuration files from the CacheGuard-OS configuration defined by the administrator
- **Sources/InitScripts** — source code for the Linux init scripts
- **Sources/Tuner** — programs that configure the appliance during installation, based mainly on its available resources
- **Logo** — logo images in different formats
- **OS** — scripts used to create an archive of all programs for copying onto the installation CD-ROM
- **RunTimeLFS** — all programs used to build a runtime operating system; only the components required by the appliance are retained, all others are removed from the runtime version (**CAUTION: Dangerous Scripts**)
- **Install** — programs used to install the OS on bare metal or virtual machines
- **Patch** — programs for building patches to upgrade an already installed OS

---

## Why Publish the Source?

CacheGuard-OS has always been open source. Publishing the full source code is the natural next step — it allows the community to:

- **Audit** the security of a system that sits at the heart of your network
- **Understand** exactly how each security feature is implemented
- **Learn** from a real-world, production-grade network security OS
- **Contribute** bug reports, suggestions and improvements

For a security appliance, transparency is not optional. You should never have to trust a black box with your network.

---

## Contributing

Contributions are welcome. If you find a bug or want to suggest an improvement:

- Open an issue in the main repository
- Submit a pull request with a clear description of your change
- Join the community forum at [help.cacheguard.net](https://help.cacheguard.net/) to discuss ideas

Please note that all contributions are reviewed by CacheGuard Technologies before being merged, and must be compatible with the GPL v3 license.

---

## Copyright

Copyright (C) 2002-2026 CacheGuard Technologies — All rights reserved.

For more information visit [cacheguard.com](https://www.cacheguard.com/).
