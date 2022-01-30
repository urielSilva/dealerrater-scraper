Dir[File.join(__dir__, 'scraping', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'domain', '*.rb')].each { |file| require file }
require 'mechanize'
require 'textmood'

class Application
  class << self
    def execute(reviews_count: 3, page_object: Scraping::MechanizePageObject.new, analyser: TextMood.new(language: "en"))
      Scraping::Scraper.new(page_object: page_object).execute
        .then {|reviews| Domain::Review.apply_sentiment_score(reviews, analyser)}
        .then {|reviews| Domain::Review.filter_best_reviews(reviews, reviews_count)}
    end
  end
end