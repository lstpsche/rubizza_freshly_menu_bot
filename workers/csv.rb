require 'csv'
require_relative '../lib/dependencies'

class Csv
  def initialize
  end

  def parse_file(file_path:)
    csv.read(file_path, headers: true)
  end
end
