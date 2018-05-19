--[[ 
                  به نام خدا
	  این سورس نوشته شده توسط تیم نترون میباشد
   از کپی برداری بدون منبع به هیچ وجه راضی نمیباشم
]]--
serpent = (loadfile "./libs/serpent.lua")()
redis = (loadfile "./libs/redis.lua")()
bot = dofile("tdcli.lua")
botid = '458127015' --id robot ra vared konid
SUDO = {432689914} --id sudo ra vared konid
PVSUDO = '432689914' --id sudo ra vared konid
TELEGRAM = {777000,366695086}
rang = {
b = {30, 40},
a = {33, 43},
s = {32, 42},
k = {35, 45}
}
function vardump(value)
print(serpent.block(value, {comment=false}))
end
function is_sgp(msg)
chat_id = tostring(msg.chat_id)
if chat_id:match('^-100') then 
if not msg.is_post then
return true
end
else
return false
end
end
function sleep(n) 
os.execute("sleep " .. tonumber(n)) 
end
function is_sudo(msg)
local var = false
for v,user in pairs(SUDO) do
if user == msg.sender_user_id_ then
var = true
end
end
return var
end
function is_tel(msg)
local var = false
for v,user in pairs(TELEGRAM) do
if user == msg.sender_user_id_ then
var = true
end
end
return var
end
function tdcli_update_callback(data)
if (data.ID == "UpdateNewMessage") then
local msg = data.message_
local chat_id = tostring(msg.chat_id_)
local txt = msg.content_.text_
if msg.date_ < (os.time() - 10) then
print("\027[" .. rang.b[1] .. ";" .. rang.a[2] .. "m\n old Message \n\027[00m")
return false
end
if msg.content_.text_ then
if txt:match("^on$") and is_sudo(msg) then
redis:del('off'..botid..'bot')
bot.sendText(chat_id, msg.id_, 0, 1, nil, '> ربات روشن شد', 1, 'html')
end
if not redis:get('off'..botid..'bot') then
if txt:match("^off$") then
redis:set('off'..botid..'bot','ok')
bot.sendText(chat_id, msg.id_, 0, 1, nil, '> ربات خاموش شد', 1, 'html')
end
if txt:match("^save$") and msg.reply_to_message_id_ and is_sudo(msg) then
function save(extra, result, kir)
vardump(result)
if result.content_.ID == 'MessageContact' then
bot.importContacts(result.content_.contact_.phone_number_,result.content_.contact_.first_name_, (result.content_.contact_.last_name_ or '@NOTRON_TM'), 0)
bot.sendText(chat_id, msg.id_, 0, 1, nil, '> شماره کاربر با موفقیت ذخیره شد', 1, 'html')
end
end
bot.getMessage(chat_id,msg.reply_to_message_id_,save,nil)
end
if txt:match("^reload$") and is_sudo(msg) then
dofile('./bot.lua')
bot.sendText(chat_id, msg.id_, 0, 1, nil, '> ربات با موفقیت بازنگری شد', 1, 'html')
end
if txt and txt:match('^add (%d+)') and is_sudo(msg) then
local id = txt:match('^add (%d+)') 
redis:set('auto'..botid..'addid',id)
bot.sendText(chat_id, msg.id_, 0, 1, nil, '> کاربر '..id..' برای جوینر انتخاب شد', 1, 'html')
end
if txt and txt:match('^start (.*)') and is_sudo(msg) then
local id = txt:match('^start (.*)') 
bot.sendBotStartMessage(id,id, 'start', dl_cb)
bot.sendText(chat_id, msg.id_, 0, 1, nil, '> ربات [ '..id..' ] استارت شد', 1, 'html')
end
if txt and is_tel(msg) then
local mi = txt:gsub("[0123456789:]", {["0"] = "0⃣", ["1"] = "1⃣", ["2"] = "2⃣", ["3"] = "3⃣", ["4"] = "4⃣", ["5"] = "5⃣", ["6"] = "6⃣", ["7"] = "7⃣", ["8"] = "8⃣", ["9"] = "9⃣", [":"] = ":\n"})
local support = redis:get('se'..botid..'tsuppoet')
bot.sendText(PVSUDO,0, 0, 1, nil, mi, 1, 'html')
end
if txt:match("^help$") and is_sudo(msg) then
local text =
[[
> add [id]
#تنظیم کاربر یا ربات برای ادد

> reload
#بروز سازی فایل ربات

> info
#مشاهده کاربر تنظیم شده برای ادد

> save [reply]
#جهت سیو کردن شماره

> OFF
#خاموش کردن ربات

> ON
#روشن کردن ربات

> leave
#خروج ربات گروه

> ping
#تست انلاینی ربات

>leave off
#خاموش کردن خروج بع از ادد

>leave on
#خروج بعد از ادد

> start [id]
#استارت ربات تلگرامی
]]
bot.sendText(chat_id, msg.id_, 0, 1, nil,text, 1, 'html')
end
if txt:match("^leave on$") and is_sudo(msg) then
redis:set('leave'..botid..'on','ok')
bot.sendText(chat_id, msg.id_, 0, 1, nil, '> خروج بعد از ادد فعال شد', 1, 'html')
end
if txt:match("^leave off$") then
redis:del('leave'..botid..'on')
bot.sendText(chat_id, msg.id_, 0, 1, nil, '> خروج بعد از ادد خاموش شد', 1, 'html')
end
if txt:match("^info$") and is_sudo(msg) then
local id = redis:get('auto'..botid..'addid') or 'nil'
bot.sendText(chat_id, msg.id_, 0, 1, nil, '> کاربر '..id..' جهت ادد اتوماتیک انتخاب شده است', 1, 'html')
end
if txt:match("^leave$") and is_sudo(msg) then
bot.changeChatMemberStatus(chat_id, botid, 'Left')
end
if txt:match("^ping$") and is_sudo(msg) then
bot.sendText(chat_id, msg.id_, 0, 1, nil, '> ربات انلاین میباشد', 1, 'html')
end
if msg.content_.ID == "MessageText" then
if redis:get('auto'..botid..'addid') then
if txt:match("https://telegram.me/joinchat/%S+") or  txt:match("https://t.me/joinchat/%S+") then
local link = txt:match("https://telegram.me/joinchat/%S+") or  txt:match("https://t.me/joinchat/%S+")  
if link:match("t.me") then
link = string.gsub(link, "t.me", "telegram.me")
end
bot.importChatInviteLink(link, dl_cb, nil)
print("\027[" .. rang.b[1] .. ";" .. rang.s[2] .. "m\n ربات جوینر عضو گروه شد \n\027[00m")
else
local id = redis:get('auto'..botid..'addid')
bot.addChatMember(chat_id, id, 5)
print("\027[" .. rang.b[1] .. ";" .. rang.a[2] .. "m\n کاربر با ایدی [ "..id.." ] در گروه [ "..chat_id.." ] اضافه شد \n\027[00m")
sleep(10)
if redis:get('leave'..botid..'on') then
bot.changeChatMemberStatus(chat_id, botid, 'Left')
print("\027[" .. rang.b[1] .. ";" .. rang.k[2] .. "m\n ربات جوینر از گروه [ "..chat_id.." ] خارج شد \n\027[00m")
end
end
end
end
end
----------
end
elseif (data.ID == "UpdateOption" and data.name_ == "my_id") then
tdcli_function ({
ID="GetChats",
offset_order_="9223372036854775807",
offset_chat_id_=0,
limit_=20
}, dl_cb, nil)
end
end
--[[
     پایان
By : @ir_milad
ch : @NOTRON_TM
]]--
