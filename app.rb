require 'sinatra/base'

class App < Sinatra::Base
  require 'rubygems'
  require 'sinatra'
  require 'shotgun'
  require 'slim'
  require 'pry'

  require './app/csv_parser'

  get '/' do
    slim :index
  end

  post '/run' do
    parser = CsvParser.new('./tmp/exports')
    parser.run!
    @report = parser.report
    slim :index
  end
end