require('common')

http = require('socket.http')
ltn12 = require('socket.ltn12')
json = require('json')


-- Helper function for echoing messages in-game.
local function echo(msg)
  AshitaCore:GetChatManager():QueueCommand(-1, '/echo ' .. msg);
end

local discord = {}

function discord:init(config)
  self._token      = config.bot_token
  self._user_id    = config.user_id
  self._channel_id = self:create_dm_channel()
end

function discord:send_msg(msg)
  local url = "https://discord.com/api/v10/channels/" .. self._channel_id .. "/messages"
  local body = json.encode({ content = msg });
  local response_body = {}

  local res, code, response_headers = http.request {
    url = url,
    method = "POST",
    headers = {
        ["Content-Type"] = "application/json",
        ["Authorization"] = "Bot " .. self._token,
        ["Content-Length"] = tostring(#body),
    },
    source = ltn12.source.string(body),
    sink = ltn12.sink.table(response_body),
  }

  if code == 200 then
    -- echo("Message sent successfully.")
  else
    local response_json = json.decode(table.concat(response_body))
    echo('Error discord:send_msg')
    echo('HTTP status code: ' .. code)
    echo(response_json.message)
  end
end

function discord:create_dm_channel()
  local url = 'https://discord.com/api/v10/users/@me/channels';
  local body = string.format('{"recipient_id": "%s"}', self._user_id)
  local response_body = {};
  local res, code, res_headers = http.request {
    url = url,
    method = "POST",
    headers = {
      ["Content-Type"] = "application/json",
      ["Authorization"] = "Bot " .. self._token,
      ["Content-Length"] = tostring(#body)
    },
    source = ltn12.source.string(body),
    sink = ltn12.sink.table(response_body),
  }
  if code == 200 then

    local response_json = table.concat(response_body)
    local channel = json.decode(response_json)
    return channel.id
  else
    local response_json = json.decode(table.concat(response_body))
    echo('Error discord:create_dm_channel')
    echo('HTTP status code: ' .. code)
    echo(response_json.message)
    return nil
  end
end

return discord
