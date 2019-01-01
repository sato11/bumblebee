require 'csv'

class HtmlTable
  attr_reader :table

  # @params table [Nokogiri::XML::NodeSet]
  def initialize(table)
    @table = table
  end

  # @return [String]
  def to_csv
    (header + body).map(&:to_csv).join('')
  end

  # @params root [Nokogiri::XML::NodeSet]
  # @return [Array<Array<String,Integer>>]
  def parse(root)
    data = []

    root.css('tr').each do |row|
      row_data = []

      row.css('th,td').each do |cell|
        row_data << cell.text
      end

      data << row_data
    end

    data
  end

  def header
    parse table.css('thead')
  end

  def body
    parse table.css('tbody')
  end
end
