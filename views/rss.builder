xml.instruct! :xml, :version => '1.0'
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Inpirational Quotes"
    xml.description "Get some inspiration"
    xml.link "localhost:9393"

    @rss_data['quotes'].each do |rss_line|
      xml.item do
        xml.title rss_line['quote']
        xml.author rss_line['author']
        xml.occupation rss_line['occupation']
        xml.pubDate Time.parse(Time.now.to_s).rfc822()
      end
    end
  end
end
