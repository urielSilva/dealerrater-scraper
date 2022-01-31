module Scraping
  class MechanizePageObject

    STRINGS = {
      dealer_page_href: 'mckaig-chevrolet-buick',
      review_page_text: 'More Reviews',
      review_title_class: '.review-title',
      review_snippet_class: '.review-whole',
      review_entry_class: '.review-entry',
      review_rating_class: '.rating-static',
      review_author_class: '.margin-bottom-sm.line-height-150',
      review_date_class: '.review-date',
      next_page_text: 'next >'
    }

    RATING_REGEX = /rating-(\d\d)/

    def initialize
      @agent = Mechanize.new
    end

    def go_to_review_page(first_page)
      @agent.get(first_page)
        .then { |page| page.links.find {|l| l.href&.downcase&.include? STRINGS[:dealer_page_href]}.click }
        .then { |page| page.link_with(text: STRINGS[:review_page_text]).click}
    end

    def review_entries(review_page)
      review_page.search(STRINGS[:review_entry_class])
    end

    def review_rating(entry)
      entry.search(STRINGS[:review_rating_class]).first.attribute('class').value
        .then {|classes| classes.split(' ').map {|klass| klass.match(RATING_REGEX) }.compact.first[1] }
        .then {|rating_class| rating_class.chars.first.to_i}
    end

    def review_text(entry)
      entry.search(STRINGS[:review_title_class]).text + entry.search(STRINGS[:review_snippet_class]).text
    end

    def review_author(entry)
      entry.search('.margin-bottom-sm.line-height-150').search('span').text.match(/by (.*)/)[1]
    end

    def review_date(entry)
      entry.search('.review-date').search('.italic').text
    end

    def paginate_review_page(review_page)
      review_page.link_with(text: STRINGS[:next_page_text]).click
    end
  end
end