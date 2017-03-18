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

  def compare_names(name, previous_name)
    name.eql?(previous_name)
  end

  def item_quality_and_not_sulfuras_item(item)
    item.quality > 0 && item.name != 'Sulfuras, Hand of Ragnaros'
  end

  def not_aged_brie_name(item)
    if not compare_names(item.name,'Backstage passes to a TAFKAL80ETC concert')
      update_item_attributes(item, "quality", "substract") if item_quality_and_not_sulfuras_item(item)
    else
      set_zero_quality(item)
    end
  end

  def update_item_quality_if_below_fifty(item)
    update_item_attributes(item, "quality", "add") if  set_method_for_quality_name_or_sell_in(item, "quality", 50)
  end

  def eval_quality(item)
    if set_method_for_quality_name_or_sell_in(item, "sell_in",  0)
      !compare_names(item.name, "Aged Brie") ? not_aged_brie_name(item) : update_item_quality_if_below_fifty(item)
    end
  end

  def add_from_item_quality(item, value)
    if item.sell_in < value
      update_item_attributes(item, "quality", "add") if item.quality < 50
    end
  end

  def set_method_for_quality_name_or_sell_in(item, attribute, value)
    methods = {
      "quality" => lambda { item.quality < value },
      "name" => lambda { compare_names(item.name, value) },
      "sell_in" => lambda { item.sell_in < value }
    }
    methods[attribute].call
  end

  def compare_by_quality_name_and_sell_in(item, attribute, value)
    choices = {
      "quality" => {
        true => lambda { update_item_attributes(item, "quality", "add")
                         compare_by_quality_name_and_sell_in(item, "name", 'Backstage passes to a TAFKAL80ETC concert')
                       },
        false => lambda { false }
      },
      "name" => {
        true => lambda { [11, 6].each { |value| add_from_item_quality(item, value) }},
        false => lambda { false }
      }
    }
    choices[attribute][set_method_for_quality_name_or_sell_in(item, attribute, value)].call
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

  def it_is_a_different_name(item)
    !compare_names(item.name, 'Aged Brie') && !compare_names(item.name, 'Backstage passes to a TAFKAL80ETC concert')
  end

  items.each do |item|
    it_is_a_different_name(item) ? compare_by_quality_and_name(item, "quality") : compare_by_quality_name_and_sell_in(item, "quality", 50)
    update_item_attributes(item, "sell_in", "substract") if not compare_names(item.name,'Sulfuras, Hand of Ragnaros')
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

