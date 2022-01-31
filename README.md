# McKaig Chevrolet Buick review scraper

## Overview

This application outputs the top reviews for McKaig Chevrolet Buick car dealer. It does so via the following steps:
- Scraping the reviews for McKaig Chevrolet Buick, posted on the [DealerRater](https://dealerrater.com) website.
- Calculating a score for the review using a Sentiment Analysis technique applied on the review's content.
- Selecting the three most positive reviews and printing them on the console.

## How to run
To run the code you must have Ruby `3.0.0` installed, and run the following commands:
```
bundle install
ruby main.rb
```

## Testing
To run the tests you simply need to run `bundle exec rspec`, assuming you've already ran `bundle install`.


## Solution Details

### Selection criteria

In order to select the most positive reviews, the application looks at the review rating (1 to 5 stars) and it also calculates a score for the review text itself, using a third party Sentiment Analyser. This score is used as a deciding criteria in case of a tie between the ratings.

It's worth noting that this score is a simple solution that can be improved further if required. Techniques like _n-gram_ analysis or feeding the analyser with your own scores for each word could result in more accurate scores.

### Code Organization

The code is divided in a few modules:
- `Scraping`: Code related to the web scraper. It uses [Mechanize](https://github.com/sparklemotion/mechanize) to perform the actual scraping and uses the [PageObject](https://martinfowler.com/bliki/PageObject.html) pattern to abstract Mechanize's implementation details and provide a simpler interface to the `Scraper` class.
- `Domain`: Core business logic goes here. The idea is for functions in this module to be pure functions, performing no side effects and having no **direct dependencies** to external state or external libraries.
- `Adapters`: This layer is responsible for translating the internal data structure to the format that will get presented on the output.

The `Application` class ties everything together. It's similar to the `Interactor/Use Case` layer from Clean Architecture.

### Third party libraries

- [Mechanize](https://github.com/sparklemotion/mechanize): Ruby gem that does web scraping. Uses Nokogiri as well to parse HTML documents.
- [Textmood](https://github.com/stiang/textmood): Ruby sentiment analyser.
- [VCR](https://github.com/vcr/vcr): Used in integration tests to avoid making actual external HTTP requests. The requests are run once and recorded for further use.

## Next steps

There are some improvements to be done on this application that weren't made due to time. Things like using some sort of type annotation like [dry-schema](https://dry-rb.org/gems/dry-schema/1.5/) or even [RBS](https://github.com/ruby/rbs) on some boundaries of the code, as well as presenting the output in a more readable format instead of Ruby hashes.
