---
layout: page
title: About
permalink: /about/
subtitle: Who writes here, and why.
description: About the Artificial Cybersecurity blog.
---

Hi — I work at the intersection of artificial intelligence and cybersecurity,
and this is where I publish the work that is worth writing down: research
notes, tooling, post-mortems and the occasional strong opinion.

## What you'll find here

- **Applied AI security** — attacking and defending machine-learning systems.
- **Tooling** — small things I build, and what broke while building them.
- **Notes from the field** — write-ups of problems I actually had to solve.

Everything here is my own work and my own view, not my employer's.

## Get in touch

{%- if site.email %}
The fastest route is email: [{{ site.email }}](mailto:{{ site.email }}).
You can also follow along by [RSS]({{ '/feed.xml' | relative_url }}){% if site.github_username %} or find my code on
[GitHub](https://github.com/{{ site.github_username }}){% endif %}.
{%- else %}
Follow along by [RSS]({{ '/feed.xml' | relative_url }}){% if site.github_username %} or find my code on
[GitHub](https://github.com/{{ site.github_username }}){% endif %}. Add an
`email:` line to `_config.yml` to show a contact email here instead.
{%- endif %}

> Replace this page with your own words — it lives in `about.md` at the root of
> the repository.
