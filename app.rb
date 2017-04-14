require 'sinatra/base'

class App < Sinatra::Base
  require 'rubygems'
  require 'sinatra'
  require 'shotgun'
  require 'slim'
  require 'pry'
  require 'builder'

  require './app/csv_parser'
  require './app/rss_feed.rb'

  get '/' do
    slim :index
  end

  post '/run' do
    parser = CsvParser.new('./tmp/exports')
    parser.run!
    @report = parser.report
    slim :index
  end

  get '/rss' do
    @rss_data  = RssFeed.new.get_data
    builder :rss
  end
end