require 'webmock/rspec'
require 'open-uri'
require_relative '../config/initializers/capybara'

WebMock.disable_net_connect!(allow_localhost: true)

LPATH = File.expand_path(File.dirname(__FILE__))
LINKS = {
  'http://www.sro29.ru/index.php/reestr-sro' => 
    "#{LPATH}/../test/pages/sro29_0.html",
  'http://www.sro29.ru/index.php/component/content/article?id=567' =>
    "#{LPATH}/../test/pages/sro29_1.html",
  'http://www.sro29.ru/index.php/component/content/article?id=568' =>
    "#{LPATH}/../test/pages/sro29_2.html",
  'http://www.sro29.ru/index.php/component/content/article?id=569' =>
    "#{LPATH}/../test/pages/sro29_3.html"
}

RSpec.configure do |config|
  config.before(:each) do
    LINKS.each do |link, file|
      stub_request(:get, link).with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>
        'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => File.open(file).read, :headers => {})
    end
  end
end
