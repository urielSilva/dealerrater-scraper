require_relative 'src/application.rb'
require 'textmood'
require 'mechanize'

class Main
  class << self
    def execute
      setup_dependencies
        .then { |deps| Application.execute(**deps) }
        .then { |top_reviews| write_output(top_reviews) }
    end

    def write_output(top_reviews)
      STDOUT.write("Top #{top_reviews.size} reviews from McKaig Chevrolet Buick: \n\n")
      top_reviews.each do |review|
        STDOUT.write(review)
        STDOUT.write("\n")
      end
    end

    private

    def setup_dependencies
      {
        analyser: TextMood.new(language: "en", normalize_score: true),
        page_object: Scraping::MechanizePageObject.new
      }
    end
  end
end

Main.execute
