Dir[File.join(__dir__, 'scraping', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'domain', '*.rb')].each { |file| require file }

require 'textmood'
require 'mechanize'
require 'byebug'

class Application
  class << self
    def execute
      deps = setup_dependencies
      reviews = Scraping::Scraper.new(deps[:page_object], 'Chevrolet', 75647, 5).scrape
      byebug
      reviews
        .then {|reviews| Domain::Review.apply_sentiment_score(reviews, deps[:analyser])}
        .then {|reviews| Domain::Review.filter_best_reviews(reviews, 3)}
    end

    def setup_dependencies
      {
        analyser: TextMood.new(language: "en"),
        page_object: Scraping::PageObject.new(Mechanize.new)
      }
    end
  end
end