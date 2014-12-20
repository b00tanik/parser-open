require 'processors/sro29'

describe Sro29 do
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
  
  end
  
end