require_relative 'node'

class BinarySearchTree
  attr_accessor :root

  def initialize
    @root = nil
  end

  def insert(value)
    @root = insert_node(@root, value)
  end

  def delete(value)
    @root = delete_node(@root, value)
  end

  def find(value, tree_node = @root)
    return nil unless tree_node
    case value <=> tree_node.value
    when -1
      find(value, tree_node.left)
    when 0
      tree_node
    when 1
      find(value, tree_node.right)
    end
  end

  def maximum(tree_node = @root)
    return tree_node unless tree_node.right
    maximum(tree_node.right)
  end

  def in_order(node = @root)
    return [] unless node
    in_order(node.left) + [node.value] + in_order(node.right)
  end

  private

  def insert_node(tree_node, value)
    return Node.new(value) unless tree_node
    if value <= tree_node.value
      tree_node.left = insert_node(tree_node.left, value)
    elsif value > tree_node.value
      tree_node.right = insert_node(tree_node.right, value)
    end
    tree_node
  end

  def delete_node(tree_node, value)
    case value <=> tree_node.value
    when -1
      tree_node.left = delete_node(tree_node.left, value)
    when 0
      tree_node = replace_node(tree_node)
    when 1
      tree_node.right = delete_node(tree_node.right, value)
    end
    tree_node
  end

  def replace_node(tree_node)
    if tree_node.has_children?
      return tree_node.left unless tree_node.right
      return tree_node.right unless tree_node.left
      replacement = maximum(tree_node.left)

      if replacement.left && tree_node.left.right
        parent, child = tree_node.left, tree_node.left.right
        parent, child = parent.right, child.right while child.right
        parent.right = child.left
      end

      replacement.left = tree_node.left
      replacement.right = tree_node.right
      replacement
    end
  end
end

# parent = tree_node.left
# child = tree_node.left.right
#
# while child.right
#   parent = parent.right
#   child = child.right
# end

#############################
#             (5)           #
#            /   \          #
#          (3)   (7)        #
#         /  \      \       #
#      (1)   (4)    (9)     #
#     /   \            \    #
#   (0)   (2)          (10) #
#        /                  #
#      (1.5)                #
#############################