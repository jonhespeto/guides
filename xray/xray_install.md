Run this command to generate short IDs, You can have multiple short IDs or just one. Save it for later.
```
openssl rand -hex 8
```

Generate UUID for config.json save this for later. Replace Secret with any random text/string
```
./xray uuid -i Secret
```
It should look something like this.

92c96807-e627-5328-8d85-XXXXXXXXX

Generate Private and Public keys and save it for later
```
./xray x25519
```
It should look something like this.

Private key: qBvFzkSMcgrXXXXXJu2VSt3-0dCy-XX8IXXXXXXXXXX

Public key: rhrL9r_VGMWtwXXXXHO_eAi5e4CIn_XXXXXXXXXXXXX