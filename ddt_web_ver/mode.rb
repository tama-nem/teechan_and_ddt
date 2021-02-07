require 'dxopal'
require_remote './material_image.rb'

include DXOpal
include MaterialImages

module Modes
	# Define Mode-----
	class Mode
		attr_reader :background, :characters

		# Note: @character_images is Array of Objects(CharacterImage)
		def initialize(character_images_data)
			@character_images = character_images_data
			#@sound =
			#...
		end

		def init_image
			@characters.each {|c| c.init_image}
		end

		def event_key_down(keyarray)
			raise "Error: event_key_down(keyarray) must be overrided."
		end

		def event_key_press(keyarray)
			raise "Error: event_key_press(keyarray) must be overrided."
		end

		def event_pad_down
			raise "Error: event_pad_down must be overrided."
		end

		def update
			@background.draw
			@characters.each do |c|
				c.administrate_state
				c.draw
			end
		end

	end

	# オープニング画面
	class Opening_Mode < Mode
		def initialize(character_images_data)
			super(character_images_data)

			@background = BackGround.new(name: "opening", \
			 filepath: './game_images/opening.jpg', \
			 original_width: 3300.0, original_height: 2500.0)

			@options=[{name: :gamestart, x: 100, y: 150, right: 1},
								{name: :blank1, x: 300, y: 150, right: 3, left: 0, up: 2},
								{name: :drinkrecord, x: 300, y: 50, down: 1},
								{name: :blank2, x: 450, y: 150, left:1, down: 4, up: 2},
								{name: :quit, x: 450, y: 230, left:1, up: 3}
							 ]
			@temp_select=0

			@characters = \
			 [Character.new( @character_images[:opening_otama], \
				 init_x: @options[0][:x], init_y: @options[0][:y] )]
		end

		def event_key_down(keyarray)

		end

		def event_key_press(keyarray)

			return if keyarray.length==0
			pressed_main_key = keyarray[0]

			if @options[@temp_select].has_key?(pressed_main_key) then
				@temp_select=@options[@temp_select][pressed_main_key]
				@characters[0].set_xy(@options[@temp_select][:x], @options[@temp_select][:y])
			elsif pressed_main_key == :enter then
				case @options[@temp_select][:name]
				when :quit
					`window.open('about:blank', '_self').close();`
				end
			end

		end

		def event_pad_down

		end

	end

	# プレイ画面
	class Playing_Mode < Mode
		def initialize(world, character_images_data) # World starts 1!
			super(character_images_data)

			@background = BackGround.new(name: "playing#{world}", \
			 filepath: "game_images/background/stage/#{world}_background.jpg", \
			 original_width: 3300.0, original_height: 2500.0)
			@characters = []
		end

		def event_key_down(keyarray)

		end
		def event_key_press(keyarray)

		end
		def event_pad_down

		end
	end

	class Select_Stage_Mode < Mode
		def initialize(world, character_images_data)
			super(character_images_data)
		end

		def event_key_down(keyarray)

		end
		def event_key_press(keyarray)

		end
		def event_pad_down

		end
	end

	class Story_Mode < Mode
		def initialize(character_images_data)
			super(character_images_data)
		end

		def event_key_down(keyarray)

		end
		def event_key_press(keyarray)

		end
		def event_pad_down

		end
	end


	def key_check()
		keyarray = []
		keyarray.push :down if Input.key_down?(K_DOWN)
		keyarray.push :up if Input.key_down?(K_UP)
		keyarray.push :left if Input.key_down?(K_LEFT)
		keyarray.push :right if Input.key_down?(K_RIGHT)
		keyarray.push :space if Input.key_down?(K_SPACE)
		keyarray.push :enter if Input.key_down?(K_RETURN)
		return keyarray
	end
	def key_press_check()
		keyarray = []
		keyarray.push :down if Input.key_push?(K_DOWN)
		keyarray.push :up if Input.key_push?(K_UP)
		keyarray.push :left if Input.key_push?(K_LEFT)
		keyarray.push :right if Input.key_push?(K_RIGHT)
		keyarray.push :space if Input.key_push?(K_SPACE)
		keyarray.push :enter if Input.key_push?(K_RETURN)
		return keyarray
	end

	def pad_check

	end

	module_function :key_check, :pad_check

end
