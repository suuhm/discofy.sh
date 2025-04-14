# discofy.sh
sending your terminal stuff via discord webhooks to your channel 

> Send stylish messages from your terminal straight to Discord – like a pro.

Discofy.sh is a tiny, bash-friendly tool that lets you send formatted messages to a Discord webhook. Whether it’s for backups, alerts, or just a hello – your terminal now speaks Discord.

---

## ✨ Features

- ✅ Plain or code-block formatted messages
- ✅ Easy to use with `echo`, `pipe`, or arguments
- ✅ Works in cronjobs, shell scripts, or interactively
- ✅ Discord webhook support
- ✅ Lightweight & dependency-free (pure bash + curl)

---

## 🚀 Installation

1. Download the script:

```bash
curl -o discofy.sh https://raw.githubusercontent.com/suuhm/discofy.sh
chmod +x discofy.sh
```

2. Set your webhook URL in the script or as an env var:

```bash
export DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/..."
```

---

## 🛠️ Usage

### Pipe standard input:

```bash
echo "Backup complete at $(date)" | ./discofy.sh
```

### Send as code block:

```bash
echo "ls -la output:" && ls -la | ./discofy.sh --code
```

### Or pass arguments:

```bash
./discofy.sh --plain "System update finished ✅"
./discofy.sh --code "uptime && free -m"
```

---

## 📦 Options

| Option      | Description                   |
|-------------|-------------------------------|
| `--plain`   | Send message as plain text    |
| `--code`    | Send message as a code block  |

---

## 📡 Example Output

Plain:
```
[OK] Backup complete at Mon Apr 14 17:00:00 CEST 2025
```

Code block:
```
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1       930G  804G   87G  91% /
```

---

## 🧪 Quick Test

```bash
echo "🎉 Hello from Discofy.sh!" | ./discofy.sh --plain
```

---

## 💬 Why Discofy?

- Looks great in logs
- Works in any Linux environment
- Makes automation & alerting more fun
- Terminal to Discord in one line

---

## 🧠 Ideas for Use

- Backup completion
- System alerts
- Script results
- Monitoring

---

## ❤️ Credit

Created with ☕ and 🐚 by you.
