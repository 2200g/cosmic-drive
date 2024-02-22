# COSMIC DRIVE

a telegram-based storage system :) 

```
syntax: cosmic drive [-h|u|d]
options:
h     print help text (this).
u     upload a file.
d     download a file.
```
---

## REQUIREMENTS
- an internet connection
- curl
- a telegram bot 

### TELEGRAM 

(all replacements required are in main.sh)

(you can also replace db with something more convinient)

- [https://telegram.me/botfather](https://telegram.me/botfather)
    use this to get a bot up and running and replace `TOKEN="TOKEN"` with `TOKEN=yourActualToken`
- [https://api.telegram.org/botTOKEN/getUpdates](https://api.telegram.org/botTOKEN/getUpdates) 
    - edit this link with your token, and send a message to your bot.
    - copy your chat id and replace `chatId="CHATID"` with `chatId="your actual chat id"`

---

all logics or whatever you want to call them are in the logics folder, they are not used by the main script, but rather are there for how i implemented certain methods yes.

---

## TODO
- [x] add logic for splitting files larger than 20MB into main
- [x] add logic for downloading said split file 
- [ ] add logic for file extensions
- [ ] add gpg encryption

> adding logic for file extensions would be like a new coloumn in cosmicdrive.db

> [https://www.youtube.com/watch?v=6RJlIf97Lp8](https://www.youtube.com/watch?v=6RJlIf97Lp8) this inspired me to do this yes
> im new to bash please do not bully me.
