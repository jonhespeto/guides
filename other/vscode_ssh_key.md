Install "Remote-SSH" extensions

Make ssh keys

```bash
ssh-keygen -t ed25519 -C "email@example.com"
```

Copy to remote server 

```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub <some_user>@192.168.1.1
```
Open "Configure SSH hosts..." in VScode

```
Host 192.168.1.1
    Port <some_port>
    User <some_user>
  IdentityFile /home/<some_user>/.ssh/id_ed25519.pub
```