require 'dxopal'
include DXOpal

# Define Background Images------
module MaterialImages
  class MaterialImage
  	attr_reader :name, :path

  	def register
  		Image.register(@name, @path)
      print "#{@name} #{@path} registered"
    end
  end

  class BackGround < MaterialImage
  	attr_reader :resize_factor_x, :resize_factor_y

  	def initialize(name:, filepath:, \
  	 original_width: 640.0, original_height: 480.0)
  		@name = name
  		@path = filepath
  		@resize_factor_x = 640.0 / original_width
  		@resize_factor_y = 480.0 / original_height
  		register()
      print "#{@name} initialized"
  	end

  	def draw
  		Window.draw_scale(0, 0, Image[@name], \
  		 @resize_factor_x, @resize_factor_y, 0, 0)
  	end
  end


  class CharacterImage < MaterialImage
  	attr_reader :cut_start_left, :cut_start_top, :cut_width, :cut_height, \
  	 :cut_number_x, :cut_number_y, :cut_x_prior, :switch_interval,
     :resize_factor_x, :resize_factor_y

  	def initialize(name:, filepath:, \
  	 cut_start_left:0, cut_start_top:0, cut_width:100, cut_height:100, \
  	 cut_number_x:1, cut_number_y:1, cut_x_prior:true, switch_interval:10, \
     resize_factor_x:1.0, resize_factor_y:1.0)
  		@name = name
  		@path = filepath
  		@cut_start_left, @cut_start_top = cut_start_left, cut_start_top
  		@cut_width, @cut_height = cut_width, cut_height
  	  @cut_number_x, @cut_number_y = cut_number_x, cut_number_y
  		@cut_x_prior = cut_x_prior
  		@switch_interval = switch_interval
      @resize_factor_x, @resize_factor_y = resize_factor_x, resize_factor_y
  		register()
      print "#{@name} initialized"
  	end
  end


end
