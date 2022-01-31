require_relative '../../src/domain/review.rb'

RSpec.describe Adapters::Review do
  context '#format_reviews' do
    it 'returns reviews properly formatted for output ' do
      reviews = [
        { rating: 5, text: '1st review', score: 1.1 },
        { rating: 1, text: '2nd review', score: 3 },
        { rating: 4, text: '3rd review', score: 0.9 }
      ]

      expect(Adapters::Review.format_reviews(reviews)).to eq(
        [
          { rating: 5, text: '1st review' },
          { rating: 1, text: '2nd review' },
          { rating: 4, text: '3rd review' }
        ]
      )
    end
  end
end