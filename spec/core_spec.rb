RSpec.describe Tataru::Core do
  let(:core) { Tataru::Core.new }
  context "土曜日に実行された時" do
    around do |e|
      travel_to('2019-5-18 22:00'.to_time){ e.run }
    end
    it "対象のdate_keyを取得できる" do
      expect(core.target_week_date_key).to eq("2019-05-20")
    end
  end

  context "日曜日に実行された時" do
    around do |e|
      travel_to('2019-5-19 1:00'.to_time){ e.run }
    end
    it "対象のdate_keyを取得できる" do
      expect(core.target_week_date_key).to eq("2019-05-20")
    end
  end

  context "月曜日に実行された時" do
    around do |e|
      travel_to('2019-5-20 1:00'.to_time){ e.run }
    end
    it "対象のdate_keyを取得できる" do
      expect(core.target_week_date_key).to eq("2019-05-20")
    end
  end

  context "全員の入力が終わっている時" do
    around do |e|
      travel_to('2019-5-20 1:00'.to_time){ e.run }
    end
    before do
      WebMock.enable!
      allow(core).to receive(:get_choseisan_url).and_return("https://chouseisan.com/s?h=316b94c5ccd54c49b9b8c941dbe3c095")
      stub_request(:get, "https://chouseisan.com/s?h=316b94c5ccd54c49b9b8c941dbe3c095").
      with(
        headers: {
        'Accept'=>'*/*',
        'Accept-Charset'=>'ISO-8859-1,utf-8;q=0.7,*;q=0.7',
        'Accept-Encoding'=>'gzip,deflate,identity',
        'Accept-Language'=>'en-us,en;q=0.5',
        'Connection'=>'keep-alive',
        'Host'=>'chouseisan.com',
        'Keep-Alive'=>'300',
        'User-Agent'=>'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, lik｀e Gecko) Chrome/47.0.2526.106 Safari/537.36'
        }).
      to_return(status: 200, body: File.read("spec/html/complate.html"), headers: {'Content-Type' =>  'text/html' })
      stub_request(:post, ENV['DISCORD_INCOMMING_URL']).
      with(
        body: "{\"content\":\"全員の入力が終わりましたでっす\"}",
        headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Type'=>'application/json',
        'User-Agent'=>'Faraday v0.15.4'
        }).
      to_return(status: 200, body: "", headers: {})
    end

    it "完了のアナウンスを投稿できる" do
      expect(core.announcement_all_member_complete).to eq(true)
    end
  end

  context "全員の入力が終わっていない時" do
    around do |e|
      travel_to('2019-5-20 1:00'.to_time){ e.run }
    end
    before do
      WebMock.enable!
      allow(core).to receive(:get_choseisan_url).and_return("https://chouseisan.com/s?h=316b94c5ccd54c49b9b8c941dbe3c095")
      stub_request(:get, "https://chouseisan.com/s?h=316b94c5ccd54c49b9b8c941dbe3c095").
      with(
        headers: {
        'Accept'=>'*/*',
        'Accept-Charset'=>'ISO-8859-1,utf-8;q=0.7,*;q=0.7',
        'Accept-Encoding'=>'gzip,deflate,identity',
        'Accept-Language'=>'en-us,en;q=0.5',
        'Connection'=>'keep-alive',
        'Host'=>'chouseisan.com',
        'Keep-Alive'=>'300',
        'User-Agent'=>'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, lik｀e Gecko) Chrome/47.0.2526.106 Safari/537.36'
        }).
      to_return(status: 200, body: File.read("spec/html/uncomplate.html"), headers: {'Content-Type' =>  'text/html' })
      stub_request(:post, ENV['DISCORD_INCOMMING_URL']).
      with(
        body: "{\"content\":\"全員の入力が終わりましたでっす\"}",
        headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Type'=>'application/json',
        'User-Agent'=>'Faraday v0.15.4'
        }).
      to_return(status: 200, body: "", headers: {})
    end

    it "完了のアナウンスを投稿できる" do
      expect(core.announcement_all_member_complete).to eq(false)
    end
  end
end
