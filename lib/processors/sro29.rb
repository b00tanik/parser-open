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
    # p @data
    @data
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
    @links.each_with_index do |link, index|
      page = Nokogiri::HTML(open(link))
      # xpath = index == 0 ? '//td[@class="ce2"]/p/text()' : '//td[@class="xl64"]/text()'
      trs = '//table[@border="0" and @cellspacing="0"]/tbody/tr/.'
      header = true
      page.xpath(trs).each_with_index do |tr, index|
      # page.xpath(xpath).each_with_index do |org, index|
      # page.xpath('//div[@class="block-i"]/div[contains(@style,"cursor:pointer")]/p/.').each do |org|
        # org = org.to_s.encode('utf-8')
        # @org_fields = org.match(REGEXP)
        # @org = {}
        @org = tr.to_s
        # p "#{index} - #{@org}"
        # @required_fields.each { |field| self.__send__(field) }
        @data << @org if !header
        header = false
      end
    end
  end
end