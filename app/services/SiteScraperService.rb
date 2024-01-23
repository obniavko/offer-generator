require 'httparty'
require 'nokogiri'

class SiteScraperService
  def initialize(url)
    @url = url
  end

  def scrape_data
    headers = {
      'accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3',
      'accept-encoding': 'gzip, deflate, br',
      'accept-language': 'zh-CN,zh;q=0.9,zh-TW;q=0.8,en-US;q=0.7,en;q=0.6,ja;q=0.5',
      'cache-control': 'max-age=0',
      'cookie': 'your_cookie_here',
      'sec-fetch-mode': 'navigate',
      'sec-fetch-site': 'same-origin',
      'sec-fetch-user': '?1',
      'upgrade-insecure-requests': '1',
      'user-agent': 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.96 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'
    }

    response = HTTParty.get(@url, headers: headers)
    document = Nokogiri::HTML.parse(response.body)

    {
      title: scrape_element_text(document, ".title-text"),
      description: scrape_element_content(document, 'meta[name="description"]', 'content'),
      image: scrape_element_attribute(document, 'img.J_ImageFirstRender', 'src'),
      show_price_array: scrape_show_price_array(document),
    }
  end

  private

  def scrape_element_text(document, selector)
    document.at_css(selector).text
  end

  def scrape_element_content(document, selector, attribute)
    document.at_css(selector)[attribute]
  end

  def scrape_element_attribute(document, selector, attribute)
    element = document.at_css(selector)

    element[attribute] if element
  end

  def scrape_show_price_array(document)
    price_div = document.at_css('div.detail-price-item[data-common-price-item="Y"][data-show-price]')

    show_price_value = price_div['data-show-price']

    show_price_array = show_price_value.split('-').map(&:strip).map(&:to_f)
  end
end
