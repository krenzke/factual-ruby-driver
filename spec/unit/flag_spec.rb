require 'spec_helper'

describe Factual::Write::Flag do
  include TestHelpers

  before(:each) do
    @token = get_token
    @api = get_api(@token)
    @basic_params = {
      :table => "global",
      :factual_id => "id123",
      :problem => :duplicate,
      :user => "user123" }
    @klass = Factual::Write::Flag
    @flag = @klass.new(@api, @basic_params)
  end

  it "should be able to write a basic flag" do
    @flag.write
    expect(@token.last_url).to eq "http://api.v3.factual.com/t/global/id123/flag"
    expect(@token.last_body).to eq "problem=duplicate&user=user123"
  end

  it "should not allow an invalid problem" do
    bad_params = @basic_params.merge!(:problem => :foo)
    raised = false
    begin
      bad_flag = @klass.new(@api, bad_params)
    rescue
      raised = true
    end
    expect(raised).to be_truthy
  end

  it "should not allow an invalid param" do
    bad_params = @basic_params.merge!(:foo => :bar)
    raised = false
    begin
      bad_flag = @klass.new(@api, bad_params)
    rescue
      raised = true
    end
    expect(raised).to be_truthy
  end

  it "should be able to set a comment" do
    @flag.comment("This is my comment").write
    expect(@token.last_url).to eq "http://api.v3.factual.com/t/global/id123/flag"
    expect(@token.last_body).to eq "problem=duplicate&user=user123&comment=This+is+my+comment"
  end

  # deprecating data option
  # it "should be able to set data" do
  #   @flag.data(factual_id: ["id123123", "id324234"]).write
  #   @token.last_url).to eq "http://api.v3.factual.com/t/global/id123/flag"
  #   @token.last_body).to eq "problem=duplicate&user=user123&data=%7B%22factual_id%22%3A%5B%22id123123%22%2C%22id324234%22%5D%7D"
  # end

  it "should be able to set the debug flag" do
    @flag.debug(true).write
    expect(@token.last_url).to eq "http://api.v3.factual.com/t/global/id123/flag"
    expect(@token.last_body).to eq "problem=duplicate&user=user123&debug=true"
  end

  it "should be able to set a reference" do
    @flag.reference("http://www.google.com").write
    expect(@token.last_url).to eq "http://api.v3.factual.com/t/global/id123/flag"
    expect(@token.last_body).to eq "problem=duplicate&user=user123&reference=http%3A%2F%2Fwww.google.com"
  end

  it "should be able to return a path" do
    expect(@flag.path).to eq "/t/global/id123/flag"
  end

  it "should be able to return a body" do
    expect(@flag.body).to eq "problem=duplicate&user=user123"
  end
end
