# This is a template for a Ruby scraper on Morph (https://morph.io)
# including some code snippets below that you should find helpful

require 'scraperwiki'
require 'mechanize'
require 'rest-client'

def extract_topic(title)
  topic = ""
  if title.include?(" - ")
    topic = title[/[-][ ].*$/].gsub(/^[-][ ]/, "")
  end
  return topic
end

def web_archive(page)
  archive_request_response = RestClient.get("https://web.archive.org/save/#{page.uri.to_s}")
  "https://web.archive.org" + archive_request_response.headers[:content_location]
end

def save_media_release(page)
  container = page.search('div#content-main')

  title = container.search(:h1)[1].text

  pub_datetime = DateTime.parse(container.children[8].text, '%A, %d %B %Y %l:%M:%S %p')

  # Strip the release header and meta elements leaving just the body
  container.children[0...9].remove

  media_release = {
    title: title,
    pub_datetime: pub_datetime.to_s,
    body: container.inner_html,
    url: page.uri.to_s,
    web_archive_url: web_archive(page),
    topic: extract_topic(title),
    scraped_datetime: DateTime.now.to_s
  }

  puts "Saving: #{title}, #{pub_datetime.strftime('%Y-%m-%d')}"
  ScraperWiki.save_sqlite([:url], media_release)
end

agent = Mechanize.new

index = agent.get('http://www.police.nsw.gov.au/news/media_release_archives')

web_archive(index)

index.search('#content_div_111604 a').each do |link|
  if (!ScraperWiki.select("url from data where url='#{link.attr(:href)}'").empty? rescue false)
    puts "Skipping already saved media release #{link.text} #{link.attr(:href)}"
  else
    media_release_page = agent.get(link.attr(:href))
    save_media_release(media_release_page)
  end
end
