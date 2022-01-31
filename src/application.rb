Dir[File.join(__dir__, 'scraping', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'domain', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'adapters', '*.rb')].each { |file| require file }

class Application
  class << self
    REVIEWS_COUNT = 3

    def execute(page_object:, analyser:)
      Scraping::Scraper.new(page_object: page_object).fetch_reviews
        .then { |reviews| Domain::Review.apply_sentiment_score(reviews, analyser) }
        .then { |reviews| Domain::Review.filter_best_reviews(reviews, REVIEWS_COUNT) }
        .then { |reviews| Adapters::Review.format_reviews(reviews) }
    end
  end
end