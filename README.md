# atlabs Gentoo Overlay

A custom Gentoo Portage overlay for atlabs, featuring specialized tools and development SDKs.

## Packages

Current featured packages:
- `dev-util/flutter-sdk`: Google's UI toolkit for building natively compiled applications.

## Installation

### Using eselect-repository

The easiest way to add this overlay is using `eselect repository`:

1.  Sync the repository:
    ```bash
    sudo eselect repository add atlabs git https://github.com:project3301/gentoo-overlay.git
    sudo emaint sync -r atlabs
    ```

### Manual Method

Alternatively, you can add it manually by creating a file at `/etc/portage/repos.conf/atlabs.conf`:

```ini
[atlabs]
location = /var/db/repos/atlabs
sync-type = git
sync-uri = https://github.com:project3301/gentoo-overlay.git
auto-sync = yes
```

Then sync:
```bash
sudo emaint sync -r atlabs
```

## Usage

Once installed, you can emerge packages from this overlay:

```bash
emerge --ask dev-util/flutter-sdk
```

## Maintenance

To sync the overlay to the latest version:

```bash
sudo emaint sync -r atlabs
```
