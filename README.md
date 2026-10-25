# Trading bot hamster-bot 
**Self-hosted** решение — бот запускается на вашем сервере или компьютере. Ваши API ключи и данные никогда не покидают вашу машину.

**Кроссплатформенный** — нативные сборки для  Windows,  Linux и  macOS. Единственный исполняемый файл без зависимостей.
# for exchanges: BitMEX, FTX, Bybit, Binance, Huobi, HTX, Kucoin, Gate.io, Bitget, OKX, MEXC, WEEX, BingX + Tiger (broker bybit, binance)

Automated trading system | 
Cryptocurrency Algorithmic trading bot

![hamster-bot logo](/logo.png) 

__hamster-bot releases download links:__
* __Latest Win version__ [hb.zip](https://github.com/ksandric/hamster-bot/blob/master/hb.zip?raw=true)
* __Release Linux version__ [hb_linux-x64.zip](https://github.com/ksandric/hamster-bot/blob/master/hb_linux-x64.zip?raw=true)

__Links:__
* site [hamster-bot.com](https://hamster-bot.com)
* telegram channel [t.me/bothamster](https://t.me/bothamster)

__Contacts:__
* telegram main chat [t.me/bitmextrue](https://t.me/bitmextrue)
* telegram EN chat [https://t.me/hamster_EN](https://t.me/hamster_EN)
* telegram developer [t.me/dreamcast2](https://t.me/dreamcast2)

![hamster-bot logo](/screenshot.png) 

Для всех стратегий доступны **бэктесты** для проверки и подбора настроек на исторических данных. Встроенный тиковый тестер стратегий с оптимизатором параметров (перебор), построением тепловых карт и 3D Surface для наглядного анализа результатов. [Перейти к тестеру →](https://hamster-bot.com/strategy-tester)

**Уведомления в Telegram**: открытие и закрытие сделок картинкой графика. Алертами при критических уведомлений. Гибкая настройка - отдельный чат для каждой стратегии.

**Торговля по алертам TradingView** через Webhook URL — автоматическое открытие и закрытие позиций по сигналам из TradingView.

**WEB интерфейс** для мониторинга и управления из любого браузера по IP-адресу вашего сервера. Интерактивные обновления в реальном времени без перезагрузки страницы: позиции, баланс, настройки стратегий.

**Self-hosted & кроссплатформенный**. Бот работает на вашем сервере или ПК — API ключи и данные остаются только у вас. Нативные самодостаточные сборки для  Windows,  Linux и  macOS без установки зависимостей.

**HTTP API и MCP для ИИ-ассистентов**. Полное управление ботом и тестером по API с токеном доступа. Встроенный MCP-сервер позволяет подключить Claude или другой MCP-клиент: ассистент сам смотрит состояние ботов, управляет стратегиями и проводит исследования в тестере. [Подробнее ↓](#mcp-для-ии-ассистентов)

**Консольный интерфейс** с режимом dashboard — компактная таблица состояния всех активных ботов в реальном времени.

Оптимизация одновременной работы множества аккаунтов и вариантов настроек в одном боте. Протестирована на стабильность работа более 2000 ботов в одном процессе. При этом потребление ресурсов системы крайне незначительны. Для примера бот работающий на пяти стратегиях по трем аккаунтам потребляет всего 70 МБ памяти.

**Управление капиталом и риск-менеджмент**. Гибкая настройка размера лота: фиксированный (в монетах или USDT), процент от баланса. Широкий набор закрывающих опций: Take Profit, Stop Loss, Trailing Stop, закрытие по сигналам индикаторов ТА. Take Profit по балансу маржи (по эквити). Автоматический перевод прибыли с торгового счёта на счёт финансирования.

Множество доступных торговых стратегий: Трендовые, Контртрендовые, Пробойные, Возврат к среднему
Что позволяет составить комбинацию стратегий для своего уникального портфеля. Есть возможность авторебалансировки портфеля — стратегии делятся профитом/убытком между собой.
Вы можете торговать любую стратегию в hamster-bot — просто оставляйте заявку через форму forms.gle/RLVqNCjg4dtosqmF6
[Описание стратегий → ](https://hamster-bot.com/bot/algo)

**Не хотите настраивать всё самостоятельно?** Есть готовое решение — нажать одну кнопку и всё готово к работе. Команда hamster-bot предоставляет проверенные пресеты стратегий: подключаете пресет — бот сразу начинает торговать по готовой конфигурации без необходимости подбирать параметры самостоятельно. [Готовое решение для инвесторов →](https://hamster-bot.com/phoenix)

Обновление без остановки торговли — установка новой версии бота через кнопку в интерфейсе. Открытые позиции и ордера не закрываются.

**Бесплатный бот.**

# Установка бота на Linux
1. Cоздать новую папку для бота (в примере папка hb1) Таким образом можно установить множество ботов в разные папки hb1, hb2 ... : `mkdir -p /opt/hb1`
2. Перейти в созданную папку: `cd /opt/hb1`
3. Скачать и запустить скрипт install_local.sh: `wget -qO- https://raw.githubusercontent.com/ksandric/hamster-bot/refs/heads/master/install_local.sh | bash`

Для обновления всех активных ботов просто выполните этот скрипт: `wget -qO- https://raw.githubusercontent.com/ksandric/hamster-bot/refs/heads/master/update_all.sh | bash`

# API | Endpoints

__Вы можете управлять ботом через:__
* WEB интерфейс
* HTTP API
* MCP — из ИИ-ассистента (Claude и другие MCP-клиенты)
* и просто редактируя текстовые конфиг файлы .json

HTTP API для управления ботом и тестером: настройки, стратегии, API-ключи бирж, позиции и ордера, логи, запуск тестера и работа с его отчётами.

Адрес — тот же, что у веб-интерфейса: `http://<хост>:<порт>`, порт задаётся полем `port` в `settings_program.json`.

---

## Содержание

[Доступ](#доступ) · [Запросы и ответы](#запросы-и-ответы) · [Настройки](#настройки) · [Стратегии](#стратегии) · [Аккаунты](#аккаунты) · [Боты](#боты) · [Позиции и ордера](#позиции-и-ордера) · [Система и логи](#система-и-логи) · [Тестер](#тестер) · [MCP для ИИ-ассистентов](#mcp-для-ии-ассистентов) · [Коды ответов](#коды-ответов)

---

## Доступ

**Токен API (рекомендуется).** Передавайте в каждом запросе заголовок `Authorization: Bearer <api_token>`:

```bash
curl -H "Authorization: Bearer <api_token>" http://127.0.0.1:5000/api/current/bots
```

`api_token` бот создаёт сам при первом запуске и хранит в `settings_program.json`. Токен работает с любого адреса и при любом значении `auth_telegram`, и вход из браузера его не сбрасывает. Храните токен как пароль: с ним доступно всё, включая торговлю и ключи бирж.

Посмотреть и скопировать токен можно в веб-интерфейсе: «Глобальная конфигурация», блок «Токен API и MCP». Там же кнопка «Выпустить новый»; прежний токен сразу перестаёт действовать. При выключенном входе через Telegram этот блок работает только с этой же машины (`127.0.0.1`). В редакторе конфига, в логе и в ответе `GET /api/settings/config` токен скрыт (видны последние 4 символа), а через редактор и `POST /api/settings/config` его изменить нельзя.

Новый токен через API: `POST /api/settings/api-token/regenerate`, ответ `{ "success": true, "api_token": "..." }`.

**Без токена, с той же машины.** Если вход через Telegram выключен (`"auth_telegram": false`), запросы без токена принимаются только с этой же машины по адресу `127.0.0.1` или `localhost`:

```bash
curl http://127.0.0.1:5000/api/current/bots
```

С других адресов без токена API отвечает `401`. Веб-интерфейс при выключенном входе по-прежнему открыт любому, кто может подключиться к порту, поэтому на сервере с открытым портом оставляйте вход включённым.

**Запросы со страниц других сайтов** (`POST` с заголовком `Origin`, не совпадающим с адресом бота) отклоняются с кодом `403` — это защита от CSRF. curl, скрипты и MCP-клиенты заголовок `Origin` не отправляют, их это не касается. Если бот стоит за обратным прокси, прокси должен передавать исходный заголовок `Host`.

**Cookie входа.** Вместо токена можно передавать cookie `hamster-bot-token`, если вход через Telegram включён:

1. `POST /htmx/login/get-token` — бот присылает одноразовый код в Telegram.
2. `POST /htmx/login/verify` с формой `token_enter=<код>` — в ответе приходит заголовок `Set-Cookie: hamster-bot-token=...`.
3. Передавайте cookie в запросах: `curl -b "hamster-bot-token=<значение>" ...`

Cookie действует до 10 дней. Действует только последний вход: новый вход (в том числе из браузера) делает прежний cookie недействительным.

---

## Запросы и ответы

- Тело POST-запросов — JSON в кодировке UTF-8 (`Content-Type: application/json`).
- Имена в пути URL-кодируются: стратегия `T4 BTC` → `/api/settings/strategy/T4%20BTC`.
- Настройки и конфиги передаются и возвращаются в том же виде, что и в JSON-файлах бота.
- Успешное действие возвращает `{ "success": true, ... }`.
- Ошибка возвращает `{ "success": false, "error": "текст ошибки" }` с кодом из таблицы [Коды ответов](#коды-ответов).
- Бот определяется аккаунтом и именем стратегии: `/{accountName}/{settingsName}`. Если стратегия торгует несколькими парами, нужную пару выбирает параметр `?symbol=`. Без него берётся первая.

---

## Настройки

### GET /api/settings/config
Глобальный конфиг программы (`settings_program.json`). Токен Telegram-бота замаскирован: видны первые 4 символа. `api_token` замаскирован: видны последние 4 символа.

**Ответ 200:**
```json
{
  "name": "MyBot",
  "use_web": true,
  "port": 5000,
  "api_token": "••••••••••••b9c2",
  "telegram": {
    "bot_token": "1234************",
    "id_chat": 123456789
  }
}
```

**Ошибки:** `503` — конфиг ещё не загружен

---

### POST /api/settings/config
Изменяет глобальный конфиг и сразу применяет его. Передавайте только поля, которые меняются, — остальные останутся как были. Токен Telegram-бота и `api_token` здесь не меняются: эти поля в теле игнорируются.

**Запрос:**
```json
{ "name": "MyBot", "chart": { "count": 500 } }
```

**Ответ 200:** `{ "success": true }`

**Ошибки:** `400` — пустое тело или неверный JSON, `500` — не удалось сохранить

---

### POST /api/settings/api-token/regenerate
Выпускает новый `api_token`; прежний сразу перестаёт действовать. Это единственный ответ API, в котором токен виден целиком. Тело не нужно.

**Ответ 200:** `{ "success": true, "api_token": "<новый токен>" }`

**Ошибки:** `500` — не удалось сохранить

---

### GET /api/settings/hints/{kind}
Описания полей настроек — те же подсказки, что показывает редактор настроек. `{kind}`:
- `settings` — настройки стратегий (бота и тестера), для всех стратегий сразу;
- `config_tester` — конфиг тестера, включая `parameter_mining`, `walk_forward` и столбцы `reports_history.csv`;
- `settings_program` — глобальный конфиг.

Параметры:
- `?lang=` — `en` (по умолчанию), `ru` или `pt`;
- `?filter=` — только поля, в пути которых есть одна из подстрок через запятую, например `?filter=zigzag,close_by_margin`.

**Ответ 200:** объект «путь поля через точку → описание»:
```json
{
  "parameter_mining": "List of parameters to mine. Each has a name (parameter path) and either a start/end/step range or a values list...",
  "monte_carlo": "Mining limit: if there are more combinations than this number, a random sample of this size is used..."
}
```

**Ошибки:** `404` — неизвестный `{kind}`

---

## Стратегии

### GET /api/settings/strategy
Все стратегии бота.

**Ответ 200:**
```json
[
  {
    "name": "T4 BTC",
    "is_runing": true,
    "exchange": { "name": "binance", "account": "main" },
    "basic": { "symbol": "BTCUSDT", "strategy": "zigzag", "time_frame": "1h" }
  }
]
```

---

### GET /api/settings/strategy/{name}
Одна стратегия по имени (без учёта регистра).

**Ошибки:** `404` — не найдена

---

### POST /api/settings/strategy/draft
Черновик стратегии со значениями по умолчанию для выбранного аккаунта. Ничего не сохраняет: поправьте результат и отправьте в `POST /api/settings/strategy`.

**Запрос:**
```json
{ "account": "main", "symbol": "BTCUSDT", "strategy": "zigzag", "time_frame": "1h", "account_type": "UNIFIED" }
```

Вместо `symbol` можно передать `symbols: ["BTCUSDT", "ETHUSDT"]` — стратегия на несколько пар. `time_frame` (по умолчанию `1h`) и `account_type` необязательны.

**Ответ 200:** объект стратегии

**Ошибки:** `400` — не указаны стратегия или пара, `404` — аккаунт не найден

---

### POST /api/settings/strategy
Создаёт или изменяет стратегию. Тело — объект стратегии, как в `GET /api/settings/strategy/{name}`. Изменения сразу применяются к работающим ботам, новая стратегия сразу запускается.

`?old_name=` — переименовать стратегию `old_name` в имя из тела.

**Запрос:** `POST /api/settings/strategy?old_name=T4%20BTC`

**Ответ 200:**
```json
{ "success": true, "name": "T4 BTC v2", "created": false }
```

`created: true` — стратегия новая.

**Ошибки:** `400` — не заполнены `name`, `exchange.name`, `exchange.account` или `basic.strategy` либо имя содержит недопустимые символы, `500` — не удалось сохранить

---

### POST /api/settings/strategy/{name}/copy
Копирует стратегию под новым именем, сохраняет и запускает копию.

**Запрос:**
```json
{ "new_name": "T4 ETH", "new_symbol": "ETHUSDT" }
```

`new_symbol` необязателен: без него пара остаётся как у исходной стратегии.

**Ответ 200:** `{ "success": true, "name": "T4 ETH" }`

**Ошибки:** `404` — исходная стратегия не найдена, `409` — стратегия с таким именем уже есть

---

### POST /api/settings/strategy/{name}/delete
Удаляет стратегию и останавливает её ботов. Ордера и позиция на бирже при этом не трогаются.

`?full=1` — полное удаление: стратегия ставится на паузу, все её ордера отменяются, позиция закрывается, и только потом стратегия удаляется. Если отменить ордера или закрыть позицию не удалось, стратегия остаётся на паузе и **не** удаляется — позиция не останется без управления.

**Запрос:** `POST /api/settings/strategy/T4%20BTC/delete?full=1`

**Ответ 200:** `{ "success": true }`

**Ошибки:** `404` — не найдена, `409` — для `full=1` стратегия должна быть запущена, `500` — не удалось отменить ордера, закрыть позицию или удалить стратегию

---

## Аккаунты

Аккаунт — это API-ключ биржи, от имени которого торгуют стратегии.

### GET /api/settings/accounts
Все аккаунты.

**Ответ 200:**
```json
[
  {
    "name": "main",
    "exchange": "binance",
    "api_key": "...",
    "api_secret": "...",
    "is_encrypted": true
  }
]
```

---

### GET /api/settings/accounts/{name}
Один аккаунт по имени (без учёта регистра).

**Ошибки:** `404` — не найден

---

### GET /api/settings/accounts/{name}/symbols
Пары, доступные на бирже для этого аккаунта.

**Ответ 200:**
```json
["BTCUSDT", "ETHUSDT"]
```

**Ошибки:** `404` — аккаунт не найден

---

### POST /api/settings/accounts
Создаёт или изменяет аккаунт. Изменения сразу применяются к работающим ботам.

`?old_name=` — переименовать аккаунт `old_name` в имя из тела.

Ключи передаются открытым текстом. При `"is_encrypted": true` бот хранит их зашифрованными. Пустые `api_key`, `api_secret`, `api_passphrase` при изменении оставляют текущие значения; при смене `is_encrypted` ключ и секрет нужно передать заново.

**Запрос:**
```json
{ "name": "main", "exchange": "binance", "api_key": "...", "api_secret": "...", "is_encrypted": true, "open_positions_limiter": 0 }
```

**Ответ 200:**
```json
{ "success": true, "name": "main", "applied": 3 }
```

`applied` — сколько работающих ботов получили новый ключ.

**Ошибки:** `400` — не указаны `name` или `exchange`, недопустимое имя или не хватает ключей при смене `is_encrypted`, `500` — не удалось сохранить

---

### POST /api/settings/accounts/{name}/delete
Удаляет аккаунт.

**Ответ 200:** `{ "success": true }`

**Ошибки:** `404` — не найден, `500` — не удалось удалить

---

### GET /api/current/accounts/{name}/info
Данные аккаунта и ключа с биржи (обновляются раз в час). Нужен хотя бы один запущенный бот на этом аккаунте.

**Ответ 200:**
```json
{
  "name": "main",
  "exchange": "binance",
  "api_key": "abc1****",
  "account_type": "UNIFIED",
  "symbol": "BTCUSDT",
  "ok": true,
  "status": "OK",
  "warnings": [],
  "rows": [ { "name": "Permissions", "value": "..." } ],
  "updated_utc": "2026-10-25T12:00:00Z"
}
```

**Ошибки:** `404` — аккаунт не найден, `409` — на аккаунте нет запущенного бота

---

### GET /api/current/accounts/{name}/balance-history
История баланса аккаунта. `?max=` — не больше стольких точек (по умолчанию 5000).

**Ответ 200:**
```json
{
  "account": "main",
  "total": 12000,
  "points": [ { "time": 1761393600, "margin": 1234.5, "wallet": 1200.0, "positions": "..." } ]
}
```

`time` — Unix-время в секундах, `total` — сколько точек всего в истории.

---

### POST /api/current/accounts/{name}/balance-history/compact
Сжимает историю баланса сейчас по настройкам `monitoring` (обычно это происходит автоматически).

**Ответ 200:**
```json
{ "success": true, "message": "...", "points_before": 12000, "points_after": 3000, "bytes_before": 512000, "bytes_after": 128000 }
```

---

## Боты

Бот — это запущенная стратегия на конкретной паре.

### GET /api/current/bots
Сводка по всем ботам.

**Ответ 200:**
```json
[
  {
    "account": "main",
    "exchange": "binance",
    "strategy": "T4 BTC",
    "strategy_code": "zigzag",
    "symbol": "BTCUSDT",
    "time_frame": "1h",
    "is_runing": true,
    "is_live": true,
    "status_text": "...",
    "last_price": 65500.0,
    "last_bar_time": "2026-10-25T12:00:00",
    "last_sync_utc": "2026-10-25T12:00:05Z",
    "sync_missed_cycles": 0,
    "position": { "side": "Buy", "size": 0.01, "entry_price": 65000.0, "cost": 650.0, "unrealized_pnl": 5.0 },
    "orders": 2
  }
]
```

`is_runing: false` — бот на паузе. `position: null` — позиции нет. `orders` — число открытых ордеров. `sync_missed_cycles` — сколько циклов подряд не удалось получить данные с биржи.

---

### GET /api/current/balances
Баланс кошелька и маржи по каждому API-ключу, отдельно для спота и фьючерсов. `?account=` — только этот аккаунт.

**Запрос:** `GET /api/current/balances?account=main`

**Ответ 200:**
```json
[
  { "account": "main", "exchange": "bybit", "type": "futures", "wallet": 1234.56, "margin": 1180.20 },
  { "account": "main", "exchange": "bybit", "type": "spot", "wallet": 500.00, "margin": 500.00 }
]
```

`wallet` — баланс кошелька, `margin` — маржинальный баланс, как их отдаёт биржа. Для спота оба значения — баланс в USDT. Баланс берётся у запущенных ботов: аккаунт без запущенного бота в список не попадает.

---

### GET /api/current/bots/{accountName}/{settingsName}/bars
Свечи бота. `?limit=` — последние N свечей (по умолчанию 500).

**Запрос:** `GET /api/current/bots/main/T4%20BTC/bars?limit=100`

**Ответ 200:** массив свечей с полями `Timestamp`, `Open`, `High`, `Low`, `Close`, `Volume` и др.

**Ошибки:** `404` — бот не найден

---

### GET /api/current/ubots
Полный снимок состояния всех ботов. Набор полей подробный и может меняться между версиями — для постоянной интеграции используйте `GET /api/current/bots`, `/api/current/positions` и `/api/current/orders`.

---

### GET /api/current/ubots/{accountName}/{settingsName}
Полный снимок состояния одного бота (см. оговорку выше).

**Ошибки:** `404` — бот не найден

---

### POST /api/bots/pause-all
Ставит на паузу всех ботов.

**Ответ 200:**
```json
{ "success": true, "count": 5 }
```

---

### POST /api/bots/play-all
Запускает всех ботов.

**Ответ 200:**
```json
{ "success": true, "count": 5 }
```

---

### POST /api/bots/{accountName}/{settingsName}/pause
Ставит стратегию на паузу (для стратегии на несколько пар — все её пары).

**Запрос:** `POST /api/bots/main/T4%20BTC/pause`

**Ответ 200:**
```json
{ "success": true, "name": "T4 BTC", "is_runing": false }
```

**Ошибки:** `404` — не найдена, `500` — не удалось сохранить

---

### POST /api/bots/{accountName}/{settingsName}/play
Запускает стратегию, поставленную на паузу.

**Ответ 200:**
```json
{ "success": true, "name": "T4 BTC", "is_runing": true }
```

**Ошибки:** `404` — не найдена, `500` — не удалось сохранить

---

### POST /api/bots/{accountName}/{settingsName}/send-chart
Отправляет график бота в Telegram.

**Ответ 200:** `{ "success": true }`

**Ошибки:** `404` — бот не найден, `500` — не удалось построить или отправить график

---

### POST /api/bots/{accountName}/{settingsName}/send-position
Отправляет в Telegram сводку по боту: баланс, позиция, PnL, ордера.

**Ответ 200:** `{ "success": true }`

**Ошибки:** `404` — бот не найден

---

## Позиции и ордера

### GET /api/current/positions
Позиции всех ботов.

**Ответ 200:**
```json
[
  {
    "account": "main",
    "exchange": "binance",
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
    "exchange": "binance",
    "strategy": "T3 ETH",
    "symbol": "ETHUSDT",
    "position": null
  }
]
```

---

### GET /api/current/orders
Открытые ордера всех ботов.

**Ответ 200:**
```json
[
  {
    "account": "main",
    "exchange": "binance",
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

### POST /api/trading/market
Рыночный ордер на аккаунте. Пара должна торговаться одним из ботов этого аккаунта.

**Запрос:**
```json
{ "account": "main", "symbol": "BTCUSDT", "side": "Buy", "size": 0.01 }
```

`side` — `Buy` или `Sell`; `size` — объём в единицах биржи для этой пары.

**Ответ 200:**
```json
{ "success": true, "order_id": "order-123" }
```

**Ошибки:** `400` — неверные `side` или `size`, `404` — на аккаунте нет бота с этой парой, `500` — биржа не приняла ордер

---

### POST /api/positions/{accountName}/{settingsName}/close
Закрывает позицию бота.

**Запрос:** `POST /api/positions/main/T4%20BTC/close`

**Ответ 200:** `{ "success": true }`

**Ошибки:** `404` — бот не найден

---

### POST /api/positions/{accountName}/close-all
Закрывает все открытые позиции аккаунта.

**Ответ 200:**
```json
{ "success": true, "count": 3 }
```

`count` — сколько позиций отправлено на закрытие.

---

### POST /api/positions/{accountName}/reduce
Сокращает все открытые позиции аккаунта на заданный процент.

**Запрос:**
```json
{ "percent": 50 }
```

`percent` — от 1 до 100.

**Ответ 200:**
```json
{ "success": true, "count": 3 }
```

---

### POST /api/orders/{accountName}/{settingsName}/{orderId}/cancel
Отменяет один ордер бота (обычный или стоп-ордер).

**Запрос:** `POST /api/orders/main/T4%20BTC/order-123/cancel`

**Ответ 200:** `{ "success": true }`

**Ошибки:** `404` — ордер не найден, `500` — биржа не отменила ордер

---

### POST /api/orders/{accountName}/cancel-all
Отменяет все ордера аккаунта.

**Ответ 200:**
```json
{ "success": true, "count": 2 }
```

`count` — у скольких ботов отменены ордера.

---

### POST /api/orders/cancel-all
Отменяет все ордера на всех аккаунтах.

**Ответ 200:**
```json
{ "success": true, "count": 7 }
```

---

## Система и логи

### GET /api/system/status
Версия программы, ресурсы сервера и счётчики.

**Ответ 200:**
```json
{
  "program": "hamster-bot",
  "version": "2026/10/23",
  "name": "MyBot",
  "type": "bot",
  "os": "Linux 6.1",
  "architecture": "X64",
  "machine": "srv1",
  "runtime": ".NET 8.0",
  "processors": 4,
  "uptime_sec": 86400,
  "cpu_percent": 12.5,
  "memory_total_bytes": 8589934592,
  "memory_available_bytes": 4294967296,
  "process_memory_bytes": 314572800,
  "disk": "/",
  "disk_total_bytes": 107374182400,
  "disk_free_bytes": 53687091200,
  "accounts": 2,
  "strategies": 5,
  "bots": 6,
  "bots_running": 5,
  "auto_update_supported": true
}
```

---

### POST /api/system/shutdown
Завершает программу. Доступно только при входе через Telegram.

**Ответ 200:** `{ "success": true }` — программа завершится через полсекунды

**Ошибки:** `409` — вход через Telegram не настроен

---

### POST /api/system/update
Запускает обновление программы.

**Ответ 200:** `{ "success": true }`

**Ошибки:** `409` — автообновление на этой системе не поддерживается (см. `auto_update_supported` в `/api/system/status`), `500` — обновление не запустилось

---

### GET /api/logs
Последние строки общего лога. `?tail=` — сколько последних строк (по умолчанию все доступные).

**Ответ 200:** массив строк

---

### GET /api/logs/errors
Ошибки за последние `?hours=` часов (по умолчанию 24, не больше 48). `?warnings=1` — вместе с предупреждениями. Одинаковые сообщения объединены, `count` — сколько раз повторилось.

**Ответ 200:**
```json
[
  {
    "level": "Error",
    "first_utc": "2026-10-25T08:00:00Z",
    "last_utc": "2026-10-25T12:00:00Z",
    "count": 3,
    "source": "T4 BTC",
    "message": "...",
    "exception": "..."
  }
]
```

---

### GET /api/logs/files
Файлы логов, свежие первыми.

**Ответ 200:**
```json
[ { "name": "log_25-10-2026.log", "size": 102400, "modified_utc": "2026-10-25T12:00:00Z" } ]
```

---

### GET /api/logs/files/{filename}
Содержимое файла лога как текст. `?download=1` — скачать файлом.

**Ошибки:** `400` — недопустимое имя файла, `404` — файл не найден

---

## Тестер

Тестер прогоняет стратегии на исторических данных. Перебор параметров, стресс-тест и повтор по snapshot выполняются по одному. Одиночные прогоны можно запускать параллельно. Пока загружаются исторические данные, тестер не запускается, и наоборот — в этих случаях ответ `409`.

Все запуски работают в фоне: ответ приходит сразу, ход и результат — в `GET /api/tester/status`.

### GET /api/tester/status
Состояние тестера.

**Ответ 200:**
```json
{
  "run": {
    "active": true,
    "status": "Running",
    "started_utc": "2026-10-25T12:00:00Z",
    "finished_utc": null,
    "message": "API mining run",
    "runs_done": 40,
    "runs_total": 120,
    "current_bar": 5000,
    "total_bars": 20000,
    "parallel": false
  },
  "wizard_runs": [
    {
      "run_id": "a1b2c3d4",
      "strategies": ["T4 BTC"],
      "status": "Completed",
      "started_utc": "2026-10-25T11:00:00Z",
      "finished_utc": "2026-10-25T11:02:00Z",
      "current_bar": 20000,
      "total_bars": 20000,
      "message": "Completed: 1 strategies."
    }
  ],
  "download": { "active": false, "status": "Idle", "started_utc": null, "finished_utc": null, "message": "" },
  "settings_folder": ""
}
```

- `run` — перебор параметров, стресс-тест или повтор по snapshot. `status`: `Idle`, `Running`, `Completed` или `Failed`; `runs_done` / `runs_total` — сколько комбинаций параметров посчитано.
- `wizard_runs` — одиночные прогоны. Завершённые видны ещё 5 минут.
- `download` — загрузка исторических данных.
- `settings_folder` — текущая папка настроек тестера.

---

### GET /api/tester/config
Конфиг тестера (`config_tester.json`): период, комиссии, параметры перебора и т. д.

---

### POST /api/tester/config
Сохраняет конфиг тестера. Тело — конфиг целиком, как в `GET /api/tester/config`.

**Ответ 200:** `{ "success": true }`

**Ошибки:** `400` — пустое тело или неверный JSON, `500` — не удалось сохранить

---

### GET /api/tester/exchanges
Биржи, для которых тестер умеет загружать исторические данные.

**Ответ 200:** `["bybit", "binance", ...]`

---

### GET /api/tester/exchanges/{exchange}/symbols
Пары биржи. Пустой список — биржа сейчас недоступна; пару можно указать вручную.

**Ошибки:** `404` — тестер не поддерживает эту биржу

---

### GET /api/tester/settings
Настройки стратегий тестера в текущей папке.

**Ответ 200:**
```json
[ { "name": "T4 BTC", "exchange": "bybit", "symbol": "BTCUSDT", "symbols": null, "strategy": "zigzag", "time_frame": "1h" } ]
```

---

### GET /api/tester/settings/{name}
Настройка тестера целиком.

**Ошибки:** `404` — не найдена

---

### POST /api/tester/settings/draft
Черновик настройки тестера со значениями по умолчанию. Ничего не сохраняет.

**Запрос:**
```json
{ "exchange": "bybit", "symbol": "BTCUSDT", "strategy": "zigzag", "time_frame": "1h" }
```

Вместо `symbol` можно передать `symbols` — несколько пар. `account_type` необязателен.

**Ответ 200:** объект настройки

**Ошибки:** `400` — тестер не поддерживает биржу либо не указаны стратегия или пара

---

### POST /api/tester/settings
Сохраняет настройку тестера. Тело — объект настройки. `?old_name=` — переименовать настройку `old_name`. Существующая настройка с тем же именем не перезаписывается.

**Ответ 200:** `{ "success": true, "name": "T4 BTC" }`

**Ошибки:** `400` — не заполнены обязательные поля, `409` — настройка с таким именем уже есть, `500` — не удалось сохранить

---

### POST /api/tester/settings/{name}/copy
Копирует настройку тестера, при желании — на другую биржу или пару.

**Запрос:**
```json
{ "new_name": "T4 BTC binance", "new_exchange": "binance", "new_symbol": "" }
```

Пустые `new_exchange` и `new_symbol` оставляют значения исходной настройки.

**Ответ 200:** `{ "success": true, "name": "T4 BTC binance" }`

**Ошибки:** `404` — исходная настройка не найдена, `409` — имя занято

---

### POST /api/tester/settings/{name}/delete
Удаляет настройку тестера.

**Ответ 200:** `{ "success": true }`

**Ошибки:** `404` — не найдена

---

### GET /api/tester/settings-folder
Текущая папка настроек тестера и её вложенные папки. Папки позволяют держать несколько наборов настроек; `""` — основная папка.

**Ответ 200:**
```json
{ "path": "", "folders": [ { "name": "2026-10", "settings": 12 } ] }
```

`settings` — сколько настроек в папке.

---

### POST /api/tester/settings-folder
Выбирает папку настроек тестера. Влияет на список настроек и на все запуски.

**Запрос:**
```json
{ "path": "2026-10" }
```

**Ответ 200:** `{ "success": true, "path": "2026-10" }`

**Ошибки:** `404` — папка не найдена

---

### POST /api/tester/run
Перебор параметров стратегий (раздел `parameter_mining` конфига тестера).

**Запрос:**
```json
{ "settings": ["T4 BTC", "T4 ETH"], "config": { ... } }
```

`settings` — имена настроек из текущей папки. `config` необязателен: без него используется сохранённый конфиг тестера.

Тестер прогоняет все комбинации значений из `parameter_mining`; если задан `monte_carlo`, то случайную выборку такого размера. Запущенный перебор нельзя остановить, поэтому заранее проверяйте число комбинаций. Ход — в `run` ответа `GET /api/tester/status` (`runs_done` из `runs_total`).

Результаты попадают в папку `report` с именем, равным `name_comment` конфига тестера. Чтобы эксперименты не смешивались, давайте каждому свой `name_comment`. В папке:
- `reports_history.csv` — по строке на комбинацию: метрики (`TotalPnLPercent`, `MaxDrawdownPercent`, `ProfitFactor`, `WinRate`, …), `RunTag` и столбец со значением каждого перебираемого параметра;
- HTML-отчёт каждой комбинации (если включён `report.enable_html_report`) и его [JSON-версия](#get-apitesterreportsjson) (если включён `report.enable_json_report`); `RunTag` комбинации есть в имени файла;
- сводный отчёт оптимизатора `report_optimizer_*.html`.

**Ответ 200:** `{ "success": true }`

**Ошибки:** `400` — не найдено ни одной из настроек или неверный `config`, `409` — тестер уже работает или загружаются данные

---

### POST /api/tester/stress
Стресс-тест: те же настройки в ухудшенных условиях исполнения. Тело и ответы — как у `/api/tester/run`.

---

### POST /api/tester/wizard-run
Одиночный прогон стратегий. Тело — как у `/api/tester/run`.

**Ответ 200:**
```json
{ "success": true, "run_id": "a1b2c3d4" }
```

Ход прогона — в `wizard_runs` ответа `GET /api/tester/status` по `run_id`, метрики и путь к отчёту — в `GET /api/tester/wizard-results`.

**Ошибки:** `400` — не найдено ни одной из настроек, `409` — загружаются данные

---

### POST /api/tester/snapshot-run
Повторяет прогон по snapshot-файлу. Snapshot сохраняет точные настройки и конфиг прогона; его сохраняет тестер рядом с отчётом (`run_snapshot_*.json`). Файл выбирается параметрами `?root=&path=`, как в [файлах тестера](#get-apitesterfiles).

Тело необязательно: можно передать изменённый snapshot — изменения действуют только на этот запуск, файл не меняется.

**Запрос:** `POST /api/tester/snapshot-run?root=report&path=T4/run_snapshot_20261025.json`

**Ответ 200:** `{ "success": true }`

**Ошибки:** `400` — в snapshot нет конфига тестера или настроек, `404` — файл не найден, `409` — тестер уже работает или загружаются данные

---

### POST /api/tester/download-data
Загружает исторические данные для всех настроек тестера. Ход — в `download` ответа `GET /api/tester/status`.

**Ответ 200:** `{ "success": true }`

**Ошибки:** `409` — загрузка уже идёт или работает тестер

---

### GET /api/tester/wizard-results
Результаты одиночных прогонов, свежие первыми. Новый прогон того же набора настроек заменяет его прежнюю запись.

**Ответ 200:**
```json
[
  {
    "runId": "a82c93c5",
    "timestamp": "2026-10-25T05:26:50Z",
    "strategies": ["T4 BTC"],
    "stats": {
      "InitialBalance": 10000.0, "FinalBalance": 9581.25, "TotalPnL": -418.75, "TotalPnLPercent": -4.19,
      "TotalTrades": 23, "WinRate": 13.04, "MaxDrawdown": 527.89, "MaxDrawdownPercent": 5.26, "TotalFees": 22.2
    },
    "chartUrl": "/tester-report/T4/T4_run_001_of_001_BTCUSDT_1h_ee8c3c2e.html",
    "report_path": "T4/T4_run_001_of_001_BTCUSDT_1h_ee8c3c2e.html",
    "report_json_path": "T4/T4_run_001_of_001_BTCUSDT_1h_ee8c3c2e.json",
    "period": "2025-09-01 .. 2025-09-20",
    "elapsed": "00:00:07"
  }
]
```

`chartUrl` — ссылка на HTML-отчёт для браузера. `report_path` — тот же отчёт как путь внутри `root=report`, для [файлов тестера](#get-apitesterfiles) и [`/api/tester/reports/summary`](#get-apitesterreportssummary). `report_json_path` — его [JSON-версия](#get-apitesterreportsjson); поле есть, только если она записана.

---

### GET /api/tester/files
Содержимое папки тестера. `?root=` — `report` (отчёты, по умолчанию), `data` (исторические данные) или `runs` (наборы для повторных прогонов); `?path=` — путь внутри неё.

**Ответ 200:**
```json
{
  "root": "report",
  "path": "T4",
  "items": [
    { "name": "old", "is_dir": true, "size": 204800, "modified_utc": "2026-10-20T10:00:00Z", "snapshot": false, "editable": false },
    { "name": "run_snapshot_20261025.json", "is_dir": false, "size": 51200, "modified_utc": "2026-10-25T12:00:00Z", "snapshot": true, "editable": false }
  ]
}
```

`snapshot: true` — файл можно запустить через `/api/tester/snapshot-run`. `editable: true` — файл можно изменить через `/api/tester/files/save`.

**Ошибки:** `404` — папка не найдена

---

### GET /api/tester/files/download
Скачивает файл (`?root=&path=`). HTML-отчёты открываются в браузере.

**Ошибки:** `404` — файл не найден

---

### POST /api/tester/files/delete
Удаляет файл или папку (`?root=&path=`).

**Ответ 200:** `{ "success": true }`

**Ошибки:** `400` — недопустимый путь, `404` — не найдено, `409` — работает тестер или загружаются данные

---

### GET /api/tester/files/content
Содержимое snapshot-файла или JSON-файла из `runs` (`?root=&path=`).

**Ошибки:** `404` — файл не найден или не является snapshot

---

### POST /api/tester/files/save
Сохраняет JSON-файл в `runs` (`?root=runs&path=`). Тело — новое содержимое файла. Если в нём нет раздела `settings`, он берётся из текущего файла.

**Ответ 200:** `{ "success": true }`

**Ошибки:** `400` — пустое тело или неверный JSON, `404` — файл не найден или его нельзя изменять

---

### GET /api/tester/reports/summary
Сводки HTML-отчётов для сравнения прогонов: метрики и кривая доходности. `?r=` — путь отчёта в `report`, параметр можно повторять.

**Запрос:** `GET /api/tester/reports/summary?r=T4/report.html&r=T4_STRESS/report.html`

**Ответ 200:**
```json
[
  {
    "report": "T4/report.html",
    "created": "2026-10-25T12:00:00Z",
    "summary": {
      "name_comment": "T4",
      "start": "2025-01-01T00:00:00",
      "end": "2026-01-01T00:00:00",
      "symbols": ["BTCUSDT"],
      "metrics": { "TotalPnLPercent": 42.1, "MaxDrawdownPercent": 12.3, "ProfitFactor": 1.8, "WinRate": 55.0, "TotalTrades": 120 },
      "equity_t": [1735689600],
      "equity_v": [1000.0]
    }
  }
]
```

`equity_t` и `equity_v` — время (Unix, секунды) и баланс точек кривой доходности. `summary: null` — у отчёта нет сводки.

**Ошибки:** `400` — не передан ни один `r`, `404` — отчёт не найден

---

### GET /api/tester/reports/json
Подробные результаты одного прогона в компактном JSON. Те же числа, что в HTML-отчёте, но файл в десятки раз меньше: несколько десятков килобайт вместо мегабайтов.

Тестер пишет `<отчёт>.json` рядом с HTML-отчётом, если в конфиге тестера включено `report.enable_json_report` (по умолчанию выключено). JSON пишется и при выключенном `report.enable_html_report`: так большой перебор идёт быстрее и всё равно сохраняет детали каждой комбинации.

Параметры:
- `?path=` — путь отчёта в `report`: файл `.json` или его `.html` (например, `report_path` из [`wizard-results`](#get-apitesterwizard-results));
- `?sections=` — только эти разделы через запятую, например `?sections=metrics,by_symbol`;
- `?trades_offset=` и `?trades_limit=` — часть сделок.

**Разделы:**

| Раздел | Содержимое |
|---|---|
| `run` | `name_comment`, `comment`, `run_tag`, `run_params` (значения перебираемых параметров), период, биржи, стратегии и пары |
| `metrics` | вся таблица статистики HTML-отчёта по блокам: PnL, баланс, доходность по месяцам, сделки, исполнения, Buy & Hold, риск и экспозиция, Sharpe, Sortino, CAGR, Calmar, Ulcer Index… |
| `by_symbol` | итоги по каждой паре: сделки, win rate, profit factor, PnL, лучшая и худшая сделка, просадка, Buy & Hold, комиссии, объём, размер позиции |
| `monthly` | доходность по месяцам, %: `{ "2025-09": -4.15 }` |
| `trades` | сделки (от открытия позиции до полного закрытия или переворота), отсортированные по времени закрытия, — `columns` и `rows` |
| `curves` | кривые баланса (`equity`) и открытых позиций (`open_positions_total`, `_long`, `_short`), до 500 точек; `t` — Unix-время в секундах, `v` — значения |
| `settings` | полные настройки стратегий прогона |

Поля `v` (версия формата), `created_utc` и `html_report` (имя HTML-отчёта или `null`) возвращаются всегда.

**Запрос:** `GET /api/tester/reports/json?path=T4/T4_run_001_of_001_BTCUSDT_1h_ee8c3c2e.html&sections=by_symbol,trades&trades_limit=2`

**Ответ 200:**
```json
{
  "v": 1,
  "created_utc": "2026-10-25T05:45:34Z",
  "html_report": "T4_run_001_of_001_BTCUSDT_1h_ee8c3c2e.html",
  "by_symbol": [
    { "symbol": "BTCUSDT", "strategy": "zigzag", "trades": 23, "win_rate": 13.04, "profit_factor": 0.395, "pnl": -390.14,
      "best_trade": 160.02, "worst_trade": -57.7, "max_drawdown_incl_unrealized": -483.2, "buy_hold_percent": 6.81,
      "fee": 22.2, "volume": 221995.16, "position_avg_percent": 49.31, "position_max_percent": 50.72 }
  ],
  "trades": {
    "count": 23,
    "columns": ["symbol", "side", "open", "close", "holding_hours", "fills", "net_pnl", "mae", "mfe"],
    "rows": [
      ["BTCUSDT", "short", "2025-09-01 00:04", "2025-09-01 07:54", 7.83, 2, -57.6968, -57.6968, 38.8311],
      ["BTCUSDT", "long", "2025-09-01 07:54", "2025-09-01 20:45", 12.85, 2, -46.2855, -50.7967, 26.7293]
    ],
    "offset": 0
  }
}
```

В `trades`: `count` — число всех сделок, `net_pnl` — результат сделки за вычетом комиссий, `mae` и `mfe` — худший и лучший промежуточный результат сделки (USDT), время — UTC.

**Ошибки:** `400` — файл не является JSON-отчётом, `404` — JSON-отчёт не найден

---

### GET /api/tester/publish/files
Файлы папки отчёта, которые можно опубликовать на сайт. `?path=` — папка в `report`.

**Ответ 200:**
```json
[ { "name": "reports_history.csv", "size": 10240, "kind": "history" } ]
```

`kind` — `history` (история прогонов), `snapshot` (snapshot прогона) или `summary` (сводный отчёт).

**Ошибки:** `404` — папка не найдена

---

### POST /api/tester/publish
Отправляет выбранные файлы папки отчёта на сайт. Публикация появляется после модерации.

**Запрос:**
```json
{ "path": "T4", "files": ["reports_history.csv"], "contact": "@telegram", "comment": "...", "agree": true }
```

`agree: true` — согласие с условиями публикации, обязательно.

**Ответ 200:**
```json
{ "success": true, "sent": ["reports_history.csv"] }
```

**Ошибки:** `400` — нет согласия или не выбраны файлы, `404` — папка не найдена, `502` — сайт не принял публикацию

---

## MCP для ИИ-ассистентов

Бот работает и как MCP-сервер ([Model Context Protocol](https://modelcontextprotocol.io)): ИИ-ассистент (Claude и другие клиенты MCP) может сам смотреть состояние бота, запускать тестер и управлять стратегиями. Инструменты MCP повторяют этот API и подчиняются тем же правилам доступа.

**Включение.** По умолчанию MCP выключен. Включите его в `settings_program.json`:

```json
{ "use_mcp": true }
```

Изменение действует сразу, перезапуск не нужен. Его можно сделать и через API: `POST /api/settings/config` с телом `{ "use_mcp": true }`. Пока MCP выключен, `/mcp` отвечает `404`.

**Адрес:** `http://127.0.0.1:<порт>/mcp`, транспорт Streamable HTTP.

**Подключение к Claude Code:**

```bash
claude mcp add --transport http hamster-bot http://127.0.0.1:5000/mcp --header "Authorization: Bearer <api_token>"
```

Или в файле `.mcp.json` проекта:

```json
{
  "mcpServers": {
    "hamster-bot": {
      "type": "http",
      "url": "http://127.0.0.1:5000/mcp",
      "headers": { "Authorization": "Bearer <api_token>" }
    }
  }
}
```

Другие клиенты подключаются по тому же адресу, если поддерживают Streamable HTTP и свои заголовки запроса.

**Доступ** — как у API (см. [Доступ](#доступ)): заголовок `Authorization: Bearer <api_token>` с любого адреса; без него — cookie `hamster-bot-token` при включённом входе или только с этой же машины при выключенном. Иначе `/mcp` отвечает `401`. Для подключения с другой машины укажите вместо `127.0.0.1` адрес сервера; токен при этом передаётся открытым текстом, поэтому через интернет подключайтесь через HTTPS-прокси или SSH-туннель.

**Безопасность.** Инструменты, которые торгуют на бирже, запускают торговлю или необратимо меняют данные, помечены как опасные (`destructiveHint`) — клиент запрашивает подтверждение перед их вызовом. Это рыночные ордера, закрытие позиций, отмена ордеров, запуск ботов, сохранение и удаление стратегий и ключей, изменение конфига, выключение и обновление программы. Чтение состояния помечено как безопасное (`readOnlyHint`).

**Инструменты:**

| Группа | Инструменты |
|---|---|
| Настройки | `get_config`, `update_config`, `get_field_hints` |
| Стратегии | `list_strategies`, `get_strategy`, `draft_strategy`, `save_strategy`, `copy_strategy`, `delete_strategy` |
| Аккаунты | `list_accounts`, `get_account`, `get_account_symbols`, `save_account`, `delete_account`, `get_account_info`, `get_balance_history`, `compact_balance_history` |
| Боты | `list_bots`, `get_balances`, `get_bot_bars`, `get_bot_state`, `pause_all_bots`, `play_all_bots`, `pause_bot`, `play_bot`, `send_chart_to_telegram`, `send_position_to_telegram` |
| Позиции и ордера | `list_positions`, `list_orders`, `market_order`, `close_position`, `close_all_positions`, `reduce_positions`, `cancel_order`, `cancel_account_orders`, `cancel_all_orders` |
| Система и логи | `get_system_status`, `shutdown_program`, `update_program`, `get_log`, `get_errors`, `list_log_files`, `read_log_file` |
| Тестер | `tester_status`, `get_tester_config`, `save_tester_config`, `tester_exchanges`, `tester_exchange_symbols`, `list_tester_settings`, `get_tester_settings`, `draft_tester_settings`, `save_tester_settings`, `copy_tester_settings`, `delete_tester_settings`, `get_tester_settings_folder`, `set_tester_settings_folder`, `tester_run_mining`, `tester_run_stress`, `tester_run_single`, `tester_run_snapshot`, `tester_download_data`, `tester_wizard_results`, `list_tester_files`, `read_tester_file`, `save_tester_file`, `delete_tester_file`, `tester_report_summaries`, `read_tester_report`, `tester_publish_files`, `tester_publish` |

Ошибка API возвращается ассистенту как ошибка инструмента с кодом и текстом, например `HTTP 404: {"success":false,"error":"Strategy not found"}`. Очень длинные ответы обрезаются до 200 000 символов. У `read_tester_file` для длинных CSV есть параметры `tail_lines` (последние N строк) и `contains` (только строки с текстом); заголовок CSV при этом сохраняется. HTML-отчёты большие, поэтому для сравнения прогонов лучше `tester_report_summaries`, а для подробностей одного прогона — `read_tester_report`.

**Исследования в тестере.** Ассистент может сам вести исследование стратегии. Тестер работает на исторических данных и с биржей не торгует. Типичный порядок:

1. `get_field_hints` — узнать смысл полей настроек стратегии и конфига тестера, в том числе синтаксис `parameter_mining`.
2. `draft_tester_settings` и `save_tester_settings` — создать настройки для нужной биржи, пары и таймфрейма.
3. `save_tester_config` — задать период, комиссии, `parameter_mining` и новый `name_comment` для эксперимента; включить `report.enable_json_report`.
4. `tester_download_data` — загрузить свечи и дождаться окончания в `tester_status`.
5. `tester_run_single` — проверить одну комбинацию: метрики в `tester_wizard_results`. Или `tester_run_mining` — перебрать все комбинации: результаты в `<name_comment>/reports_history.csv` (`read_tester_file`).
6. `read_tester_report` — разобрать прогон: итоги по парам, месяцы, сделки.
7. `tester_report_summaries`, `tester_run_stress` и `walk_forward` в конфиге — сравнить лучшие варианты и проверить их устойчивость.

Пример запроса к ассистенту: «Подбери длину зигзага для BTCUSDT 1h на бирже Bybit за последние три месяца. Сравни лучшие варианты по просадке и проверь их стресс-тестом».

---

## Коды ответов

| Код | Значение |
|-----|----------|
| 200 | Успех |
| 400 | Неверный запрос: пустое тело, неверный JSON, не заполнены обязательные поля |
| 401 | Нет доступа: неверный `api_token`; cookie отсутствует, устарел или заменён новым входом; запрос без токена не с этой же машины |
| 403 | Запрос со страницы другого сайта (`Origin` не совпадает с адресом бота) |
| 404 | Не найдено |
| 409 | Конфликт: тестер или загрузка данных уже работают, имя занято, нет нужного запущенного бота |
| 500 | Внутренняя ошибка или ошибка биржи |
| 502 | Внешний сервис не принял запрос |
| 503 | Программа ещё запускается |
