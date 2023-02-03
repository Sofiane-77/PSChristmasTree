# Security Policy

## Supported Versions
The [latest released version](https://github.com/Sofiane-77/PSChristmasTree/releases) of PSChristmasTree is supported.

## Reporting a Vulnerability - Private Disclosure Process
Security is of the highest importance and all security vulnerabilities or suspected security vulnerabilities should be reported to PSChristmasTree privately, to minimize attacks against current users of PSChristmasTree before they are fixed. Vulnerabilities will be investigated and patched on the next patch (or minor) release as soon as possible. This information could be kept entirely internal to the project.  

If you know of a publicly disclosed security vulnerability for PSChristmasTree, please **IMMEDIATELY** contact [PSChristmasTree@caramail.com](mailto:PSChristmasTree@caramail.com).

**IMPORTANT: Do not file public issues on GitHub for security vulnerabilities**

To report a vulnerability or a security-related issue, please email the private address [PSChristmasTree@caramail.com](mailto:PSChristmasTree@caramail.com) with the details of the vulnerability and the word "SECURITY" in the subject line. Emails will be addressed as fast as possible, including a detailed plan to investigate the issue and any potential workarounds to perform in the meantime. Do not report non-security-impacting bugs through this channel. Use [GitHub issues](https://github.com/Sofiane-77/PSChristmasTree/issues/new/choose) instead.

### Proposed Email Content
Provide a descriptive subject line and in the body of the email include the following information:
* Basic identity information, such as your name and your affiliation or company.
* Detailed steps to reproduce the vulnerability  (POC scripts, screenshots, and compressed packet captures are all helpful to us).
* Description of the effects of the vulnerability on PSChristmasTree and the related hardware and software configurations.
* How the vulnerability affects PSChristmasTree usage and an estimation of the attack surface, if there is one.
* List other projects or dependencies that were used in conjunction with PSChristmasTree to produce the vulnerability.

## When to report a vulnerability
* When you think PSChristmasTree has a potential security vulnerability.
* When you suspect a potential vulnerability but you are unsure that it impacts PSChristmasTree.
* When you know of or suspect a potential vulnerability on another project that is used by PSChristmasTree.
  
## Patch, Release, and Disclosure
The vulnerability reports will be answered as follows:

1.  The vulnerability will be examined to determine its effects and criticality.
2.  If the problem is not considered a vulnerability, the detailed reason for this rejection will be given.
3.  Conversation will be initiated with the reporter as fast as possible.
4.  If a vulnerability is acknowledged,mitigating steps that affected users can take to protect themselves until the fix is implemented will be developed as a priority.
5.  [CVSS](https://www.first.org/cvss/specification-document) using the [CVSS Calculator](https://www.first.org/cvss/calculator/3.0) will be created. It is better to move quickly than making the CVSS perfect. Issues may also be reported to [Mitre](https://cve.mitre.org/) using this [scoring calculator](https://nvd.nist.gov/vuln-metrics/cvss/v3-calculator). The CVE will initially be set to private.
6.  A fix of the vulnerability will be in progress and internal testing before preparing to roll out the fix will be performed.
7.  We prefer to fully disclose the bug as soon as possible once a user mitigation or patch is available. It is reasonable to delay disclosure when the bug or the fix is not yet fully understood, the solution is not well-tested, or for distributor coordination. The timeframe for disclosure is from immediate (especially if it’s already publicly known) to a few weeks. For a critical vulnerability with a straightforward mitigation, we expect report date to public disclosure date to be as fast as possible.
8.  Once the fix is confirmed, the vulnerability will be fixed in the next patch or minor release. Upon release of the patched version of PSChristmasTree, we will follow the **Public Disclosure Process**.

### Public Disclosure Process
Public [advisory](https://github.com/Sofiane-77/PSChristmasTree/security/advisories) to the PSChristmasTree community via GitHub will be released. 

Any mitigating steps users can take until the fix can be applied to their PSChristmasTree instances will be published.

## Confidentiality, integrity and availability
We consider vulnerabilities leading to the compromise of data confidentiality, elevation of privilege, or integrity to be our highest priority concerns. Availability, in particular in areas relating to DoS and resource exhaustion, is also a serious security concern. All vulnerabilities, potential vulnerabilities and suspected vulnerabilities will be taken seriously and will be investigated in an urgent and expeditious manner.
