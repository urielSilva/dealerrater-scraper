#require_relative './page_object.rb'

module Scraping
  class Scraper
    def initialize(page_object, dealer_name, zip_code, pages_count)
      @page_object = page_object
      @dealer_name = dealer_name
      @zip_code = zip_code
      @pages_count = pages_count
    end

    def scrape
      @page_object.go_to_review_page(first_page)
        .then {|page| extract_reviews(page)}
    end

    private

    def first_page
      "https://www.dealerrater.com/directory/z/#{@zip_code}/#{@dealer_name}"
    end

    def extract_reviews(page)
      current_page = page.dup
      (1..@pages_count).reduce([]) do |reviews, _|
        reviews += extract_reviews_from_page(current_page)
        current_page = @page_object.paginate_review_page(current_page)
        reviews
      end
    end

    def extract_reviews_from_page(review_page)
      @page_object.review_entries(review_page)
        .then do |entries|
          entries.map {|entry| { rating: @page_object.review_rating(entry), text: @page_object.review_text(entry) }}
        end
    end
  end
end