# encoding: UTF-8
class Sro29
  
  FIELDS = {
      inn:                5,
      name:               2,
      short_name:         3,
      city:               -1,
      status:             :w,
      resolution_date:    1,
      legal_address:      8,
      certificate_number: 0,
      ogrn:               '-'
  }
  
  NONCITY = ['обл', 'Обл', 'волость', 'р-н', 'р-он', 'район', 'край', 'проезд',
    'Республика', 'Федерация', 'Югра', ' пр', 'Коми', 'Гатчинский',
    'Чувашия', 'Кольский', 'Адыгея', 'Карачаево-Черкессия', 'Якутия',
    'Чукотский АО', 'Марий Эл', 'Йошкар-Ола', 'Кызылский', 'Тыва',
    'Татарстан', 'Улан-Удэ', 'Башкортостан', 'Стерлитамакский']
  
  def initialize
    @data, @links = [], ['http://www.sro29.ru/index.php/reestr-sro']
  end
  
  def perform
    list_links
    iterate
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
      page.xpath(trs).each_with_index do |tr, tr_index|
        if tr_index > 0
          @org = {}
          tr.xpath('./td/.').each_with_index do |td, td_index|
            field = FIELDS.key(td_index)
            self.__send__(field, 
              CGI::unescapeHTML(
                td.to_s.
                  gsub(/(<\/?[^>]*>|\n)/, ' ').strip.
                    gsub(/\s{2,}/, ' '))) if field
          end
          FIELDS.select{ |field, value| !value.is_a? Numeric }.each{ |field, value| @org[field] = value }
          @org[:city] = city
          @data << @org
        end
      end
    end
  end
  
  def method_missing(name, data)
    @org[name] = data
  end
  
  def city
    address = @org[:legal_address].split(',')
    if address[0] !~ /\A\d+\z/ and !NONCITY.any? { |word| address[0].include?(word) }
      return address[0].strip
    else
      (1..3).each do |index|
        if !NONCITY.any? { |word| address[index].include?(word) }
          if address[index].include? 'Иркутск'
            return 'Иркутск'
          elsif address[index].include? 'дом № 18А'
            return '-'
          else
            return address[index].strip
          end
        end
      end
      return 'пос.Преображенка'
    end
  end
  
end
