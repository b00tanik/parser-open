require 'processors/sro29'
require 'spec_helper'

describe Sro29 do
  
  let(:links) { [
    'http://www.sro29.ru/index.php/reestr-sro', 
    'http://www.sro29.ru/index.php/component/content/article?id=567',
    'http://www.sro29.ru/index.php/component/content/article?id=568',
    'http://www.sro29.ru/index.php/component/content/article?id=569'
    ] }  
  
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

    # it 'should return array with 334 elements' do
    #   data = @test.perform
    #   expect(data.class).to eq(Array)
    #   expect(data.length).to eq(334)
    # end
  
  end
  
  describe '#list_links' do
    it 'should collect links to links variable' do
      @test.perform
      expect(@test.instance_variable_get(:@links)).to eq(links)
    end
  end  
  
end