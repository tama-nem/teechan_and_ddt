require 'dxopal'
require_remote './material_image.rb'

include DXOpal
include MaterialImages

module Characters
	class Character < Sprite

		def initialize(character_image_source, init_x: 0, init_y: 0)
			@imageobj = character_image_source
			self.x = init_x
			self.y = init_y

			@current_interval_point = 0
			@current_cutting_index_x = 0
			@current_cutting_index_y = 0
		end

		def init_image
			self.image = Image[@imageobj.name]
		end

		def draw
			sliced = self.image.slice( \
				@current_cutting_index_x*@imageobj.cut_width, \
				@current_cutting_index_y*@imageobj.cut_height, \
				@imageobj.cut_width, @imageobj.cut_height)
	  	Window.draw_scale(self.x, self.y, sliced, \
	  		 @imageobj.resize_factor_x, @imageobj.resize_factor_y, 0, 0)
		end

		def administrate_state
			@current_interval_point += 1
			if @current_interval_point == @imageobj.switch_interval then
				set_next_cutting_index
				@current_interval_point = 0
			end
		end

		def set_next_cutting_index
			if @imageobj.cut_x_prior then
				@current_cutting_index_x += 1
				if @current_cutting_index_x == @imageobj.cut_number_x then
					@current_cutting_index_x=0
					@current_cutting_index_y+=1
					if @current_cutting_index_y == @imageobj.cut_number_y then
						@current_cutting_index_y=0
					end
				end
			else
				@current_cutting_index_y += 1
				if @current_cutting_index_y == @imageobj.cut_number_y then
					@current_cutting_index_y=0
					@current_cutting_index_x+=1
					if @current_cutting_index_x == @imageobj.cut_number_x then
						@current_cutting_index_x=0
					end
				end
			end
		end

=begin
		def x
			self.x
		end
		def y
			self.y
		end
=end
		def xy
			[self.x, self.y]
		end
		def set_x(value)
			self.x = value
		end
		def set_y(value)
			self.y = value
		end
		def set_xy(xval, yval)
			set_x xval
			set_y yval
		end
	end
end
