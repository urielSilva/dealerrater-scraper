require 'byebug'
require 'mechanize'


class Scraper
  FIRST_PAGE = 'https://www.dealerrater.com/directory/z/75647/Chevrolet'

  STRINGS = {
    dealer_page_href: 'mckaig-chevrolet-buick',
    review_page_text: 'More Reviews',
    review_title_class: '.review-title',
    review_snippet_class: '.review-snippet',
    review_entry_class: '.review-entry',
    next_page_text: 'next >'
  }
  RATING_CLASS_REGEX = /rating-(\d\d)/

  def initialize(dealer_name, zip_code)
    @dealer_name = dealer_name
    @zip_code = zip_code
  end

  def scrape
    go_to_review_page(Mechanize.new)
      .then {|page| extract_reviews(page)}
  end

  private

  def first_page
    "https://www.dealerrater.com/directory/z/#{@zip_code}/#{@dealer_name}"
  end

  def go_to_review_page(agent)
    agent.get(FIRST_PAGE)
      .then {|page| page.links.find {|l| l.href&.downcase&.include? STRINGS[:dealer_page_href]}.click}
      .then {|page| page.link_with(text: STRINGS[:review_page_text]).click}
  end

  def extract_reviews(page)
    current_page = page.dup
    (1..5).reduce([]) do |reviews, _|
      reviews += extract_reviews_from_page(current_page)
      current_page = paginate_review_page(current_page)
      reviews
    end
  end

  def extract_reviews_from_page(review_page)
    review_page
      .search(STRINGS[:review_entry_class])
      .then {|entrys| entrys.map {|entry| {rating: extract_review_rating(entry), text: extract_review_text(entry) }}}
  end

  def extract_review_rating(entry)
    entry.search('.rating-static').first.attribute('class').value
      .then {|classes| classes.split(' ').map {|klass| klass.match(RATING_CLASS_REGEX).compact.first[1] }}
      .then {|rating_class| rating_class.chars.first.to_i}
  end

  def extract_review_text(entry)
    entry.search(STRINGS[:review_title_class]).text + entry.search(STRINGS[:review_snippet_class]).text
  end

  def paginate_review_page(review_page)
    review_page.link_with(text: STRINGS[:next_page_text]).click
  end
end