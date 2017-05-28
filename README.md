# Bitbar plugin bitbar-bitstamp-btc-xrp

Show Bitcoin BTC and Ripple XRP prices from public [Bitstamp API](https://www.bitstamp.net/api/)

![bitbar-bitstamp-btc-xrp](http://i.imgur.com/AAFdAli.png)

Do not make more than 600 requests per 10 minutes or Bitstamp will ban your IP address.

## Setup

Trade data from last hour or last day, coin, and fiat configurable by filename:

`bitstamp-btc-usd-h.1m.sh` show btc to usd rate over last hour fetched every 1 minute

`bitstamp-xrp-eur-d.5m.sh` show xrp to eur rate over last 24 hours fetched every 5 minutes

Supported currency pairs:

* btc usd
* btc eur
* eur usd
* xrp usd
* xrp eur
* xrp btc

Quick setup:

```
$ brew install jq
$ brew cask install bitbar
$ mkdir -p ~/bin/bitbar
$ cp bitstamp-btc-usd-h.1m.sh ~/bin/bitbar/bitstamp-btc-usd-h.1m.sh
$ cp bitstamp-btc-usd-h.1m.sh ~/bin/bitbar/bitstamp-xrp-usd-h.1m.sh
```

## License

MIT License, see [LICENSE](https://github.com/elwarren/bitbar-bitstamp-btc-xrp/blob/master/LICENSE)

"Bitcoin, btc, cryptocurrency icon" by AllienWorks licensed under
[Creative Commons (Attribution 3.0 Unported)]( https://creativecommons.org/licenses/by/3.0/)
from https://www.iconfinder.com/icons/1175251/bitcoin_btc_cryptocurrency_icon#size=16

"Ripple, xrp icon" by AllienWorks licensed under
[Creative Commons (Attribution 3.0 Unported)](https://creativecommons.org/licenses/by/3.0/)
from https://www.iconfinder.com/icons/1175251/bitcoin_btc_cryptocurrency_icon#size=16
