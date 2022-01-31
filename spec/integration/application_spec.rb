require_relative '../../src/application.rb'
require 'vcr'
require 'textmood'
require 'mechanize'

RSpec.describe Application do

  let(:dependencies) {
    {
      analyser: TextMood.new(language: "en", normalize_score: true),
      page_object: Scraping::MechanizePageObject.new
    }
  }

  let(:output) {
    [
      {
        rating: 5,
        text: "We came from New London texas to buy our new car. " \
        "Our sales was Jeannie Evans and she really was alot of help " \
        "we enjoyed her helping thank you jeannie.",
        author: 'Bakercatherine399',
        date: 'November 15, 2021'
      },
      {
        rating: 5,
        text: "We were very impressed with McKaig Chevrolet. Ryan F. was " \
        "very personable and attentive to our vehicle needs. They made truck " \
        "buying easy. Thank you, Ryan, and thank you, Brandon! :)",
        author: 'Ron and Betsy G.',
        date: 'December 11, 2021'
      },
      {
        rating: 5,
        text: "I found the sales specialist very informative. " \
        "Her name was Jeannie Evans. She was most kind in explaining " \
        "all of the operations of the vehicle. ",
        author: 'tfaulkner31',
        date: 'December 11, 2021'
      }
    ]
  }


  context '#execute' do
    it 'returns the top reviews for McKaig Chevrolet Buick dealer' do
      VCR.use_cassette("dealer_rater") do
        result = Application.execute(**dependencies)
        expect(result).to eq(output)
      end
    end
  end
end

