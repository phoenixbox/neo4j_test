require 'rubygems'
require 'neography'
require 'pry'

@neo = Neography::Rest.new

def create_person(name)
  Neography::Node.create("name" => name)
end

def make_mutual_friends(node1, node2)
  @neo.create_relationship("friends", node1, node2)
  @neo.create_relationship("friends", node2, node1)
end

def suggestions_for(node)
  binding.pry
  node.incoming(:friends).
     order("breadth first").
     uniqueness("node global").
     filter("position.length() == 2;").
     depth(2).
     map{|n| n.name }.join(', ')
end

def degrees_of_separation(start_node, destination_node)
  paths =  @neo.get_paths(start_node, 
                          destination_node, 
                          {"type"=> "friends", "direction" => "in"},
                          depth=4, 
                          algorithm="shortestPath")
  paths.each do |p|
   p["names"] = p["nodes"].collect { |node| 
     @neo.get_node_properties(node, "name")["name"] }
  end
end

def get_relationships(node)
  @neo.get_relationship(node) 
end

def set_node_properties(node, property, value)
  @neo.set_node_properties(node, {"#{property}" => value})
end

def get_node(node)
  @neo.get_node(node)
end

def get_node_properties(node)
  @neo.get_node_properties(node)
end

shane     = create_person('Shane')
franklin  = create_person('Franklin')
kareem    = create_person('Kareem')
paul      = create_person('Paul')
elon      = create_person('Elon')

make_mutual_friends(shane, franklin)
make_mutual_friends(franklin, kareem)
make_mutual_friends(franklin, paul)
make_mutual_friends(paul, elon)
make_mutual_friends(kareem, elon)
puts "Shane should become friends with #{suggestions_for(shane)}"


node = get_node(shane)
set_node_properties(node, "weight", 300)

puts "The name of the node you were looking for is: #{node["data"]["name"]}"
puts "This nodes properties are: #{get_node_properties(node)}"

path_functions = %w[all_paths_to all_simple_paths_to all_shortest_paths_to path_to simple_path_to shortest_path_to]

puts "***************************************************************************"
shane.all_paths_to(elon).incoming(:friends).depth(3).nodes.each do |path|
  puts "#{(path.size - 1)} degrees: " + path.map{|n| n.name}.join(" => friends => ")
end

puts "***************************************************************************"
shane.all_simple_paths_to(elon).incoming(:friends).depth(3).nodes.each do |path|
  puts "#{(path.size - 1)} degrees: " + path.map{|n| n.name}.join(" => friends => ")
end

puts "***************************************************************************"
shane.all_shortest_paths_to(elon).incoming(:friends).depth(3).nodes.each do |path|
  puts "#{(path.size - 1)} degrees: " + path.map{|n| n.name}.join(" => friends => ")
end

puts "***************************************************************************"
shane.path_to(elon).incoming(:friends).depth(3).nodes.each do |path|
  puts "#{(path.size - 1)} degrees: " + path.map{|n| n.name}.join(" => friends => ")
end

puts "***************************************************************************"
shane.simple_path_to(elon).incoming(:friends).depth(3).nodes.each do |path|
  puts "#{(path.size - 1)} degrees: " + path.map{|n| n.name}.join(" => friends => ")
end

puts "***************************************************************************"
shane.shortest_path_to(elon).incoming(:friends).depth(3).nodes.each do |path|
  puts "#{(path.size - 1)} degrees: " + path.map{|n| n.name}.join(" => friends => ")
end