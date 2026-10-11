<img width="2948" height="497" alt="rsg_framework" src="https://github.com/user-attachments/assets/638791d8-296d-4817-a596-785325c1b83a" />

# 🥤 rsg-canteen
**Simple canteen system for RSG Core.**

![Platform](https://img.shields.io/badge/platform-RedM-darkred)
![License](https://img.shields.io/badge/license-GPL--3.0-green)

> Drink from tiered canteens (100/75/50/25/0) with an animation and prop, and refill them in rivers, lakes and the sea.
> All item swaps and thirst changes are handled server-side.

---

## 🛠️ Dependencies
- **rsg-core** (framework)
- **rsg-inventory** (items)
- **ox_lib** (locales, notifications)
- **rsg-hud** (thirst display)

**Locales included:** `en`, `de`, `el`, `es`, `fr`, `ja`, `nl`, `pl`, `pt-br`, `ro`, `it`
**License:** GPL‑3.0

---

## ✨ Features
- 🔄 **Tiered items:** `canteen100` → `canteen75` → `canteen50` → `canteen25` → `canteen0`.
- 🥤 **Drink:** using any non-empty canteen restores `Config.DrinkAmount` thirst and drops it one tier.
- 🌊 **Refill:** standing on foot in a water zone listed in `Config.WaterTypes` and using `canteen0/25/50/75` refills it to `canteen100` and restores `Config.RefillThirst`.
- 🚫 **Empty check:** using `canteen0` away from valid water shows a localized error.
- 🔒 **Server authoritative:** the server records each item use and only accepts one matching result from the client, removes the old item before giving the new one, and sets thirst itself.
- 🌍 **Multi-language** via `lib.locale()`.

---

## ⚙️ Configuration (`shared/config.lua`)
```lua
Config.DrinkAmount  = 25  -- thirst restored when drinking
Config.RefillThirst = 100 -- thirst restored when refilling at valid water

Config.WaterTypes = {
    { name = 'Sea of Coronado', waterhash = -247856387,  watertype = 'sea'   },
    { name = 'San Luis River',  waterhash = -1504425495, watertype = 'river' },
    -- ... remove an entry to block refilling there
}
```

---

## 🔁 How it works
1. Player uses a canteen item → server stores a pending use and triggers `rsg-canteen:client:drink`.
2. Client checks water, plays the animation, then reports `refill`, `drink` or `cancel` via `rsg-canteen:server:finish`.
3. Server validates the pending use (one per use, 30s window), swaps the item and updates thirst.

### External refill (server-side export)
```lua
-- returns true if the player had the item and it was refilled
exports['rsg-canteen']:RefillCanteen(source, 'canteen25')
```
> The old `rsg-canteen:server:refillcanteen` and `givefullcanteen*` / `degradecanteen` net events were removed — they could be triggered by any client.

---

## 🧺 Inventory Items
Add to `rsg-core/shared/items.lua`:
```lua
canteen100 = { name = 'canteen100', label = 'Canteen (Full)',  weight = 200, type = 'item', image = 'canteen100.png', unique = false, useable = true, decay = 0, delete = true, shouldClose = true, description = 'A full canteen of water.' },
canteen75  = { name = 'canteen75',  label = 'Canteen (3/4)',   weight = 200, type = 'item', image = 'canteen75.png',  unique = false, useable = true, decay = 0, delete = true, shouldClose = true, description = 'A canteen that is three-quarters full.' },
canteen50  = { name = 'canteen50',  label = 'Canteen (Half)',  weight = 200, type = 'item', image = 'canteen50.png',  unique = false, useable = true, decay = 0, delete = true, shouldClose = true, description = 'A half-full canteen.' },
canteen25  = { name = 'canteen25',  label = 'Canteen (1/4)',   weight = 200, type = 'item', image = 'canteen25.png',  unique = false, useable = true, decay = 0, delete = true, shouldClose = true, description = 'A canteen with a small amount of water.' },
canteen0   = { name = 'canteen0',   label = 'Canteen (Empty)', weight = 200, type = 'item', image = 'canteen0.png',   unique = false, useable = true, decay = 0, delete = true, shouldClose = true, description = 'An empty canteen that needs refilling.' },
```

---

## 📂 Installation
1. Add `rsg-canteen` to `resources/[rsg]`.
2. Add the items above and their images.
3. In `server.cfg`:
   ```cfg
   ensure ox_lib
   ensure rsg-core
   ensure rsg-inventory
   ensure rsg-canteen
   ```
4. Restart your server.

---

## 🌍 Locales
```json
{
  "canteen_empty_title": "Canteen Empty",
  "canteen_empty_desc": "You need to fill up your canteen first!"
}
```

---

## ☕ Support
If you find this useful: https://buymeacoffee.com/rexshack

## 💎 Credits
- RSG / Rexshack-RedM adaptation & maintenance
- Community contributors & translators
- License: GPL‑3.0
