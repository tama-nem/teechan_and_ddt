require 'dxopal'
require_remote './material_image.rb'

include DXOpal
include MaterialImages

module CharacterImagesDefiner
  def define_chrimg
    character_images={}
    character_images[:opening_otama] = \
     CharacterImage.new(name: "opening_otama", \
     filepath:"./game_images/character/pc/walking/04.png", \
     cut_start_left:0, cut_start_top:0, cut_width:300, cut_height:170, \
     cut_number_x:2, cut_number_y:1, cut_x_prior:true, switch_interval:50, \
     resize_factor_x:0.7, resize_factor_y:0.7)
    #character_images["..."]=...
    # ...

    return character_images
  end
end
