require "opal"
require 'opal-jquery'
require "json"
require "native"

class Schedule
  attr_reader :setting

  # schedule_array format:
  # [[t11, t21, path1], [t12, t22, path2], [t13, t23, path3], ...]
  def initialize(schedule_array)
    @setting = schedule_array.each_with_object({}) do |itm, ans|
      ans[itm[0]..itm[1]] = itm[2]!="nil" ? itm[2] : nil
    end
  end

end

class Spot
  attr_reader :original_data
  attr_reader :bg_schedule, :fi_schedule

  def initialize(data)
    @original_data = data

    @bg_schedule = Schedule.new(@original_data["Clicked_Back_Image"])
    @fi_schedule = Schedule.new(@original_data["Fade_In_Image"])
  end
end

class ReadSettingJSON
  IMAGE_FOLDER = "./images/"

  attr_reader :original_hash, :spots_only_hash
  attr_reader :background, :background_start, :spots

  def initialize(file, main)

    ans = ""

    %x{
      // リクエスト定義
      var request = new XMLHttpRequest()
      request.open('GET', file, true)
      request.responseType = 'text'

      // ロード時は変数ansへ受け渡し
      request.onload = () =>  {
        ans = request.responseText
      }

      // ロード完了したらjsonパースして、画像をプリロード。そしてサイトのメインプログラム実行！
      request.onloadend = () => {
        #{
          parse ans
          preread_images_and_proceed(main)
        }
      }

      // 読み込みエラー時の処理はここに書くらしいです
      request.onerror = () => {}

      request.send()
    }
  end

  # JSONパース部分
  def parse(textlines)
    @original_hash = JSON.parse(textlines)
    # @original_hash = JSON.load(f)
    @spots_only_hash = original_hash.clone.delete_if{|k, _| k =~ /BackGround/}

    @background = Schedule.new(@original_hash["BackGround"])
    @background_start = Schedule.new(@original_hash["BackGround-Start"])
    @spots = @spots_only_hash.each_with_object({}) do |(k, v), ans|
      ans[k] = Spot.new(v)
    end

    p @background
    p @background_start
    p @spots
  end

  # ここで、先に画像ファイルを読み込む。全部読み込んだところでmainスタート！
  def preread_images_and_proceed(main)
    fs = all_image_files()
    imnum, targetnum = 0, fs.length

    fs.each do |img_file|
      %x{
        $("<img/>").attr("src", img_file).load(function() {
          imnum++;
          #{ main.call(self) if imnum==targetnum }
        });
      }
    end
  end

  # 画像を列挙
  def all_image_files
    ans = []

    @background.setting.each_value{|v| ans.push IMAGE_FOLDER + v}
    @background_start.setting.each_value{|v| ans.push IMAGE_FOLDER + v}

    @spots.each_value do |v_spt|
      v_spt.bg_schedule.setting.each_value {|v| ans.push IMAGE_FOLDER + v if !v.nil?}
      v_spt.fi_schedule.setting.each_value {|v| ans.push IMAGE_FOLDER + v if !v.nil?}
    end

    return ans.uniq.compact
  end
end
