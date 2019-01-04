# Introduction

Emacs for Windows historically has been distributed in the form of ZIP archives. It is a very compatible way of distribution which allows the software to be used in the cases where the other methods of installation are unavailable. Yet, in some use cases, the full-featured installer makes more sense.

This project is my humble contribution to the Emacs community. It provides all the necessary code to build an MSI-installer for Emacs which features some basic optional integration with the Windows operating system. MSI installers also have some other benefits.

The project is a result of me solving the same task for another project which I help to maintain ([Corman Lisp](https://github.com/sharplispers/cormanlisp)).

All the installers available in the project's download section bundle official, unmodified binaries of Emacs for Windows obtained directly from the [main GNU FTP-site.](http://ftp.gnu.org/gnu/emacs/windows/)


# How to Build the Installer Manually

Building the installer is easy. Please follow these steps:

1. Download and install [WiX 3.x](http://wixtoolset.org/releases/).
2. Download an Emacs binary ZIP-archive from the [main GNU FTP-site](http://ftp.gnu.org/gnu/emacs/windows/) (e.g. [emacs-26.1-x86_64.zip](http://ftp.gnu.org/gnu/emacs/windows/emacs-26/emacs-26.1-x86_64.zip)).
3. Unpack the archive to the `emacs` directory.
4. Run `makemsi.bat` to build the installer. It might take up to 20 minutes to complete.

A new, properly named installer file (e.g. `emacs-26.1-x86_64.msi`) and corresponding debugging information file (e.g. `emacs-26.1-x86_64.wixpdb`) will appear in the project's root directory.


# Note to the Fellow Developers

You might want to adapt the installer for a different project. Also, you might want to build your own, pre-configured version of Emacs which suits your needs. It is perfectly fine, especially considering that it is not easy to stumble upon a full installer built using the [WiX Toolset](http://wixtoolset.org/). In fact, the project is structured in a way which makes it easier to reuse. Moreover, it is distributed under the terms of [CC0 License](https://creativecommons.org/share-your-work/public-domain/cc0/) (basically it is public domain).

If this is your intentions, please, *please*, replace the `UpgradeCode` value in the `installer\Config.wxi` with your own, unique GUID. It is necessary to avoid conflicts with my Emacs installers. Thank you!

