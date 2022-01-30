module Domain
  module Review
    class << self
      def filter_best_reviews(reviews, count)
        reviews.sort_by { |review| [-review[:rating], -review[:score]] }[0..(count-1)]
      end

      def apply_sentiment_score(reviews, sentiment_analyser)
        reviews.map { |review| review.merge(score: sentiment_analyser.analyse(review[:text])) }
      end
    end
  end
end