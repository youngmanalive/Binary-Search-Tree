## Binary Search Tree

We'll start with nodes. Each has a value, left, and right. Simple.
```ruby
class Node
  attr_accessor :value, :left, :right

  def initialize(value)
    @value = value
    @left = nil
    @right = nil
  end
end
```

Our nodes may have one or two children, or none!
Okay so far, but we're missing something...

Enter Binary Search Tree. This pulls the node fam together. Now the nodes can finally have relationships and children.


```ruby
class BinarySearchTree
  attr_accessor :root

  def initialize
    @root = nil
  end
end
```

Our first node into the tree becomes our root. We'll need a way to handle our node insertion. `insert(value)` will start the process.

```ruby
# Assign our root to the return value of insert_node(tree_node, value)
def insert(value)
  @root = insert_node(@root, value)
end

private

def insert_node(tree_node, value)

  # return our new node if we find an empty spot
  return Node.new(value) unless tree_node

  if value <= tree_node.value
    # Our value is less than or equal to the current node
    # so we'll recurse on the node's left
    tree_node.left = insert_node(tree_node.left, value)
  elsif value > tree_node.value
    # Our value is greater than the current node
    # so we'll recurse on the node's right
    tree_node.right = insert_node(tree_node.right, value)
  end

  # return the current node being evaluated
  tree_node
end
```

Peachy. But let's say we want to find a node? We'll start with our target value and compare a starting node. If the value is less than node, we'll move on to the node's left. If the value is greater, than we'll move onto the node's right. If our value is equal to the node, bingo - we've found it. If we attempt to move to a nil node, we'll know our value is not in the tree.

```ruby
def find(value, tree_node = @root)
  # Node does not exist
  return nil unless tree_node

  case value <=> tree_node.value
  when -1
    # Value is less than node, recurse on left
    find(value, tree_node.left)
  when 0
    # Found it!
    tree_node
  when 1
    # Value is greater than node, recurse on right
    find(value, tree_node.right)
  end
end
```
