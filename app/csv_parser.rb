class CsvParser
  require "csv"
  require "colorize"

  attr_reader :source_file_path
  attr_accessor :report
  attr_accessor :seperator

  def initialize(source_path, source_file_name = nil)
    @source_file_path = source_path
    @report           = []
    @seperator        = nil
  end

  def local_files_to_parse
    @local_files_to_parse ||= Dir[File.join(source_file_path, "*.csv")]
  end

  def default_csv_options
    { col_sep: ',', quote_char: "\x00", headers: true }
  end

  def run!
    raise 'No Files Found' if local_files_to_parse.empty?

    local_files_to_parse.each do |local_file|
      # 1 Load file
      raw_file = load_file(local_file)

      # 1.1  Determine separator
      # determine_separator(raw_file)

      # 2. Parse
      file_data = parse_and_generate_csv!(raw_file)

      # 3 Store file
      store_file_locally!(file_data)
    end
  end

  private

  def load_file local_file
    msg = "Loading File: #{File.basename(local_file)}"
    puts msg.colorize(:red)
    report << msg

    raw_file   = File.open(local_file).read.force_encoding('UTF-8')
    msg = "Original Total Lines Count: #{raw_file.length}"
    puts msg.colorize(:green)
    report << msg
    raw_file
  end

  def determine_separator(raw_file)
    raw_file_line = raw_file.split(/[\n\r]+/).first
    [";", "\t", ","].each do |separator|
      seperator = separator if raw_file_line.match(separator)
    end
  end

  def parse_and_generate_csv!(raw_file)
    csv_data    = CSV.parse(raw_file, default_csv_options)
    product_ids = csv_data.map{ |row| row['id'].to_i }
    msg = "Parsed Total Lines Count: #{product_ids.count}"
    puts msg.colorize(:green)
    report << msg

    CSV.generate(col_sep: ','){|csv| csv << product_ids }
  end

  def store_file_locally!(file_data)
    new_dir_path  = "#{source_file_path}/parsed"
    new_file_path = File.join(new_dir_path, "parsed_file#{Time.now.to_i}")

    FileUtils.mkdir_p(new_dir_path)
    File.open(new_file_path, "wb+") do |f|
      f.puts(file_data)
      f.close
    end
    msg = "Create File: #{new_file_path}"
    puts msg.colorize(:red)
    report << msg
  end
end