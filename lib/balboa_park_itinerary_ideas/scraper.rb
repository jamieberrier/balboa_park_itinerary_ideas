class BalboaParkItineraryIdeas::Scraper

  def self.get_page
    Nokogiri::HTML(open("https://www.balboapark.org"))
  end

  def self.print_list
    self.get_page.css('div.view-itineraries span.field-content').each.with_index(1) do |it, i|
      name = it.css('a').text
      puts " #{i}. #{name}"
    end
  end
end
