class YamlBuilder
  attr_accessor :source_file, :quotes_hash
  attr_reader :output_file_path, :source_file_path

  ALLOWED_SOURCE_FORMATS = [".txt"]

  def initialize(args = {})
    @source_file_path = args[:source_file_path]
    @output_file_path = args[:output_file_path]
    @quotes_hash      = {'quotes' => []}
  end

  def create_file!
    parse_source_file

    File.open(output_file_path, "w") do |file|
      file.write quotes_hash.to_yaml
    end
  end

  def parse_source_file
    source_file = File.open(source_file_path, 'r') if source_file_path
    raise 'Unsuported format' unless ALLOWED_SOURCE_FORMATS.index(File.extname(source_file))

    (lines = File.readlines('./source/feed.txt')).each_with_index do |line, index|
      if line == "\n"
        lines.delete(line)
      else
        # line ex: ["“Every time we launch a feature, people yell at us.”", " - ", "Angelo Sotira, deviantART co-founder\n"]
        attrs = line.split(/“*.”/) # line.split(/( - )/)

        author_attr = (attrs[1].split(/\s+-/)[1] rescue raise line)

        quotes_hash['quotes'] << { 'quote'      => (attrs[0] rescue raise line),
                                   'author'     => (author_attr.split(', ')[0] rescue raise line),
                                   'occupation' => (author_attr.split(', ')[-1].gsub!("\n", "") rescue raise line)
                                  }
      end
    end
  end
end