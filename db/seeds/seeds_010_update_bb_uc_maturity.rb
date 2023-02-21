# frozen_string_literal: true

BuildingBlock.all.each do |building_block|
  building_block.maturity = 'DRAFT' if building_block.maturity == 'BETA'
  building_block.save!
end

UseCase.all.each do |use_case|
  use_case.maturity = 'DRAFT' if use_case.maturity == 'BETA'
  use_case.save!
end
