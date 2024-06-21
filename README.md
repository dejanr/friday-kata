# firday-kata

#### One-stop reference to build friday-kata

### [![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

[![Nix Flake](https://github.com/dejanr/friday-kata/actions/workflows/nix-flake.yml/badge.svg)](https://github.com/dejli/friday-kata/actions/workflows/nix-flake.yml)

Pick the kata from [kata-log.rocks](https://kata-log.rocks/)

## Structure

- [Get Started](#get-started)
  - [Prerequisites](#prerequisites)
  - [Setup](#setup)
- [Usage](#usage)

## Get Started

Before exploring the project, there are several things that need to be prepared first as explained below.


### Prerequisites

Make sure that you have the following package installed in your machine:

- `nix` (follow [this guide](https://nixos.wiki/wiki/Nix_Installation_Guide)) with flakes enabled
- `git`

### Setup

#### Non-nix-flake user

This repository can be used using plain `nix-build` or `nix-shell`. This is possible with the help of `flake-compat` as mentioned in [default.nix](./default.nix). To build the package, just run:

```
$ nix-build -A defaultNix.legacyPackages.x86_64-linux.nix.typescript
```

and to enter into Nix shell, run:

```
$ nix-shell
```

#### Nix-flake user

If you want to use this repo with `flakes` feature, please enable it using the following method:

**Linux and Windows Subsystem Linux 2 (WSL2)**

Install Nix as instructed above. Next, install `nixUnstable` by running the following code:

```
nix-env -iA nixpkgs.nixFlakes
```

Lastly, open your `~/.config/nix/nix.conf` or `/etc/nix/nix.conf` file and add:

```
experimental-features = nix-command flakes
```

**NixOS**

Add the following code into your `configuration.nix`:

```
{ pkgs, ... }: {
  nix = {
    package = pkgs.nixFlakes;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
  };
}
```

## Usage

Clone this repository, and enter into it:

```
$ git clone https://github.com/dejli/friday-kata.git
$ cd friday-kata
```

run `nix develop` and wait until the downloading/caching the dependencies are finished.

Once it is finished, you can refer to the documentation below:

Building package in Nix Flakes is simply by running the following code:

```
nix build .#friday-kata.nix.typescript
```

The above example will build `friday-kata-typescript` package which is a node project built with yarn and typescript. Here is the breakdown of the command:

- `nix build` - is a nix v2 command to build package
- `.#friday-kata.nix.typescript`
  - `.` - it means the directory contain `flake.nix`,
  - `#` - it is to separate between directory and package,
  - `friday-kata.nix.typescript` - is the package describe in the [overlay](overlay.nix) that we want to build.

The result of the build will be available in the `result` folder.

### **Run**

By running `nix develop` in the project, some command as written in [devshell.nix](devshell.nix) will be available in the `PATH`.

There is also custom script that can be created to simplify the command as specified in the `commands` attributes in [devshell.nix](devshell.nix).

Please refer to [devshell.nix](devshell.nix) for further commands and packages.

[[Back to the Table of Contents] ↑](#structure)
