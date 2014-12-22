# encoding: UTF-8
class Sro29
  
  FIELDS = {
      :inn => 5,
      :name => 2,
      :short_name => 3,
      :city => 8,
      :status => -1,
      :resolution_date => 1,
      :legal_address => 8,
      :certificate_number => 0,
      :ogrn => -1
  }
  
  def initialize
    @data, @links = [], ['http://www.sro29.ru/index.php/reestr-sro']
  end
  
  def perform
    list_links
    iterate
    p @data
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
    @links.each_with_index do |link, link_index|
      page = Nokogiri::HTML(open(link))
      trs = '//table[@border="0" and @cellspacing="0"]/tbody/tr/.'
      header = true
      page.xpath(trs).each_with_index do |tr, tr_index|
        @org = {}
        tr.xpath('./td/.').each_with_index do |td, td_index|
          field = FIELDS.key(td_index)
          self.__send__(field, CGI::unescapeHTML(td.to_s.gsub(/(<\/?[^>]*>|\n)/, ''))) if field
          # @org[:"#{td_index}"] = CGI::unescapeHTML(td.to_s.gsub(/(<\/?[^>]*>|\n)/, ''))
        end
        # p @org
        # exit
        # @required_fields.each { |field| self.__send__(field) }
        FIELDS.select{ |field, num| num == -1 }.each{ |field, num| @org[field] = '-' }
        @data << @org if tr_index > 0
        header = false
      end
      # p @data
      # exit
    end
  end
  
  def method_missing(name, data)
    @org[name] = data
  end
  
end
