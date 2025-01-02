### The actual key file was stored in a dedicated zfs volume call keystore, and it was protected by Luks encryption. That's the prompt-up on the boot screen which asks for your password.

### If you would like to decrypt and mount the ZFS volumes on another machine, first, open the Luks filesystem to get the key file, for example:

``` bash
sudo cryptsetup open /dev/zvol/rpool/keystore zfskey
```

It will create a new device under the /dev directory, e.g. /dev/dm-0. You can mount it via the Nautilus file manager easily. Supposedly there is only one file, i.e. system.key.

With that key file you can decrypt your ZFS pool, for example:
```bash
sudo cat /path/to/system.key | sudo zfs load-key -L prompt rpool
```
Finally, mount the ZFS volume. You might need to change the mountpoint to somewhere before actually mount the volume. For example:
```bash
sudo zfs get mountpoint rpool/USERDATA/username_1b23ae
#(Backup the oritional mountpoint value)
sudo zfs set mountpoint=/mnt rpool/USERDATA/username_1b23ae
sudo zfs mount rpool/USERDATA/username_1b23ae
```

### The alternate mount procedure can be simplified by importing the pool using the

```bash
-R <temp_mountpoint> 
```
which doesn't require setting and then restoring the mountpoint property. I'd also suggest to suggest 
```bash
zfs mount -a 
```
as a shortcut to mount everything (Ubuntu for example, uses many datasets, so it's tedious to mount them one by one).


## If the system boots in recovery mode (for example ubuntu), mount ZFS using the password