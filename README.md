# artificial-cybersecurity.github.io

The source for [artificial-cybersecurity.github.io](https://artificial-cybersecurity.github.io) —
a Jekyll blog hosted on GitHub Pages.

## Publishing a post

1. Create a file in `_posts/` named `YYYY-MM-DD-your-slug.md`, or run:

   ```bash
   ./scripts/new-post.sh "Attacking a RAG pipeline" ai security
   ```

2. Write it:

   ```markdown
   ---
   title: "Attacking a RAG pipeline"
   description: "One sentence for the lede and the Google result."
   date: 2026-09-12 09:00:00 +0200
   tags: [ai, security]
   ---

   The opening paragraph, which becomes the excerpt on the home page.

   <!--more-->

   ## The rest of the post
   ```

3. Commit and push. GitHub rebuilds the site automatically — usually live in
   under a minute.

Set `published: false` in the front matter, or keep the file in `_drafts/`, to
hold a post back.

## Previewing locally

```bash
bundle install                            # once
bundle exec jekyll serve --livereload     # http://localhost:4000
```

## Turning Pages on (one-time)

In the repository: **Settings → Pages → Build and deployment**, set
*Source* to **Deploy from a branch**, branch `main`, folder `/ (root)`.
For a `<name>.github.io` repository the site is served from the root domain,
so `url` is `https://artificial-cybersecurity.github.io` and `baseurl` stays empty.

## What's where

| Path | What it is |
| --- | --- |
| `_config.yml` | Site title, tagline, author, social links |
| `_posts/` | Published posts, one Markdown file each |
| `_drafts/` | Unpublished drafts (never built) |
| `_layouts/` | Page shells: `default`, `page`, `post` |
| `_includes/` | Header, footer, `<head>`, post card |
| `assets/css/style.css` | All styling — plain CSS, tokens at the top |
| `assets/js/theme.js` | Light/dark toggle |
| `assets/img/` | Images referenced from posts |
| `index.html` | Home page (hero + 5 most recent posts) |
| `blog.html` | Full post index at `/blog/` |
| `tags.html` | Posts grouped by tag at `/tags/` |
| `about.md` | About page at `/about/` |

## Customising

- **Name, tagline, links** — all in `_config.yml`.
- **Colours** — the `:root` and `:root[data-theme="dark"]` blocks at the top of
  `assets/css/style.css`. Changing `--accent` re-skins the whole site.
- **Nav links** — `_includes/header.html`.

## Built in

RSS at `/feed.xml` (jekyll-feed), `sitemap.xml` (jekyll-sitemap), and Open
Graph / Twitter card meta tags (jekyll-seo-tag). Light and dark themes follow
the visitor's system setting until they use the toggle.
