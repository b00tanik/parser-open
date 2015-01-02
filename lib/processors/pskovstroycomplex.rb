class Pskovstroycomplex
  def initialize
    @host = 'http://pskovstroycomplex.ru'
    @list_of_links = 'http://pskovstroycomplex.ru/framereestr.php'
    @required_fields = [
      :inn,
      :name,
      :short_name,
      :legal_address,
      :city,
      :status,
      :ogrn,
      :resolution_date,
      :certificate_number
    ]
    @htmls = []
    @data = []
  end

  def perform
    collect_links # сбор ссылок
    iterate # собрать ссылки действующих членов

    @data
  end

  private

  def collect_links

    Capybara.visit @list_of_links

    raw_inns = Capybara.all 'tr td:first-child'
    raw_inns[0..10].each do |raw_inn|
      inn = raw_inn.text.match(/(\d+\.) (\d+)/)[2]
      response = RestClient.post("http://pskovstroycomplex.ru/formreestr.php", 
        "Inn=#{inn}".postize
      )

      @htmls.push response.force_encoding('Windows-1251').encode('UTF-8')
    end
  end

  def iterate
    @htmls.each do |html|
      @html = html
      tmp = {}

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

      @data << tmp

    end
  end

  #_ Required fields _#
  def inn
    raw = @html.split('<strong>ИНН организации:</strong>')[1].split('<br>')[0]
  end

  def ogrn
    raw = @html.split('<strong>Государственный регистрационный номер записи о государственной регистрации юридического лица:</strong>')[1].split('<br>')[0]  
  end

  def short_name
    raw = @html.split('<strong>Сокращенное наименование организации:</strong>')[1].split('<br>')[0]
  end

  def name
    raw = @html.split('<strong>Полное наименование организации:</strong>')[1].split('<br>')[0]  
  end

  def city
    raw = @html.split('<strong>Место нахождения юридического лица:</strong>')[1].split('<br>')[0]  

    test1 = raw.match /\b((пос|гор|пгт|рп|п.г.т.)\. [А-Яа-я\- ]+)\b/
    test2 = raw.match /\b([гсдп]\. ?[А-Яа-я\- ]+)\b/
    test3 = raw.match /\b((р.п.|рабочий поселок) [А-Яа-я\- ]+)\b/

    if test1
      test1[1]  
    elsif test2
      test2[1]
    elsif test3
      test3[1]
    end
  end

  def legal_address
    raw = @html.split('<strong>Место нахождения юридического лица:</strong>')[1].split('<br>')[0]  
  end

  def resolution_date
    raw = @html.split('<strong>Изменения в реестре:</strong>')[1].split('<br>')[1].split('<br>')[0]  
    raw.split('от')[1]
  end

  def certificate_number
    raw = @html.split('<strong>Изменения в реестре:</strong>')[1].split('<br>')[1].split('<br>')[0]
    raw.split('от')[0]
  end

  def status
    raw = @html.split('<strong>Информация об исключении:</strong>')[1].split('<br>')[0]  
    return :w if raw[/отсутствует/i]
    return :e if raw[/исключен/i]
    '-'
  end

end