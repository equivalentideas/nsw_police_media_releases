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
  container = page.at('main .o-content')

  title = container.at(:h1).text

  pub_datetime = DateTime.parse(container.at('p:first-of-type').text, '%A, %d %B %Y %I:%M:%S %p')

  body = container.children.drop_while do |n|
    # Strip the junk before the title, the title, and pubdate
    n != container.at('p:nth-of-type(2)')
  end.map {|n| n.to_html }.join # convert to string of html

  media_release = {
    title: title,
    pub_datetime: pub_datetime.to_s,
    body: body,
    url: page.uri.to_s,
    web_archive_url: web_archive(page),
    topic: extract_topic(title),
    scraped_datetime: DateTime.now.to_s
  }

  puts "Saving: #{title}, #{pub_datetime.strftime('%Y-%m-%d')}"
  ScraperWiki.save_sqlite([:url], media_release)
end

agent = Mechanize.new

index = agent.get('http://www.police.nsw.gov.au/news')

web_archive(index)

index.search('.p-card--masonry a').each do |link|
  if (!ScraperWiki.select("url from data where url='#{link.attr(:href)}'").empty? rescue false)
    puts "Skipping already saved media release #{link.text} #{link.attr(:href)}"
  else
    sleep 5

    media_release_page = agent.get(link.attr(:href))
    save_media_release(media_release_page)
  end
end
