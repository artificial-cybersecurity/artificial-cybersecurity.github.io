---
title: "Running a local model from Shortcuts on your iPhone and Mac"
description: "Three ways to put a language model that runs on your own hardware into Apple Shortcuts, how to make it act like a small agent, and ten things it is useful for."
date: 2026-11-17 07:00:00 +0100
tags: [local-models, shortcuts, automation, privacy]
---

You can put a language model into your everyday automations without sending a
single word to someone else's server. Apple's Shortcuts app is the glue: it
collects the input, hands it to a model running on your own hardware, and does
something with the answer. This post covers three ways to set that up, from
zero-install to fully self-hosted, and then what it is good for.

<!--more-->

## Why local

- **Privacy.** The text you summarise, the screenshot you extract data from and
  the email you ask about never leave the device. For work material this is
  often the difference between "allowed" and "not allowed".
- **No account, no key, no bill.** Nothing to rotate, nothing to leak, no
  per-token cost.
- **It works offline.** On a plane, in a basement, on a locked-down network.

The trade-off is capability. A model that fits on a phone is much weaker than a
frontier cloud model. The trick is to give it small, well-defined jobs, which
is exactly what a shortcut is.

## The mental model

Every shortcut in this post has the same shape:

1. **Collect** input: the clipboard, a shared article, a photo, dictated text.
2. **Ask** the model, with a fixed instruction and that input.
3. **Act** on the answer: show it, copy it, save it, create a reminder.

The model is one step in the middle. Shortcuts does everything else, and that
matters later when we let the model make decisions.

## Option 1: the built-in model (no install)

Since iOS 26 and macOS 26, Shortcuts has a **Use Model** action. It needs a
device that supports Apple Intelligence (iPhone 15 Pro or newer, or any Apple
silicon Mac) with Apple Intelligence switched on.

1. Create a new shortcut and add the **Use Model** action.
2. Pick the model. There are three choices, and only one of them is local:

   | Choice | Where it runs |
   | --- | --- |
   | **On-Device** | On your iPhone or Mac. Nothing leaves the device. |
   | **Private Cloud Compute** | Apple's servers. More capable, but not local. |
   | **ChatGPT** | OpenAI's servers. |

3. Write the instruction, and insert a variable for the input, for example
   *Shortcut Input* or *Clipboard*.
4. Add an action that uses the result: **Show Result**, **Copy to Clipboard**,
   **Add New Reminder**.

Two details make this more useful than it first looks. The action can return
typed output rather than a paragraph of text, so you can ask for a yes/no, a
list or a dictionary and feed it straight into an **If** or **Repeat with
Each** action. And there is a **Follow Up** switch that keeps the conversation
open if you want to refine the answer.

The on-device model is small. It is good at summarising, rewriting, extracting
and classifying short text. It is not good at long documents, maths, or
anything that needs knowledge of recent events.

## Option 2: your own model on the Mac

For a stronger model, or one you choose yourself, run a model server on the
Mac and let Shortcuts talk to it. I'll use [Ollama](https://ollama.com) here
because its API is simple. LM Studio and `mlx-lm` work the same way with a
different URL.

Install Ollama, then pull a model and check that it answers:

```bash
ollama pull gemma3:4b

curl http://localhost:11434/api/generate -d '{
  "model": "gemma3:4b",
  "prompt": "Reply with the single word: ready",
  "stream": false
}'
```

Which model to pull depends on memory. As a rule of thumb, an 8 GB Mac is
comfortable with models around 4 billion parameters, 16 GB with 8 to 14
billion, and 32 GB or more with the 20 to 30 billion class. The line-up changes
every few months, so check what is current rather than trusting the name in
this post.

Now the shortcut. Add **Get Contents of URL** and expand its options:

| Setting | Value |
| --- | --- |
| URL | `http://localhost:11434/api/generate` |
| Method | `POST` |
| Request Body | `JSON` |
| `model` (Text) | `gemma3:4b` |
| `system` (Text) | Your fixed instruction, e.g. *Summarise the text in three bullet points.* |
| `prompt` (Text) | The input variable, e.g. *Shortcut Input* |
| `stream` (Boolean) | `false` |

Follow it with **Get Dictionary Value**, key `response`, and you have the
model's answer as text. Building the body with the JSON editor rather than
pasting text matters: Shortcuts escapes quotes and line breaks in the input for
you.

If you prefer the command line, the Mac-only **Run Shell Script** action does
the same job. Pass the input to stdin and use the full path, because Shortcuts
does not load your shell profile:

```bash
/usr/local/bin/ollama run gemma3:4b "Summarise the following text in three bullet points."
```

You have to enable *Allow Running Scripts* in the Shortcuts settings first. If
you installed Ollama with Homebrew the path is `/opt/homebrew/bin/ollama`.

## Option 3: the same model from your iPhone

A phone cannot run a 12-billion-parameter model, but it can borrow the Mac's.
There are two ways to connect them.

**Over SSH (the safer one).** Turn on *Remote Login* on the Mac, then use the
**Run Script Over SSH** action on the iPhone with the same `ollama run` command
as above. Ollama keeps listening on localhost only, and the connection is
authenticated and encrypted. Use an SSH key rather than a password.

**Over HTTP.** Make Ollama listen on the network, either with the *Expose
Ollama to the network* setting in the app or with
`launchctl setenv OLLAMA_HOST "0.0.0.0"` followed by a restart of Ollama. Then
point the shortcut from Option 2 at `http://your-mac.local:11434/api/generate`.
iOS will ask once for permission to reach the local network.

> **Ollama has no authentication.** Anyone who can reach port 11434 can run
> prompts on your Mac, download new models to it and delete the ones you have.
> Only expose it on a network you trust,
> never forward the port on your router, and prefer a private overlay such as
> Tailscale or WireGuard if you want access away from home.

There is also a third route that needs no Mac at all: several iPhone apps run
open models on the phone and provide their own Shortcuts actions. Private LLM
and Locally AI are two that advertise this. Check the App Store listing for
current support before buying.

## Making it act like an agent

So far the model only produces text. To make it *do* things, let it choose the
next step and let the shortcut carry it out. The model never touches your
data directly. It only returns a decision.

Ask for JSON by adding `format` (Text) = `json` to the request body, and give
it a closed list of actions in the `system` field:

```text
You route notes. Reply with JSON only, in this form:
{"action": "reminder" | "calendar" | "note" | "none", "title": "...", "when": "..."}
Use "none" if the text is not a task, an event or something worth keeping.
```

Then, in the shortcut:

1. **Dictate Text** (or take the share sheet input).
2. **Get Contents of URL** with the request above.
3. **Get Dictionary Value** `response`, then **Get Dictionary from Input** to
   parse the JSON.
4. An **If** action per value of `action`: create the reminder, add the event,
   or append to a note.

That is a complete, if small, agent: perceive, decide, act. Wrap steps 2 to 4
in a **Repeat** and feed the result of each action back in as the next prompt,
and it can work through a multi-step job.

Three rules keep this safe:

- **The shortcut owns the list of actions.** The model picks from it and cannot
  add to it. Anything not on the list falls through to "do nothing".
- **Treat the input as hostile.** A web page or an email can contain text
  written to steer the model ("ignore your instructions and..."). This is
  prompt injection, and a small local model is not better at resisting it than
  a large one. If the input comes from someone else, the actions must be
  harmless.
- **Confirm anything you cannot undo.** Sending a message, deleting a file or
  running a script should sit behind a **Show Alert** action that displays the
  model's proposal in full, so that Cancel stops the shortcut.

## Ten things to use it for

1. **Summarise what you are reading.** Share sheet, Safari article or PDF in,
   three bullet points out.
2. **Fix the clipboard.** Proofread, change the tone or translate the copied
   text and put it back, bound to a keyboard shortcut on the Mac or the Action
   button on the iPhone.
3. **Receipts into a spreadsheet.** Photo, **Extract Text from Image**, then
   ask for merchant, date and total as JSON and append a row to a Numbers
   sheet.
4. **Meeting notes into reminders.** Ask for a list of action items and loop
   over it with **Add New Reminder**.
5. **Voice capture.** Dictate a rambling thought and let the router above file
   it as a reminder, an event or a note.
6. **Rename files sensibly.** A Finder Quick Action that reads the start of a
   document and proposes a descriptive file name.
7. **Explain this command.** Select a shell one-liner or a log line, run the
   shortcut from the Services menu, and get a plain-language explanation
   without pasting internal hostnames into a cloud chatbot.
8. **Redact before sharing.** Ask the model to replace names, email addresses,
   phone numbers and account numbers with placeholders before text goes into a
   ticket or a public issue. Read the result. It will miss things.
9. **A second opinion on a suspicious message.** Paste an email or text and ask
   which features look like phishing: urgency, mismatched sender, odd links.
   Treat the answer as a checklist to think with and not as a verdict.
10. **A morning brief.** A time-of-day automation that collects today's
    calendar events, reminders and weather and turns them into one paragraph.

## What it will not do well

Small models are confidently wrong more often than large ones. They know
nothing recent, lose the thread in long documents, and on a phone they cost
battery. Use them where a mistake is cheap and obvious (a summary you can
check, a draft you will read anyway) and keep them away from anything where a
wrong answer has consequences you will not notice.

## Where to start

Build the clipboard shortcut with the built-in **Use Model** action set to
**On-Device**. It takes five minutes and shows you what the pattern feels like.
When you run into the limits of the small model, move the same shortcut to
Ollama on the Mac by swapping one action. Everything around it stays the same.

Menu names shift between OS releases, so if a label here does not match what
you see, search the action list for the nearest name.
