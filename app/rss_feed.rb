class RssFeed
  require './app/yaml_builder'
  require 'yaml'

  attr_reader :input_file_path, :output_file_path
  attr_accessor :input_file, :output_file

  def initialize
    @input_file_path = './source/feed.txt'
    @output_file_path = './source/feed.yml'
  end

  def get_data
    raise 'Input file does not exist!' unless File.exist?(input_file_path)

    YamlBuilder.new(source_file_path: input_file_path, output_file_path: output_file_path).create_file!
    YAML.load_file(output_file_path)
  end
end