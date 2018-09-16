require_relative 'node'

class BinarySearchTree
  attr_accessor :root

  def initialize(value = nil)
    @root = value ? Node.new(value) : nil
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

  def depth(tree_node = @root)
    return 0 unless tree_node
    left = tree_node.left ? 1 + depth(tree_node.left) : 0
    right = tree_node.right ? 1 + depth(tree_node.right) : 0
    left > right ? left : right
  end

  def is_balanced?(tree_node = @root)
    check_balance(tree_node) >= 0
  end

  def maximum(tree_node = @root)
    tree_node.right ? maximum(tree_node.right) : tree_node
  end

  def minimum(tree_node = @root)
    return tree_node unless tree_node.left
    minimum(tree_node.left)
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
    return nil unless tree_node
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

      max_parent = parent_of_max(tree_node.left)

      if max_parent.nil?
        replacement = tree_node.left
      else
        replacement = max_parent.right
        max_parent.right = replacement.left
        replacement.left = tree_node.left
      end

      replacement.right = tree_node.right
      replacement
    end
  end

  def parent_of_max(tree_node)
    if tree_node.right && tree_node.right.right
      parent_of_max(tree_node.right)
    elsif tree_node.right
      tree_node
    end
  end

  def check_balance(tree_node)
    return 0 unless tree_node

    left = check_balance(tree_node.left)
    return -1 if left == -1

    right = check_balance(tree_node.right)
    return -1 if right == -1 || (left - right).abs > 1

    (left > right ? left : right) + 1
  end
end
