# you asked

Https://fabricked-attack.github.io/ This is very interesting

---

# gemini response

It absolutely is. The **Fabricked** attack represents a highly significant piece of security research in the realm of confidential computing. Disclosed by researchers at ETH Zurich, it highlights a critical vulnerability in how hardware enforces isolation against untrusted cloud environments.

Here is a breakdown of why this attack is so noteworthy:

**The Target: AMD SEV-SNP**
Confidential computing technologies like AMD SEV-SNP (Secure Encrypted Virtualization-Secure Nested Paging) are designed to allow clients to run workloads in the cloud without having to trust the cloud provider. The hardware is supposed to encrypt virtual machines (CVMs) and protect them from being accessed or tampered with by the underlying hypervisor. 

**How "Fabricked" Breaks the Model**
The researchers found a way to completely bypass these protections using a software-only approach. 
1. **The Flaw:** During the boot process, the untrusted UEFI (which is controlled by the cloud provider) is supposed to lock down configurations for the **Infinity Fabric**—AMD's interconnect architecture that routes data between CPU cores, memory, and co-processors.
2. **The Exploit:** A malicious hypervisor can modify the UEFI to skip these lockdown API calls. This leaves the Infinity Fabric's memory routing rules configurable even after SEV-SNP is activated.
3. **The Manipulation:** The attacker can then alter these routing rules to misroute memory transactions. Specifically, they can intercept and manipulate the read/write operations between the DRAM and the secure co-processor (the PSP), tricking the secure processor into believing SEV-SNP was initialized correctly when it wasn't.

**The Impact**
By "bricking" the SEV-SNP initialization (hence the name *Fabricked*), the attack completely shatters the core security guarantees of confidential computing:
* **Total Access:** The malicious hypervisor gains arbitrary read and write access to the memory of the supposedly secure victim CVM.
* **Forged Attestation:** The attacker can forge attestation reports, meaning the victim's systems will falsely verify that the cloud environment is secure and untampered with.
* **Highly Reliable:** It is a 100% deterministic, software-only exploit that does not require physical access to the hardware or any code execution inside the victim's VM.

The vulnerability was confirmed on AMD Zen 5 EPYC processors. Fortunately, AMD acknowledged the findings and released patches to fix the issue. However, as an architectural vulnerability, it serves as a stark reminder of how complex interconnect routing (like Infinity Fabric) introduces massive attack surfaces that can undermine even the most advanced hardware-based security enclosures.