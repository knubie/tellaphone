# Tellaphone

This addon will intercept incoming /tells (or any log message) and forward them to any http endpoint (Discord bot by default).

I originally created this addon so that I could get notifications on my phone when I received a tell in-game.

## Installation

Copy this directory to your Ashita addons folder. Update the `discord:init` function call with your Discord bot's token and your Discord user ID.

```lua
discord:init({
  bot_token = 'my_discord_bot_token',
  user_id   = 'my_user_id',
})
```

When the addon is loaded, the discord bot will send you a DM every time you receive a /tell in game. You will need to make sure the bot has permissions to DM you ahead of time.
