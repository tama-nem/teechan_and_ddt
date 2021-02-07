require 'opal'
require 'opal-jquery'
require 'date'
require 'json'
require 'alert.rb'
require 'read_setting_json.rb'

module HashDataWithTime
  module_function

  def get_from_hash(hash_with_time)
    img=""
    hash_with_time.each {|hr, path| img = path if hr === Time.now.hour}
    return img
  end
end

class MenuSelectArea
  include HashDataWithTime

  attr_reader :x1, :y1, :x2, :y2, :baloon_string

  def initialize(x1, y1, x2, y2, bg_image_hash, fade_image_hash, baloon_string)
    @x1, @y1, @x2, @y2, @bg_image_hash, @fade_image_hash, @baloon_string = \
     x1, y1, x2, y2, bg_image_hash, fade_image_hash, baloon_string
  end

  def fade_image
    time = Time.now.hour
    @fade_image_hash.each do |range, imgfile|
      next if imgfile.nil?
      return imgfile if range === time
    end
    return "nilClass"
  end

  def bg_image
    get_from_hash(@bg_image_hash)
  end
end

class WholeClickedArea
  include HashDataWithTime

  def initialize(readsetting_json_instance)
    @bg_abs_width, @bg_abs_height = 1012, 629

    # 背景と始まりの背景を定義
    @bg_path = readsetting_json_instance.background.setting
    @bg_start_path = readsetting_json_instance.background_start.setting


=begin
    @bg_path = {0..5 => "map_objects_night/teru_map_bg-night.png", \
    6..18 => "map_objects/teru-map_bg.png", 19..24 => "map_objects_night/teru_map_bg-night.png"}
    @bg_start_path = {0..5 => "map_objects_night/teru_map_bg_start-night.png", \
    6..18 => "map_objects/teru-map_bg_start.png", 19..24 => "map_objects_night/teru_map_bg_start-night.png"}
=end

    #選択項目の定義
    #項目範囲x1,y1,x2,y2, マウスカーソル乗った時の画像、クリックした時の画像、セリフ

    #sp and st are the spot names and settings of them.
    @selections = readsetting_json_instance.spots.map do |sp, st|
      x1, y1, x2, y2 = st.original_data["Area"]
      MenuSelectArea.new(x1, y1, x2, y2, \
       st.bg_schedule.setting, st.fi_schedule.setting, \
       st.original_data["Comment"])
    end

=begin
    @selections = \
     [MenuSelectArea.new(89, 198, 406, 386, \
       {0..24 => "map_objects/teru-map-nanairo_dining.png"},
       {0..5 => "night.jpg", 6..18 => "noon.jpg", 19..24 => "night.jpg"}, \
       "町一番のファミレスよ。ドリンクバーの充実ぶりが大変よきことよ。"),
      MenuSelectArea.new(55, 399, 293, 620, \
       {0..24 => "map_objects/teru-map-oshama_house.png"},
       {0..5 => "night.jpg", 6..18 => "noon.jpg", 19..24 => "night.jpg"}, \
       "レディ御用達のブティックなの。最近リニューアルして話題よ！"),
      MenuSelectArea.new(524, 211, 715, 389, \
       {0..24 => "map_objects/teru-map-teechan_no_ie.png"},
       {0..5 => "night.jpg", 6..18 => "noon.jpg", 19..24 => "night.jpg"}, \
       "レディの住まいへようこそ！何をくれるのかしら？"),
      MenuSelectArea.new(395, 350, 633, 602, \
       {0..24 => "map_objects/teru-map-bc_station.png"},
       {0..24 => "twitter"}, \
       "てゑの日常を配信しちゃうことよ"),
      MenuSelectArea.new(668, 424, 926, 655, \
       {0..24 => "map_objects/teru-map-grass_field.png"},
       {0..5 => "night.jpg", 6..18 => "noon.jpg", 19..24 => "night.jpg"}, \
       "みんなの集まる原っぱよ。パーティーもできるわよ"),
      MenuSelectArea.new(0, 0, 2000, 5000, @bg_path, \
       {0..24 => nil}, "")]
=end

    @temporary_target = @selections[0]
    @imagefolder = ReadSettingJSON::IMAGE_FOLDER
  end

  # マウスを動かすと呼び出される、
  # 現在のアクティブMenuSelectAreaの更新メソッド
  def revice_temporary_target(abs_x, abs_y)
    x = abs_x.to_f * @bg_abs_width.to_f / Window.element.width.to_f
    y = abs_y.to_f * @bg_abs_width.to_f / Window.element.width.to_f

    @selections.each do |s|
      if s.x1<=x && x<s.x2 && s.y1<=y && y<s.y2
        @temporary_target = s
        return temporary_background
      end
    end
  end

  # マウスイベントを行った時、
  # 現在アクティブな(@temporary_targetに入った)MenuSelectAreaを呼び出して
  # 画像やセリフ取得
  def temporary_background
    @imagefolder + @temporary_target.bg_image
  end
  def temporary_fade
    @imagefolder + @temporary_target.fade_image
  end
  def temporary_baloon_string
    @temporary_target.baloon_string
  end

  # 最初のアニメーションだけに使用
  # 背景画像の選択をしている。こちらはこのクラスのデータから直接取得
  def bg_image_start
    @imagefolder + get_from_hash(@bg_start_path)
  end
  def bg_image
    @imagefolder + get_from_hash(@bg_path)
  end

end

class TeruAnimation

  attr_reader :started

  def initialize(start_bg, body, mark)
    @started=false
    @start_bg = start_bg
    @body = body
    @mark = mark
  end

  def fuwafuwa
    #2.times do
      @body.animate({marginTop: "-=20px", speed: 800})
      @body.animate({marginTop: "+=20px", speed: 800})
    #end
  end

  def fuwapikarin
    @body.animate({left: "73%", top: "13%", transform: "rotate(0deg)", opacity: 1.0, speed: 1750}) do
      @body.animate({marginTop: "-=20px", speed: 800}) do
        @body.animate({marginTop: "+=20px", speed: 800}) do
          @mark.effect(:show, 100) do
            @start_bg.effect(:fade_out, 2000)
            @started=true
          end
        end
      end
    end
  end

  def hide_mark
    @mark.css "display", "none"
  end

end


# JSON読み込み後の処理を全てここ(mainprog関数)に書く
mainprog = Proc.new do |readsetting_json_instance|

  temp_x, temp_y = 0, 0
  baloon_article=""

  ## p readsetting_json_instance.background.setting

  # JSONで読み出したデータの参照練習。これを参考にがんばれ
  # WholeClickedAreaのinitializeにこのread...instanceを
  # 渡せばできるっしょ、という。
  # 背景画像もWholeClickedAreaのなかで保持するようにして、
  # TeruAnimationで昼夜の切替を行う
  wca = WholeClickedArea.new(readsetting_json_instance)

  Document.ready? do

    #ここに昼夜による背景画像切替-----
    p "start: #{wca.bg_image_start}"
    Element["#bgim-start"]["src"] = wca.bg_image_start
    Element["#bgim"]["src"] = wca.bg_image
    #----------------------------

    # てゑちゃんを定義
    ta = TeruAnimation.new( Element[".background-image-start"], \
      Element[".top-character"], Element[".top-character-mark"])

    # 初めのアニメーション実行
    ta.fuwapikarin

    # マウス移動イベント
    Element['#js-modal-open'].on(:mousemove) do |e|

      # 背景画像切替
      temp_x, temp_y = e.page_x, e.page_y
      e.target["src"] = wca.revice_temporary_target(temp_x, temp_y)

      #吹き出しせりふ読み込み
      past_article = baloon_article
      baloon_article = wca.temporary_baloon_string

      #吹き出しせりふ切替
      change_text('#fukidashi-text', baloon_article)

      #吹き出し表示・非表示切替
      if baloon_article =~ /^\s*$/ then
        Element['#fukidashi-text'].effect(:hide,100)
      else
        if past_article != baloon_article && ta.started then
          ta.hide_mark
          #Element["#fukidashi-text"].remove_class("hidden")
          Element['#fukidashi-text'].effect(:slide_down, 500)
          ta.fuwafuwa
        end
      end

    end

    # クリック時にライブ表示
    Element['#js-modal-open'].on(:mousedown) do |e|
      wca.revice_temporary_target(temp_x, temp_y)
      fadeimage = wca.temporary_fade
      if !(fadeimage =~ /nilClass/)
        if fadeimage =~ /twitter/ then
            window_open('https://twitter.com/watashi_teechan')
        else
          Element['#fade-image']["src"] = fadeimage
          Element['#fade-image'].effect(:fade_in)
        end
      end
      return false
    end

    # ライブ閉じる
    Element['#fade-image-link'].on(:mousedown) do |e|
      Element['#fade-image'].effect(:fade_out)
      return false
    end
  end
end

ReadSettingJSON.new("app/setting.json", mainprog)
