require_relative 'src/application.rb'
require 'textmood'
require 'mechanize'

class Main
  class << self
    def execute
      top_reviews = setup_dependencies.then {|deps| Application.execute(**deps)}
      STDOUT.write(top_reviews)
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
