require 'processors/sro29'

describe Sro29 do
  before (:each) do
    @test = Sro29.new
  end
  
  it 'should respond to #perform' do
    expect(@test).to respond_to(:perform)
  end
  
end