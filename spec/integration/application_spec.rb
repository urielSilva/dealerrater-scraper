require_relative '../../src/application.rb'
require 'vcr'

RSpec.describe Application do
  
  let(:reviews) {
    [
      {
        rating: 5,
        text: "We were very impressed with McKaig Chevrolet. Ryan F. was very " \
        "personable and attentive to our vehicle needs. They made truck buying easy." \
        " Thank you, Ryan, and thank you, Brandon! :)",
        score: 3.4
      },
      {
        rating: 5,
        text: "Adrian was a great sales person. He was very professional." \
        " He made the buying process so easy. He was very thorough in showing me " \
        "everything about the truck. I really appreciate his kindness and",
        score: 2.9499999999999997
      },
      {
        rating: 5,
        text: "We was treated with great respect and have all good things " \
        "to say about ya'll every one was so nice we no where to go to get " \
        "our next thank you so much for all you did for use we love our new car",
        score: 2.55
      }
    ]
  }

  context 'teste' do
    it 'returns the top reviews for McKaig Chevrolet Buick dealer' do
      VCR.use_cassette("dealer_rater") do
        result = Application.execute
        expect(result).to eq(reviews)
      end
    end
  end
end

