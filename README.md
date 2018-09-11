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

Our first node into the tree becomes our root.
