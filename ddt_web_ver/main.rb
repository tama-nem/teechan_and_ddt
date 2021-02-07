require 'dxopal'
require_remote './mode.rb'
require_remote './character.rb'
require_remote './material_image.rb'
require_remote './character_images_definer.rb'

include DXOpal
include MaterialImages
include CharacterImagesDefiner
include Characters
include Modes


# Load Character_Images-----------------------
print "Character_Images registering"
character_images = define_chrimg
# --------------------------------------------

# Load Modes----------------------------------
print "Modes Registing"
modes = {}
modes[:opening] = [Modes::Opening_Mode.new(character_images)]

# I think definitions except world 1 have to be delayed
# to avoide heavy loading.
modes[:play] = {1 => Modes::Playing_Mode.new(1, character_images)}
modes[:stage_select] = {1 => Modes::Select_Stage_Mode.new(1, character_images)}
#modes[:story]=...
# --------------------------------------------


# Main-----------------------------------------
Window.load_resources do

  # Initialize Modes-----
  # Tips: Instances of characters are contained in each <Mode> Instances.

  # Initialize current mode status
  print "Initialize mode"
  current_mode = :opening
  current_sub_mode = 0 #Use to distingish stage etc.

  # We have to define allocate image to variable
  # Because allocating them before they have been read completely
  # Leads Error.
  print "Initilize image allocation"
  modes[:opening][0].init_image

  print "Start Main Loop"

  #Loop
  Window.loop do
    modes[current_mode][current_sub_mode].event_key_down(Modes.key_check())
    modes[current_mode][current_sub_mode].event_key_press(Modes.key_press_check())
		modes[current_mode][current_sub_mode].update
	end
end
