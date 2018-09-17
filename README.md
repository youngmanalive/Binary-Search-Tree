## Binary Search Tree

We'll start with nodes. Each has a value, left, and right. Simple.
```ruby
class Node
  attr_reader :value
  attr_accessor :left, :right

  def initialize(value)
    @value = value
    @left = nil
    @right = nil
  end
end
```

Our nodes may have one or two children, or none! This will come in handy:
```ruby
def has_children?
  !!(@left || @right)
end
```
Okay so far, but we're missing something...

Enter Binary Search Tree. This pulls the node fam together.

```ruby
class BinarySearchTree
  attr_accessor :root

  def initialize(value = nil)
    @root = value ? Node.new(value) : nil
  end
end
```
We can start our tree off with a root node, or initialize it as nil.
`insert(value)` will handle our node insertion.

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

Peachy. But let's say we want to find a node? We'll start with our target value and compare a starting node. If the value is less than node, we'll move on to the node's left. If the value is greater, then we'll move onto the node's right. If our value is equal to the current node's value, bingo - we've found it. If we attempt to move to a nil node, we'll know our value is not in the tree.

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

Now the tricky part. Deleting nodes. There are several cases that need to be considered in order to remove the target node from the tree.
1. **The node has no children**
    - No children to promote, simply remove the target node
2. **The node has 1 child**
    - Promote the child to replace the target node
3. **The node has 2 children**
    - a) Find the maximum node of the target's left subtree.
    - b) If the maximum has a left child, promote it to replace the maximum
    - c) Replace target with maximum, reassign maximum's pointers to target pointers

Our deletion will consist of a few methods. Let's take a look.

```ruby
def delete(value)
  @root = delete_node(@root, value)
end

private

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
```
What's happening here? Let's walk through each method.

#### `delete(value)`
This kicks things off by starting at the root.

```ruby
# Assign our root the return value of delete_node
def delete(value)
  @root = delete_node(@root, value)
end
```
#### `delete_node(tree_node, value)`
We'll essentially reassign every node we traverse. Compare the value with the current node. If the node's value is not our target, assign the node's left or right child with a recursive call. Repeat until the target node is found, replace as necessary and return the replacement. Each evaluated node will be also be returned up the chain until we finally return the root.

```ruby
def delete_node(tree_node, value)
  # node does not exist, return nil
  return nil unless tree_node

  # begin evaluation
  case value <=> tree_node.value
  when -1
    # value is less than current node, recursive call on the node's left
    tree_node.left = delete_node(tree_node.left, value)
  when 0
    # we found the target, call replace_node to begin deletion steps
    tree_node = replace_node(tree_node)
  when 1
    # value is greater than current node, recursive call on the node's right
    tree_node.right = delete_node(tree_node.right, value)
  end

  # return the node
  tree_node
end
```

#### `replace_node(tree_node)`
This will handle the logic of actually replacing the node. If the node has children we have some extra steps to fulfill. Otherwise we return nil since there are no children needing promotion.

```ruby
def replace_node(tree_node)
  # if the node has children we'll enter the if block,
  # else the function returns nil -- no children to promote!
  if tree_node.has_children?

    # promote the left child if there is no right child
    return tree_node.left unless tree_node.right
    # promote the right child if there is no left child
    return tree_node.right unless tree_node.left

    # if we've made it this far, our tree_node has 2 children.
    # we need to replace the tree_node with the maximum node
    # on the left subtree. let's find the parent of this max.
    # if we know the parent, we know the max.
    max_parent = parent_of_max(tree_node.left)

    if max_parent.nil?
      # if the max_parent is nil, we know that our target node's left
      # does not have a right child, making it the max.
      # this becomes our replacement
      replacement = tree_node.left
    else
      # max_parent is defined - our replacement is max_parent's right
      replacement = max_parent.right

      # repoint max_parent's right to the replacement's left.
      max_parent.right = replacement.left

      # replacement's left becomes the target node's left
      replacement.left = tree_node.left
    end

    # now assign replacement's right to our target node's right.
    replacement.right = tree_node.right

    # all done, return the replacement
    replacement
  end
end
```
#### `parent_of_max(tree_node)`
Find the parent of the node with the highest value. The parent's right child will be the maximum. Using this allows us to yank the maximum out, and reassign the parent's right to the maximum's left. The maximum's left may be nil or a node itself. Either way, we are repairing the broken link after pulling the max out. If we were to call this method on a node without a right child, nil is returned, indicating that the node *is* the maximum, so the parent is unknown.

```ruby
def parent_of_max(tree_node)
  if tree_node.right && tree_node.right.right
    # if the node has a right, and that right also has a right.. recurse!
    parent_of_max(tree_node.right)
  elsif tree_node.right
    # when the current node's right child does not
    # have it's own right child, we've found the parent.
    tree_node
  end
  # if the node has no right, we skip the if block and nil is returned.
  # in our use cases, nil means the node we're inspecting is the max.
end
```

Whew. Now that we have the fundamentals down, let's move on to some other useful functions to evaluate our binary search tree.

#### Finding the depth
Return the current max depth of the tree.
```ruby
def depth(tree_node = @root)
  return 0 unless tree_node
  left = tree_node.left ? 1 + depth(tree_node.left) : 0
  right = tree_node.right ? 1 + depth(tree_node.right) : 0
  left > right ? left : right
end
```
#### Checking for balance
Determine if the tree's nodes are balanced.
```ruby
def is_balanced?(tree_node = @root)
  check_balance(tree_node) >= 0
end

private

def check_balance(tree_node)
  return 0 unless tree_node

  left = check_balance(tree_node.left)
  return -1 if left == -1

  right = check_balance(tree_node.right)
  return -1 if right == -1 || (left - right).abs > 1

  (left > right ? left : right) + 1
end
```

#### Maximum and minimum
Find the highest and lowest values
```ruby
def maximum(tree_node = @root)
  tree_node.right ? maximum(tree_node.right) : tree_node
end

def minimum(tree_node = @root)
  tree_node.left ? maximum(tree_node.left) : tree_node
end
```

#### Traversal methods
Return an array with values in the specified order
```ruby
def in_order(node = @root)
  return [] unless node
  in_order(node.left) + [node.value] + in_order(node.right)
end

def pre_order(node = @root)
  return [] unless node
  [node.value] + pre_order(node.left) + pre_order(node.right)
end

def post_order(node = @root)
  return [] unless node
  post_order(node.left) + post_order(node.right) + [node.value]
end
```
