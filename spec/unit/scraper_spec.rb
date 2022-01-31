require_relative '../../src/scraping/scraper.rb'

RSpec.describe Scraping::Scraper do
  let(:page_object) { double }
  let(:entries) { ['some', 'entries'] }
  let(:pages_count) { 3 }
  let(:rating) { 5 }
  let(:text) { 'this dealer is awesome' }
  let(:author) { 'Frodo Baggins' }
  let(:date) { 'January 01, 2022' }

  context '#scrape' do
    it 'extracts reviews rating and text' do
      setup_page_object

      reviews = Scraping::Scraper.new(page_object: page_object, pages_count: pages_count).fetch_reviews

      expect(reviews).to eq(6.times.map { { rating: rating, text: text, author: author, date: date } })
    end
  end

  def setup_page_object
    allow(page_object).to receive(:go_to_review_page).and_return('')
    allow(page_object).to receive(:review_entries).and_return(entries)
    allow(page_object).to receive(:review_rating).and_return(rating)
    allow(page_object).to receive(:review_text).and_return(text)
    allow(page_object).to receive(:review_author).and_return(author)
    allow(page_object).to receive(:review_date).and_return(date)
    allow(page_object).to receive(:paginate_review_page).and_return('')
  end
end