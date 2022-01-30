require_relative '../src/scraper.rb'

RSpec.describe Scraper do
  let(:page_object) { double }
  let(:entries) { ['some', 'entries'] }
  let(:pages_count) { 5 }

  context '#scrape' do
    subject { Scraper.new(page_object, 1,0, pages_count).scrape }

    before do
      setup_page_object
    end

    it 'extracts reviews rating and text' do
      expect(subject).to eq(
        (pages_count * entries.size).times.map { { rating: 5, text: 'this dealer is awesome' } }
      )
    end
  end

  def setup_page_object
    allow(page_object).to receive(:go_to_review_page).and_return('')
    allow(page_object).to receive(:review_entries).and_return(entries)
    allow(page_object).to receive(:review_rating).and_return(5)
    allow(page_object).to receive(:review_text).and_return('this dealer is awesome')
    allow(page_object).to receive(:paginate_review_page).and_return('')
  end
end