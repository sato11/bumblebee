require 'aws-sdk'
require 'nokogiri'
require './lib/html_table'

HTML_IDS = %w(team_batting team_pitching standard_roster)

def client
  @client ||= Aws::S3::Client.new(
    region: ENV.fetch('S3_REGION'),
    access_key_id: ENV.fetch('S3_ACCESS_KEY_ID'),
    secret_access_key: ENV.fetch('S3_SECRET_ACCESS_KEY'),
  )
end

def parse_html(event:, context:)
  key = event['Records'][0]['s3']['object']['key']
  object = client.get_object(
    bucket: ENV.fetch('S3_BUCKET'),
    key: key
  )

  html = object.body.read.gsub(/(<!--|-->)/, '')
  doc = Nokogiri::HTML.parse(html)

  HTML_IDS.each do |id|
    table = doc.css("table##{id}")
    html_table = HtmlTable.new(table)
    csv = html_table.to_csv
    client.put_object(
      body: csv,
      bucket: ENV.fetch('S3_BUCKET'),
      key: key.gsub('html', 'csv').gsub('.csv', "/#{id}.csv")
    )
  end
end
