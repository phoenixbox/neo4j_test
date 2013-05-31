require 'rubygems'
require 'neography'
 
def create_hero(name)
  Neography::Node.create(name: name)
end
 
# Create heroes
wolverine = create_hero('Wolverine')
storm = create_hero('Storm')
ironman = create_hero('Ironman')
spiderman = create_hero('Spiderman')
hulk = create_hero('Hulk')
 
 
# Create relationships
wolverine.both(:friends) << storm
storm.both(:friends) << ironman
storm.both(:friends) << spiderman
ironman.both(:friends) << spiderman
ironman.both(:friends) << hulk
 
# Recommendation logic
def suggestions_for(node)
  node.incoming(:friends).
    order("breadth first").
    uniqueness("node global").
    filter("position.length() == 2;").
    depth(2).
    map{|n| n.name }.join(', ')
end
 
puts "HeroSpace Friend Recommendations"
puts "Wolverine should become friends with #{suggestions_for(wolverine)}"
puts "Spiderman should become friends with #{suggestions_for(spiderman)}"
 
 
# Degrees of Separation
 
puts ""
puts "Results"
wolverine.all_simple_paths_to(spiderman).incoming(:friends).depth(3).nodes.each do |path|
  puts "#{(path.size - 1)} degrees: " + path.map{|n| n.name}.join(" => friends => ")
end