---
title: "How to publish a post on this site"
description: "The one-file workflow for publishing, plus a reference for every formatting feature the theme supports."
date: 2026-09-10 12:00:00 +0200
tags: [meta, reference]
---

Publishing is one file. Create a Markdown file in `_posts/`, name it
`YYYY-MM-DD-some-slug.md`, push it, and it's live in about a minute. This post
is both the instructions and a test page for every style the theme supports —
delete it once you've read it.

<!--more-->

## The front matter

Every post starts with a block of YAML between two `---` lines:

```yaml
---
title: "How to publish a post on this site"
description: "Shown on the post and in Google results. Keep it under ~160 characters."
date: 2026-09-10 12:00:00 +0200
tags: [meta, reference]
---
```

Only `title` and `date` are strictly required — the filename date works too, so
in practice you need `title`. A few extras you can add:

| Key | What it does |
| --- | --- |
| `description` | Lede under the title, plus the SEO/social description |
| `tags` | Groups the post on the topics page |
| `image` | Path to a social-share image, e.g. `/assets/img/thing.png` |
| `published: false` | Keeps a draft out of the built site |

Anything under `_drafts/` is also skipped until you move it into `_posts/`.

## Writing

Standard Markdown, so **bold**, _italic_, `inline code`, [links](/about/), and
footnotes[^1] all work.

[^1]: Like this one — it renders at the bottom of the page.

> Block quotes are styled with an accent rule. Good for pulling out a finding
> or quoting someone else's writing.

Code blocks get syntax highlighting when you name the language:

```python
def score(prompt: str, model: Classifier) -> float:
    """Return the model's confidence that `prompt` is an injection attempt."""
    features = tokenize(prompt, max_len=512)
    return float(model.predict_proba(features)[0][1])
```

```bash
# Shell works too
rg --json 'api[_-]?key' ./src | jq -r '.data.lines.text' | sort -u
```

Lists, ordered and not:

- A finding
- Another finding
  - And a nested one
1. First step
2. Second step

Images sit in `assets/img/` and are referenced like this:

```markdown
![Alt text that describes the image](/assets/img/diagram.png)
```

Press <kbd>Ctrl</kbd> + <kbd>K</kbd> to see keyboard styling, and use `---` on
its own line for a horizontal rule.

---

## The excerpt

Everything above the `<!--more-->` marker becomes the excerpt shown on the home
page and the writing index. Leave the marker out and the first paragraph is
used instead.

## Previewing before you publish

If you have Ruby installed:

```bash
bundle install     # once
bundle exec jekyll serve --livereload
```

Then open <http://localhost:4000>. Edits rebuild as you save.

If you'd rather not run anything locally, just push — GitHub builds the site
and the Actions tab tells you if a build failed.
