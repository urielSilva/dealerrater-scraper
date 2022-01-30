require_relative '../src/domain/review.rb'

RSpec.describe Domain::Review do
  context '#filter_best_reviews' do
    it 'returns top reviews based on rating' do
      reviews = [
        { rating: 5, text: '1st review', score: 1.1 },
        { rating: 1, text: '2nd review', score: 3 },
        { rating: 4, text: '3rd review', score: 0.9 },
        { rating: 4, text: '4th review', score: 1 }
      ]

      expect(Domain::Review.filter_best_reviews(reviews, 3)).to eq(
        [
          { rating: 5, text: '1st review', score: 1.1 },
          { rating: 4, text: '4th review', score: 1 },
          { rating: 4, text: '3rd review', score: 0.9 }
        ]
      )
    end

    it 'uses score as a deciding criteria when rating are tied' do
      reviews = [
        { rating: 5, text: '1st review', score: 1.1 },
        { rating: 5, text: '2nd review', score: 3 },
        { rating: 5, text: '3rd review', score: 0.9 },
        { rating: 5, text: '4th review', score: 5 }
      ]

      expect(Domain::Review.filter_best_reviews(reviews, 3)).to eq(
        [
          { rating: 5, text: '4th review', score: 5 },
          { rating: 5, text: '2nd review', score: 3 },
          { rating: 5, text: '1st review', score: 1.1 }
        ]
      )
    end
  end

  context '#apply_sentiment_score' do
    let(:analyser) { double }

    before do
      expect(analyser).to receive(:analyse).and_return(-0.5)
      expect(analyser).to receive(:analyse).and_return(1.2)
    end

    it 'applies sentiment score to reviews' do
      reviews = [
        { rating: 5, text: '1st review' },
        { rating: 5, text: '2nd review' }
      ]

      expect(Domain::Review.apply_sentiment_score(reviews, analyser)).to eq(
        [
          { rating: 5, text: '1st review', score: -0.5 },
          { rating: 5, text: '2nd review', score: 1.2 }
        ]
      )
    end
  end
end