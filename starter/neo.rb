require 'rubygems'
require 'neography'
require 'pry'

@neo = Neography::Rest.new

def create_person(name)
  @neo.create_node("name" => name)
end

def make_mutual_friends(node1, node2)
  @neo.create_relationship("friends", node1, node2)
  @neo.create_relationship("friends", node2, node1)
end

def suggestions_for(node)
  @neo.traverse(node,
                "nodes", 
                {"order" => "breadth first", 
                 "uniqueness" => "node global", 
                 "relationships" => {"type"=> "friends", 
                                     "direction" => "in"}, 
                 "return filter" => {"language" => "javascript",
                                     "body" => "position.length() == 2;"},
                 "depth" => 2}).map{|n| n["data"]["name"]}.join(', ')
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
