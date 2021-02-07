require 'opal'
require 'opal-jquery'
require 'date'
#require 'alert.rb'

class MenuSelectArea
  attr_reader :x1, :y1, :x2, :y2, :bg_image

  def initialize(x1, y1, x2, y2, bg_image, fade_image_hash)
    @x1, @y1, @x2, @y2, @bg_image, @fade_image_hash = \
     x1, y1, x2, y2, bg_image, fade_image_hash
  end

  def fade_image
    time = Time.now.hour
    @fade_image_hash.each {|range, imgfile| return imgfile if range === time}

=begin
    #test
    images = @fade_image_hash.values.map(&:itself)
    if Time.now.min % 2 == 0
      return images[0]
    else
      return images[1]
    end
=end
  end
end

class WholeClickedArea
  def initialize
    @selections = [MenuSelectArea.new(42, 162, 295, 333, "background_event.jpg",
                        {0..5 => "night.jpg", 6..18 => "noon.jpg", 19..24 => "night.jpg"}),
                   MenuSelectArea.new(0, 0, 1012, 629, "background.jpg", {0..24 => nil})]
    @temporary_target = @selections[0]
    @imagefolder = "./images/"
  end

  def revice_temporary_target(x, y)
    @selections.each do |s|
      if s.x1<=x && x<s.x2 && s.y1<=y && y<s.y2
        @temporary_target = s
        return temporary_background
      end
    end
  end

  def temporary_background
    @imagefolder + @temporary_target.bg_image
  end
  def temporary_fade
    print @temporary_target.fade_image
    @imagefolder + @temporary_target.fade_image
  end

end

wca = WholeClickedArea.new
temp_x, temp_y = 0, 0

Document.ready? do
  Element['.js-modal-open'].on(:mousemove) do |e|
    temp_x, temp_y = e.page_x, e.page_y
    e.target["src"] = wca.revice_temporary_target(temp_x, temp_y)
  end

  Element['.js-modal-open'].on(:mousedown) do |e|
    fadeimage = wca.temporary_fade(temp_x, temp_y)
    print fadeimage
    if !(fadeimage.nil?)
      Element['#fade-image']["src"] = fadeimage
      Element['.js-modal'].effect(:fade_in)
	     # <p><img id="fade-image" src="./images/noon.jpg"><br>
      return false
    end
  end

  Element['.js-modal-close'].on(:click) do |e|
    Element['.js-modal'].effect(:fade_out)
    return false
  end
end
