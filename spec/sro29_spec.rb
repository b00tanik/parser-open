# encoding: UTF-8
require 'processors/sro29'
require 'spec_helper'

describe Sro29 do
  
  let(:links) { [
    'http://www.sro29.ru/index.php/reestr-sro', 
    'http://www.sro29.ru/index.php/component/content/article?id=567',
    'http://www.sro29.ru/index.php/component/content/article?id=568',
    'http://www.sro29.ru/index.php/component/content/article?id=569'
    ] }
    
  ORGANIZATIONS = [
    { inn: "6321148842", name: "ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ \"ВЕГА С\"",
      short_name: "ООО \"ВЕГА С\"", city: "Тольятти", status: :w, resolution_date: "29.03.2010",
      legal_address: "445056, Самарская обл., Тольятти, Автостроителей, дом № 41, кв.86",
      certificate_number: "290310/181", ogrn: "-"
    },
    { inn: "7449003296", name: "ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ \"ГАЛАНТ\"",
      short_name: "ООО \"ГАЛАНТ\"", city: "Челябинск", status: :w, resolution_date: "15.03.2010",
      legal_address: "454119, Челябинск, ул. Энергетиков, 66",
      certificate_number: "150310/064", ogrn: "-"
    },
    { inn: "7309901998", name: "ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ \"СУРСКМЕЛИОРАЦИЯ\"",
      short_name: "ООО \"СУРСКМЕЛИОРАЦИЯ\"", city: "рп. Сурское", status: :w, resolution_date: "19.04.2010",
      legal_address: "433240, Ульяновская обл, Сурский р-н, рп. Сурское , ул. Хазова , 132 А",
      certificate_number: "190410/882", ogrn: "-"
    },
    { inn: "5190135115", name: "Общество с ограниченной ответственностью «Альфа-Стройсервис»",
      short_name: "ООО «Альфа-Стройсервис»", city: "Санкт-Петербург", status: :w, resolution_date: "11.03.2010",
      legal_address: "Санкт-Петербург, Запорожская ул., д.21, корп.2, лит.А, офис 1Н",
      certificate_number: "211113/604", ogrn: "-"
    }
  ]
  
  before (:each) do
    @test = Sro29.new
  end
  
  it 'should respond to #perform' do
    expect(@test).to respond_to(:perform)
  end
  
  describe '#perform' do
    
    it 'should call #list_links' do
      expect(@test).to receive(:list_links)
      @test.perform
    end
    
    it 'should call #iterate' do
      expect(@test).to receive(:iterate)
      @test.perform
    end

    it 'should return array with 334 elements' do
      data = @test.perform
      expect(data.class).to eq(Array)
      expect(data.length).to eq(334)
    end
    
    ORGANIZATIONS.each do |org|
      it "should return array with organization #{org[:name]}" do
        expect(@test.perform.include?(org)).to be true
      end
    end
  
  end
  
  describe '#list_links' do
    it 'should collect links to links variable' do
      @test.perform
      expect(@test.instance_variable_get(:@links)).to eq(links)
    end
  end  
  
end