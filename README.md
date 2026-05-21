# Trading bot hamster-bot 
# for exchanges: BitMEX, FTX, Bybit, Binance, Huobi, Kucoin

Automated trading system | 
Cryptocurrency Algorithmic trading bot

![hamster-bot logo](/logo.png) 

__hamster-bot releases download links:__
* __Latest Win version__ [hb.zip](https://github.com/ksandric/hamster-bot/blob/master/hb.zip?raw=true)
* __Release Linux version__ [hb_linux-x64.zip](https://github.com/ksandric/hamster-bot/blob/master/hb_linux-x64.zip?raw=true)  ? *[Инструкция](https://t.me/bothamster/309)*

__Links:__
* site [hamster-bot.com](https://hamster-bot.com)

__Contacts:__
* telegram channel [t.me/bothamster](https://t.me/bothamster)
* telegram main chat [t.me/bitmextrue](https://t.me/bitmextrue)
* telegram EN chat [https://t.me/hamster_EN](https://t.me/hamster_EN)
* telegram developer [t.me/dreamcast2](https://t.me/dreamcast2)

# API — MapAPI_Endpoints

Все эндпоинты требуют аутентификации через cookie-токен (выдаётся при входе).  
При отсутствии/невалидном токене: **401 `Fail`**
Аутентификацию можно отключить в конфиге settings_program.json но не делайте этого с открытым портом в интернет!

---

## Настройки (чтение)

### GET /api/settings/config
Возвращает глобальный конфиг программы (`settings_program.json`).  
`telegram.bot_token` — замаскирован (первые 4 символа + `****`).

**Ответ 200:**
```json
{
  "name": "MyBot",
  "use_web": true,
  "port": 5000,
  "telegram": {
    "bot_token": "1234****",
    "id_chat": 123456789
  }
}
```

**Ошибки:** `503 {}` — конфиг не загружен

---

### GET /api/settings/accounts
Возвращает список всех аккаунтов (`SETTINGS_ACCOUNTS`).

**Ответ 200:**
```json
[
  {
    "name": "main",
    "exchange": "Binance",
    "api_key": "abc123",
    "api_secret": "..."
  }
]
```

---

### GET /api/settings/accounts/{name}
Возвращает один аккаунт по имени (case-insensitive).

**Запрос:** `GET /api/settings/accounts/main`

**Ответ 200:**
```json
{
  "name": "main",
  "exchange": "Binance",
  "api_key": "abc123"
}
```

**Ошибки:** `404 {}` — не найден

---

### GET /api/settings/strategy
Возвращает список всех стратегий (`SETTINGS_STRATEGY`).

**Ответ 200:**
```json
[
  {
    "name": "T4 BTC",
    "is_runing": true,
    "exchange": { "account": "main" },
    "basic": { "symbol": "BTCUSDT" }
  }
]
```

---

### GET /api/settings/strategy/{name}
Возвращает одну стратегию по имени (case-insensitive).

**Запрос:** `GET /api/settings/strategy/T4%20BTC`

**Ответ 200:**
```json
{
  "name": "T4 BTC",
  "is_runing": true
}
```

**Ошибки:** `404 {}` — не найдена

---

## Текущее состояние (чтение)

### GET /api/current/ubots
Возвращает список всех запущенных ботов (`UBOTS`) в полном виде.

**Ответ 200:**
```json
[
  {
    "BOTS": [ { ... } ]
  }
]
```

---

### GET /api/current/ubots/{accountName}/{settingsName}
Возвращает один бот по аккаунту и имени стратегии.

**Запрос:** `GET /api/current/ubots/main/T4%20BTC`

**Ответ 200:**
```json
{
  "account": { "name": "main", "exchange": "Binance" },
  "settings": { "name": "T4 BTC" },
  "CURRENT_POSITION": { ... },
  "CURRENT_ORDERS": [ ... ]
}
```

**Ошибки:** `404 {}` — не найден

---

### GET /api/current/positions
Возвращает позиции по всем ботам.

**Ответ 200:**
```json
[
  {
    "account": "main",
    "exchange": "Binance",
    "strategy": "T4 BTC",
    "symbol": "BTCUSDT",
    "position": {
      "Symbol": "BTCUSDT",
      "Side": "Buy",
      "Size": 0.01,
      "EntryPrice": 65000.0,
      "Cost": 650.0,
      "UnrealizedPnl": 12.5,
      "Leverage": 10,
      "Cross": false
    }
  },
  {
    "account": "sub1",
    "exchange": "Binance",
    "strategy": "T3 ETH",
    "symbol": "ETHUSDT",
    "position": null
  }
]
```

---

### GET /api/current/orders
Возвращает активные ордера по всем ботам.

**Ответ 200:**
```json
[
  {
    "account": "main",
    "exchange": "Binance",
    "strategy": "T4 BTC",
    "symbol": "BTCUSDT",
    "order": {
      "Id": "order-123",
      "client_id": "cl-456",
      "Market": "BTCUSDT",
      "Side": "Buy",
      "Type": "Limit",
      "Status": "New",
      "Size": 0.01,
      "filledSize": 0.0,
      "remainingSize": 0.01,
      "Price": 64000.0,
      "TriggerPrice": null,
      "ReduceOnly": false
    }
  }
]
```

---

## Управление ботами (действия)

### POST /api/bots/pause-all
Ставит `is_runing = false` для всех ботов и сохраняет в файл.

**Ответ 200:**
```json
{ "success": true, "count": 5 }
```

---

### POST /api/bots/play-all
Ставит `is_runing = true` для всех ботов и сохраняет в файл.

**Ответ 200:**
```json
{ "success": true, "count": 5 }
```

---

### POST /api/bots/{accountName}/{settingsName}/pause
Останавливает один бот.

**Запрос:** `POST /api/bots/main/T4%20BTC/pause`

**Ответ 200:**
```json
{ "success": true, "name": "T4 BTC", "is_runing": false }
```

**Ошибки:** `404` — бот не найден, `500` — ошибка сохранения

---

### POST /api/bots/{accountName}/{settingsName}/play
Запускает один бот.

**Запрос:** `POST /api/bots/main/T4%20BTC/play`

**Ответ 200:**
```json
{ "success": true, "name": "T4 BTC", "is_runing": true }
```

---

## Управление позициями

### POST /api/positions/{accountName}/{settingsName}/close
Закрывает позицию конкретного бота.

**Запрос:** `POST /api/positions/main/T4%20BTC/close`

**Ответ 200:**
```json
{ "success": true }
```

**Ошибки:** `404` — бот не найден

---

### POST /api/positions/{accountName}/close-all
Закрывает все открытые позиции на аккаунте (пропускает ботов с `Size == 0`).

**Запрос:** `POST /api/positions/main/close-all`

**Ответ 200:**
```json
{ "success": true, "count": 3 }
```

---

## Управление ордерами

### POST /api/orders/{accountName}/{settingsName}/{orderId}/cancel
Отменяет один ордер. Stop-ордера (`Type == "stop"`) отменяются через `CancelTriggerOrder`.

**Запрос:** `POST /api/orders/main/T4%20BTC/order-123/cancel`

**Ответ 200:**
```json
{ "success": true }
```

**Ошибки:** `404` — ордер не найден, `500` — биржа вернула ошибку

---

### POST /api/orders/{accountName}/cancel-all
Отменяет все ордера на аккаунте (по всем ботам аккаунта).

**Запрос:** `POST /api/orders/main/cancel-all`

**Ответ 200:**
```json
{ "success": true, "count": 2 }
```

---

## Управление настройками (запись)

### POST /update/settings
Обновляет настройки стратегии. Тело запроса — JSON объект `Settings`.

**Запрос:**
```
POST /update/settings
Content-Type: application/json

{ "name": "T4 BTC", "is_runing": false, ... }
```

**Ответ:** `OK` | `Fail`

---

### POST /update/config
Обновляет `settings_program.json` и применяет сразу. `telegram.bot_token` из тела игнорируется — остаётся текущий.

**Запрос:**
```
POST /update/config
Content-Type: application/json

{ "name": "MyBot", "use_web": true, "port": 5000, ... }
```

**Ответ:** `OK` | `Fail`

---

### POST /update/config/tester
Обновляет `config_tester.json`.

**Запрос:**
```
POST /update/config/tester
Content-Type: application/json

{ ... }
```

**Ответ:** `OK` | `Fail`

---

### POST /update/api
Сохраняет данные аккаунта (API ключи) в файл. Для применения требуется перезапуск.

**Запрос:**
```
POST /update/api
Content-Type: application/json

{ "name": "main", "exchange": "Binance", "api_key": "...", "api_secret": "..." }
```

**Ответ:** `OK` | `Fail`

---

### POST /delete/api
Удаляет аккаунт из файла и из `SETTINGS_ACCOUNTS`.

**Запрос:**
```
POST /delete/api
Content-Type: application/json

{ "name": "main" }
```

**Ответ:** `OK` | `Fail`

---

### POST /api/delete/{accountName}/{settingsName}
Удаляет бота: удаляет файл стратегии, ставит `is_live = false`, убирает из `UBOTS`.

**Запрос:** `POST /api/delete/main/T4%20BTC`

**Ответ 200:**
```json
{ "success": true }
```

**Ошибки:** `404` — бот не найден

---

## Коды ответов

| Код | Значение |
|-----|----------|
| 200 | Успех |
| 401 | Не авторизован (невалидный cookie-токен) |
| 404 | Ресурс не найден |
| 500 | Внутренняя ошибка сервера |
| 503 | Сервис недоступен (конфиг не загружен) |
