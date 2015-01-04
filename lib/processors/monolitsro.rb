class Monolitsro
  def initialize
    @host = 'http://www.monolitsro.ru'
    @list_of_links = 'http://www.monolitsro.ru/IFrames/Organizations.aspx?FrameID=Organizations'
    @required_fields = [
      :inn,
      :ogrn,
      :name,
      :short_name,
      :legal_address,
      :city,
      :certificate_number,
      :resolution_date,
      :status
    ]
    @links = []
    @data = []
  end

  def perform
    collect_links # Сбор ссылок
    # iterate # Переход и сбор информации

    # p @data
  end

  private

  def collect_links
    Capybara.visit @list_of_links
    puts 'here'
    sleep 20
    p Capybara.text
    Capybara.save_screenshot 'hi.png'
    Capybara.all("tbody tr td:nth-child(3) a").each do |link|
      @links.push "@host/#{link['href']}"
      p 'hi'
    end
    p @links
  end

  def iterate
    @links[-50..-1].each do |link|
      puts "start parsing #{link}"
      begin
        @doc = Nokogiri::HTML(open(link))
      rescue
        puts 'next link'
        next #if link is inaccessible
      end

      tmp = Hash.new
      @required_fields.each do |m|
        begin
          value = self.send m #for status symbols
          value = '-' if (value.nil? or value.empty?)
          value.strip! if value.is_a? String
        rescue
          value = '-'
        end
        tmp.merge! m => value
      end
      @data << tmp #@data = [tmp, {@required_fields[0] => 'value'}]
      puts "parsed"
    end
  end

  #### Fields methods ####

  ## Required fields ##
  def inn
    raw = @doc.css('#tabs-1').css('tr:contains("ИНН:")').at_css('td').text
  end

  def ogrn
    raw = @doc.css('#tabs-1').css('tr:contains("ОГРН / ОГРНИП:")').at_css('td').text
  end

  def short_name
    raw = @doc.at_css('#MainContent_lbl_namesocr')
    raw.children.to_s.encode('utf-8').split('<br><br>')[0]
  end

  def name
    raw = @doc.at_css('#MainContent_lbl_namesocr')
    raw.children.to_s.encode('utf-8').split('<br><br>')[1]
  end

  def legal_address
    raw = @doc.css('#tabs-1').css('tr:contains("Адрес места нахождения:")').at_css('td').text
  end

  def city
    raw = @doc.css('#tabs-1').css('tr:contains("Адрес места нахождения:")').at_css('td').text
    test1 = raw.match /\b((пос|гор|пгт|рп|п\.г\.т)\. [А-Яа-яё\- ]+)\b/
    test2 = raw.match /\b((р.п.|рабочий поселок|город|село) [А-Яа-яё\- ]+)\b/
    test3 = raw.match /\b([гсдп]\. ?[А-Яа-яё\- ]+)\b/

    if raw[/москва/i]
      'г. Москва'
    elsif raw[/санкт ?\- ?петербург/i]
      'г. Санкт-Петербург'
    elsif test1
      test1[1]  
    elsif test2
      test2[1]
    elsif test3
      test3[1]
    end
  end

  def certificate_number
    raw = @doc.css('#tabs-2 tbody').css('tr')[0].css('td')[1].text
  end

  def resolution_date
    raw = @doc.css('#tabs-2 tbody').css('tr')[0].css('td')[3].text
  end

  def status
    raw = @doc.css('#tabs-1').css('tr:contains("Членство в СРО:")').at_css('td').text
    return :w if raw[/состоит/i]
    return :e if raw[/прекращено/i]
    '-'
  end
  
end

# Monolitsro.new.perform