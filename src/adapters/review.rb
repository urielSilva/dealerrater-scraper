module Adapters
  module Review
    class << self
      def format_reviews(reviews)
        reviews.map { |r| r.except(:score) }
      end
    end
  end
end