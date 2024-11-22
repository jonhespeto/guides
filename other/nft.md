### Очистить все цепочки
nft flush ruleset

sudo nft add table filter
sudo nft 'add chain filter INPUT { type filter hook input priority 0 ; policy accept; }'
sudo nft add rule ip filter INPUT tcp dport 58333 counter accept
sudo nft add rule ip filter INPUT tcp dport 443 counter accept
или 1 правилом
sudo nft add rule ip filter INPUT ct state vmap { established : accept, related : accept, invalid : drop }
или двумя
sudo nft add rule ip filter INPUT ct state related,established counter accept
sudo nft add rule ip filter INPUT ct state invalid counter drop

sudo nft add rule ip filter INPUT iifname "lo" counter accept
sudo nft add rule ip filter INPUT ip protocol icmp counter accept
sudo nft add rule ip filter INPUT ip protocol gre ip saddr 213.79.96.14 accept
sudo nft 'chain filter INPUT { policy drop; }'

добавить правило 
sudo nft insert rule ip filter INPUT position 4 tcp dport 443 ct state new counter accept

nft insert rule ip filter INPUT position 2 ct state vmap { established : accept, related : accept, invalid : drop }

посмотреть с хендлами
nft --handle list ruleset

удалить правило 
nft delete rule ip filter INPUT handle 2

Сохраняем 

сначала создаем файлик 
echo "flush ruleset" > /etc/nftables.conf
далее записываем 
nft -s list ruleset >> /etc/nftables.conf
