require 'rubygems'
require 'sinatra'
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