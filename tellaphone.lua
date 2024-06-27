addon.name      = 'tellaphone'
addon.author    = 'Created by Knubie'
addon.version   = '0.0.1'
addon.desc      = 'Proxies incoming /tell messages to other services (discord by default).'
addon.link      = 'https://github.com/knubie/tellaphone'

-- Ashita libs
require('common')
chat = require('chat')

-- Import the default adapter.
local discord = require('adapters.discord')

local MODES = {
  SAY         = 1,
  TELL_SEND   = 4,
  PARTY       = 5,
  LS_ONE_SELF = 6,
  SHOUT       = 11,
  TELL_REC    = 12,
  LS_ONE      = 14,
  ERROR       = 123,
  ECHO        = 206,
  LS_TWO      = 214,
}

discord:init({
  bot_token = '------------------------------------------------------------------------',
  user_id   = '------------------',
})

ashita.events.register('text_in', 'text_in_cb', function (e)
  local mode = e.mode % 256;

  if (mode == MODES.TELL_REC) then
    -- Trim all non-ascii characters from the message so that it is valid JSON.
    discord:send_msg(e.message:gsub("[^\32-\126]", ""))
  end

  return false
end);
