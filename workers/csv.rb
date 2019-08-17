require 'csv'
require_relative '../lib/dependencies'

class Csv
  def self.parse_file(file_path:)
    CSV.read(file_path, headers: true)
  end
end
