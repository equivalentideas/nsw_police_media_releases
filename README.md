# An archive of police media releases from NSW Australia

Searching for an old NSW Police media release?
Interested in analysing their releases over time?

The NSW Police online media release “archive”
only provides access to roughly the last 500 releases published.
That’s only about one month’s worth.

This scraper collects the latest media releases each day
and [stores their text for safe keeping](https://morph.io/equivalentideas/nsw_police_media_releases#data-table#data-table).
It has been running since 2nd May 2015.

[Since 26th January 2017](https://github.com/equivalentideas/nsw_police_media_releases/commit/d8ee4ebb31b2e9ca3c928036832a1097d6e1119c),
it has also been sending each media release’s web page to the [Internet Archive](https://archive.org/) for backing up.
This means you can visit the actual webpage that the media release was
posted at, using the `web_archive_url`.

For each media release, this scraper collects:

* title
* date and time published (pub_datetime)
* main body text (body)
* web address (url)
* address for an archived version of the page (web_archive_url)
* date and time it was collected (scraped_datetime)

This scraper runs on the magnificent [morph.io](https:/rmorph.io).

I was prompted to make this scraper by [Destroy The Joint’s](https://www.facebook.com/DestroyTheJoint)
project [Counting Dead Women Australia](https://www.facebook.com/notes/destroy-the-joint/counting-dead-women-australia-2015-we-count-every-single-violent-death-of-women-/867514906629588).
I noticed that one source of their research
was NSW Police media releases
and that only the last months releases were available.

I hope this archive is useful to anyone doing similar projects to
understand violence in NSW, and how it is reported by police.


