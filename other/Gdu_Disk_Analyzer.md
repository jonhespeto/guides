### Installing Gdu Disk Analyzer on Ubuntu 20.04.
```bash
sudo apt update
sudo apt upgrade
```
Now we run the following command to download GDU from its Github repository using curl:

```bash
curl -L https://github.com/dundee/gdu/releases/latest/download/gdu_linux_amd64.tgz | tar xz
```

Then, make it an executable file:
```bash
chmod +x gdu_linux_amd64
```

After that, move the file to the /usr/bin directory:
```bash
sudo mv gdu_linux_amd64 /usr/bin/gdu
```