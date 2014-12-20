# encoding: UTF-8
class Sro29
  
  FIELDS = [
      :inn,
      :name,
      :short_name,
      :city,
      :status,
      :resolution_date,
      :legal_address,
      :certificate_number,
      :ogrn
    ]
  
  def initialize
    @data, @links = [], ['http://www.sro29.ru/index.php/reestr-sro']
  end
  
  def perform
    list_links
    iterate
  end
  
  private
  
  def list_links
    list_link = @links[0]
    
    while list_link.length > 0
      doc = Nokogiri::HTML(open(list_link))
      list_link = doc.xpath('//a[text()="следующая страница"]/@href').first.to_s
      @links << list_link if list_link.length > 0
    end
  end

  def iterate
    
  end
end