#!/bin/bash
# turn on debugging if we ask
[ "$1" == "-d" ] && set -x
#
# <bitbar.title>Show Bitcoin BTC, Ripple XRP, Litecoin LTC prices from Bitstamp</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Warren Lindsey</bitbar.author>
# <bitbar.author.github>elwarren</bitbar.author.github>
# <bitbar.desc>Show Bitcoin BTC, Ripple XRP, and Litecoin LTC prices from Bitstamp</bitbar.desc>
# <bitbar.image>http://i.imgur.com/AAFdAli.png</bitbar.image>
# <bitbar.dependencies>jq,curl,bash</bitbar.dependencies>
# <bitbar.abouturl>https://github.com/elwarren/bitbar-bitstamp-btc-xrp</bitbar.abouturl>

# Show Bitcoin BTC, Ripple XRP, and Litecoin LTC prices from public Bitstamp API https://www.bitstamp.net/api/
# Do not make more than 600 requests per 10 minutes or Bitstamp will ban your IP address!
# Trade data from last hour or last day, coin, and fiat configurable by filename:
#
# bitstamp-btc-usd-h.1m.sh show btc to usd rate over last hour fetched every 1 minute
# bitstamp-xrp-eur-d.5m.sh show xrp to eur rate over last 24 hours fetched every 5 minutes
# bitstamp-ltc-usd-d.5m.sh show ltc to usd rate over last 24 hours fetched every 5 minutes
#
# Supported currency pairs:
# btc usd
# btc eur
# eur usd
# xrp usd
# xrp eur
# xrp btc
# ltc usd
# ltc eur
# ltc btc

# parse options out of filename bitstamp-btc-usd-h.1m.sh
# the spaces are required for negative offset
COIN=${0: -15:3}
CURRENCY=${0: -11:3}
TIME=${0: -7:1}
[ ${TIME} == "h" ] && TIME="hour"
[ ${TIME} == "d" ] && TIME="day"
TIMEOUT=30
PATH="~/bin:/usr/local/bin:/usr/bin:/bin"

# "Bitcoin, btc, cryptocurrency icon" by AllienWorks licensed under
# Creative Commons (Attribution 3.0 Unported) https://creativecommons.org/licenses/by/3.0/
# from https://www.iconfinder.com/icons/1175251/bitcoin_btc_cryptocurrency_icon#size=16
ICON_BTC="iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAABHklEQVQ4T63TvyvFYRTH8de1SCnJYBJhsMhoUQbZbIoibCaDJCODv0IWJIOyiEVY/MhgMJABGwsjRqVTz9W3b/fLveWpZ3k6530+5zyfU1L5XOMFS7jDNHYqhZYKADd4xiLuMYXtvwDz6EhBk3jHWaq+j/J9y4KyCq7QX6Co/PyJcRyWH/ItNOMBLThN1ZswhpWUdIveIkC8P6IrVRnJKHpCJ17RWgugPinYQB3WMVsN4AvRc2NKjJwY7AQOqgGE5F00oA+DGdAMtgJSyQdFMwgzbabKxxiuFTCQfBF58UNDeUAburGH+M5zLKQZRAthtPakYBXLecBadrq/GOoIo/jIA+bQkxLDbRFwgbB12PgEl4hF+zn/ukxZcNXb+A1uJUMR0Pz7NAAAAABJRU5ErkJggg=="

# "Ripple, xrp icon" by AllienWorks licensed under
# Creative Commons (Attribution 3.0 Unported) https://creativecommons.org/licenses/by/3.0/
# from https://www.iconfinder.com/icons/1175359/ripple_xrp_icon#size=16
ICON_XRP="iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAABMElEQVQ4T43Tv0uWYRTG8c/rz8qGZgMHqS1EESIQ91QCHRxUhHZByCFoUBQn/QOcHHVoTCnQRYhAKEkpcApsEBHFQYc2TQ7cLzw8vA/cZ7vhOt9zrnPOXZMXj7CMcTTjMz7gqpaX7wuGStojvMwB9OFnRaGxHMAbbFUAZouA8NaNa1wUEjrxF60NIK/qgNdYx9MkCs9vcZneMbThEmANMwF4jl94UBJ8Q4A78ANdOMT3tIXt0AdgCQsVHv+hBW04Rg9ui9oArOB9xjp/oxd3ZcAgvjYAnCQL0cFums9+srOHT/hfH+I8FtGUQGcYQRxLxAamSkU+YqK4xmcYwA12EP4jHiKATxp0OZpzSP04qJjRag4gbuO0AvAuBxC5m5gsQc7xIhfQnr7zNB4jtjCHP/dAWjVmpj8f2wAAAABJRU5ErkJggg=="

# "Litecoin, ltc icon" by AllienWorks licensed under
# Creative Commons (Attribution 3.0 Unported) https://creativecommons.org/licenses/by/3.0/
# from https://www.iconfinder.com/icons/1175272/litecoin_ltc_icon#size=16
ICON_LTC="iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAABE0lEQVQ4T5XSPyhHURjG8c+PMrHIYPFnwMCobLKyGETZpEQGmwyyGww2ZLBQSrJYjEaDTDb5n0H5DTYD0amjTrr3dty6dbvv83zP+7zvqSl+BnGZlMZxWiStlQAWsZXU2vH6H8AeZqPhCV0lBynr4BoD0XSMqfgdooV39xdYBGjGOxqiaAWbWMUaZnBYBRjBedLyPOYwFOcQOnipAixjIwF8oREnWMBbOo+iCEdJ5qANcZawn7uFe3RHcbgLE3jO2UIbtjGZiMN92Ckzh/9phEd0/hGHgV3lADpwiwf0RsMHWvCZA+hHE9YxGg0XGK4wh+18/91CHa1VJya1MZylgB7cZJqDLAy9ngKmcZAJuENf0P4A/HEtEf0rUI8AAAAASUVORK5CYII="

URL_H_BTC="https://www.bitstamp.net/api/v2/ticker_hour/btcusd/"
URL_D_BTC="https://www.bitstamp.net/api/v2/ticker/btcusd/"
URL_H_XRP="https://www.bitstamp.net/api/v2/ticker_hour/xrpusd/"
URL_D_XRP="https://www.bitstamp.net/api/v2/ticker/xrpusd/"
URL_H_LTC="https://www.bitstamp.net/api/v2/ticker_hour/ltcusd/"
URL_D_LTC="https://www.bitstamp.net/api/v2/ticker/ltcusd/"

if [ ${TIME} == "hour" ];then
    URL="https://www.bitstamp.net/api/v2/ticker_hour/${COIN}${CURRENCY}/"
else [ $TIME == "day" ]
    URL="https://www.bitstamp.net/api/v2/ticker/${COIN}${CURRENCY}/"
fi

# grab latest data
J=$(curl -s --max-time ${TIMEOUT} ${URL} 2>/dev/null)

# not really secure but hey we're already trusting them with our money
eval "$( echo $J \
    | jq -r '@sh "high=\(.high) last=\(.last) timestamp=\(.timestamp) bid=\(.bid) vwap=\(.vwap) volume=\(.volume) low=\(.low) ask=\(.ask) open=\(.open)"'
)"

# be explicit, mac osx /bin/date supports -r but gnu does not
ts=$(/bin/date -r $timestamp)

# finally display menu
[ ${COIN} == btc ]&&echo "${last}|templateImage=${ICON_BTC}"
[ ${COIN} == xrp ]&&echo "${last}|templateImage=${ICON_XRP}"
[ ${COIN} == ltc ]&&echo "${last}|templateImage=${ICON_LTC}"
echo "---"
echo "${COIN} / ${CURRENCY} last ${TIME}|href=https://www.bitstamp.net/market/tradeview/"
echo "---"
echo "last $last|href=https://www.bitstamp.net/market/last_trades/"
echo "---"
echo "ask $ask|href=https://www.bitstamp.net/market/order_book/"
echo "bid $bid|href=https://www.bitstamp.net/market/order_book/"
echo "---"
echo "high $high"
echo "low $low"
echo "---"
echo "volume $volume"
echo "vwap $vwap"
echo "open $open"
echo "---"
echo "timestamp $ts"

