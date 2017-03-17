def update_quality(items)

  def update_item_attributes(item, attribute, operation)
    update_quality = {
      "add" => {
        "quality" => lambda { item.quality +=1 },
        "sell_in" => lambda { item.sell_in +=1 }
      },
      "substract" => {
        "quality" => lambda { item.quality -=1 },
        "sell_in" => lambda { item.sell_in -=1 }
      }
    }
    update_quality[operation][attribute].call
  end

  def set_zero_quality(item)
    item.quality = 0
  end

=begin
  def define_path
    path = {
      "name" => {
        "Aged Brie" => { 
          lambda { compare_names }=> 
        }
      },
      "quality" =>,
      "sell_in" => 
    }
  end

  def define_path_2(item, sell_in, quality, name)
    update_item = {
      "true" => {  
        "less" => {
          "Aged" => lambda { update_item_attributes(item, "quality", "add")},
          "new_name" => lambda { update_item_attributes(item, "quality", "substract")},
          }
        }
        
      },
      "false" => {
      }
    }
    update_item[negative_sell_in(sell_in)][level_quality(quality)][group_name(name)].call
  end

=end
  def compare_names(name, previous_name)
    name.eql?(previous_name)
  end

  def negative_sell_in(item)
    item.sell_in < 0
  end

  def less_quality(item)
    item.quality < 50 
  end

  def eval_quality(item)
    if item.sell_in < 0
      if item.name != "Aged Brie"
        if item.name != 'Backstage passes to a TAFKAL80ETC concert'
          if item.quality > 0
            if item.name != 'Sulfuras, Hand of Ragnaros'
              update_item_attributes(item, "quality", "substract")
            end
          end
        else
	  set_zero_quality(item)
        end
      else
        if less_quality(item)
          update_item_attributes(item, "quality", "add")
        end
      end
    end
  end

  def a_different_name(item)
    if less_quality(item)
      update_item_attributes(item, "quality", "add")
      if item.name == 'Backstage passes to a TAFKAL80ETC concert'
        if item.sell_in < 11 
          if less_quality(item)
            update_item_attributes(item, "quality", "add")
          end
        end
        if item.sell_in < 6
          if less_quality(item)
            update_item_attributes(item, "quality", "add")
          end
        end
      end
    end
  end

  def compare_by_quality_and_name(item, attribute)
    choices = {
      "quality" => {
        true => lambda { compare_by_quality_and_name(item, "name") },
        false => lambda { false }
      },
      "name" => {
	false  =>  lambda { update_item_attributes(item, "quality", "substract")},
        true => lambda { false }
      }
    }
    choices[attribute][set_method_for_quality_or_name(item, attribute)].call
  end

  def set_method_for_quality_or_name(item, attribute)
    methods = {
      "quality" => lambda { item.quality > 0 },
      "name" => lambda {compare_names(item.name, "Sulfuras, Hand of Ragnaros") }
    }
    methods[attribute].call
  end

  items.each do |item|
    if item.name != 'Aged Brie' && item.name != 'Backstage passes to a TAFKAL80ETC concert'
      compare_by_quality_and_name(item, "quality")
    else
     a_different_name(item)
    end
    if item.name != 'Sulfuras, Hand of Ragnaros'
      update_item_attributes(item, "sell_in", "substract")
    end
    eval_quality(item)
  end
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

