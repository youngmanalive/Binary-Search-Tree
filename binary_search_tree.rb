require_relative 'node'

class BinarySearchTree
  attr_accessor :root

  def initialize
    @root = nil
  end

  def insert(value)
    @root = insert_node(@root, value)
  end

  def insert_node(tree_node, value)
    return Node.new(value) unless tree_node
    if value <= tree_node.value
      tree_node.left = insert_node(tree_node.left, value)
    elsif value > tree_node.value
      tree_node.right = insert_node(tree_node.right, value)
    end
    tree_node
  end

  def in_order(tree_node = @root)
    return [] unless tree_node
    in_order(tree_node.left) + [tree_node.value] + in_order(tree_node.right)
  end
end
