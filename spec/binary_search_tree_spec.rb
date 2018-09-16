require 'rspec'
require 'binary_search_tree'
require 'node'

describe Node do
  let(:node) { Node.new(10) }

  it "initializes with a value" do
    expect(node.value).to eq(10)
  end

  it "has a left and right that can be assigned" do
    node.left = 8
    node.right = 12
    expect(node.left).to eq(8)
    expect(node.right).to eq(12)
  end

  describe "#has_children?" do
    it "returns true if node has children" do
      node.left = 8
      expect(node.has_children?).to eq(true)
    end

    it "returns false if none" do
      expect(node.has_children?).to eq(false)
    end
  end
end

describe BinarySearchTree do
  let(:tree) { BinarySearchTree.new }
  let(:filled_tree) do
     bst = BinarySearchTree.new
     vals = [8, 6, 10, 1, 7, 13, 0, 5, 14, 3, 2, 4]
     vals.each { |val| bst.insert(val) }
     bst
  end

  #  filled tree       8
  #                  /  \
  #                6     10
  #              /  \     \
  #            1     7    13
  #          /  \           \
  #        0     5          14
  #            /
  #           3
  #         /  \
  #        2    4

  describe "#initialize" do
    it "can take a value to set the root" do
      expect(BinarySearchTree.new(5).root.value).to eq(5)
    end

    it "defaults the root to nil if no value is given" do
      expect(tree.root).to be_nil
    end
  end

  describe "#insert" do
    it "places nodes in the correct location" do
      [4, 2, 5, 1, 3, 6].each { |val| tree.insert(val) }

      #           4
      #         /  \
      #       2     5
      #     /  \     \
      #   1     3     6

      expect(tree.root.value).to eq(4)
      expect(tree.root.left.value).to eq(2)
      expect(tree.root.left.left.value).to eq(1)
      expect(tree.root.left.right.value).to eq(3)
      expect(tree.root.right.value).to eq(5)
      expect(tree.root.right.right.value).to eq(6)
    end
  end

  describe "#find" do
    it "returns nil if node does not exit in tree" do
      expect(filled_tree.find(1.5)).to eq(nil)
    end

    it "returns the node if found" do
      node = filled_tree.find(5)
      expect(node).to be_instance_of(Node)
      expect(node.value).to eq(5)
    end
  end

  describe "#delete" do
    it "returns nil if node does not exsit in tree" do
      expect(tree.delete(50)).to eq(nil)
    end

    it "removes a node without children" do
      tree.insert(1)
      tree.delete(1)
      expect(tree.root).to be_nil

      filled_tree.delete(7)
      expect(filled_tree.root.left.right).to be_nil

      filled_tree.delete(2)
      expect(filled_tree.root.left.left.right.left.left).to be_nil

      filled_tree.delete(14)
      expect(filled_tree.root.right.right)
    end

    it "removes a node with one child and promotes the child" do
      filled_tree.delete(13)
      expect(filled_tree.root.right.right.value).to eq(14)

      filled_tree.delete(5)
      expect(filled_tree.root.left.left.right.value).to eq(3)
    end

    context "if node has two children" do
      it "replaces the node with max of the node's left subtree" do
        filled_tree.delete(6)
        expect(filled_tree.root.left.value).to eq(5)
        expect(filled_tree.root.left.left.value).to eq(1)
        expect(filled_tree.root.left.right.value).to eq(7)
      end

      it "handles child promotion if max has children" do
        filled_tree.delete(6)
        expect(filled_tree.root.left.left.right.value).to eq(3)
        expect(filled_tree.root.left.left.right.left.value).to eq(2)
        expect(filled_tree.root.left.left.right.right.value).to eq(4)
      end
    end

    context "more tests" do
      it "passes all test cases" do
        vals = [15, 13, 17, 11, 14, 19, 3, 12, 25,
                1, 5, 22, 28, 0, 9, 23, 7, 6, 8]
        vals.each { |val| tree.insert(val) }

        #                            15
        #                          /   \
        #                        13    17
        #                       /  \    \
        #                     11   14    19
        #                    /  \         \
        #                   3   12        25
        #                 /  \           /  \
        #                1    5        22   28
        #               /      \        \
        #              0        9       23
        #                      /
        #                     7
        #                   /  \
        #                  6    8
        #

        tree.delete(12)
        expect(tree.root.left.left.value).to eq(11)
        expect(tree.root.left.left.right).to be_nil

        tree.delete(13)
        expect(tree.root.left.value).to eq(11)
        expect(tree.root.left.right.value).to eq(14)

        tree.delete(11)
        expect(tree.root.left.value).to eq(9)
        expect(tree.root.left.right.value).to eq(14)
        expect(tree.root.left.left.right.right.value).to eq(7)
        expect(tree.root.left.left.right.right.right.value).to eq(8)
        expect(tree.root.left.left.right.right.left.value).to eq(6)

        tree.delete(15)
        expect(tree.root.value).to eq(14)
        expect(tree.root.left.value).to eq(9)
        expect(tree.root.left.right).to be_nil
        expect(tree.root.right.value).to eq(17)

        tree.delete(25)
        expect(tree.root.right.right.right.value).to eq(23)
        expect(tree.root.right.right.right.left.value).to eq(22)
        expect(tree.root.right.right.right.left.right).to be_nil

        # in_order = [0, 1, 3, 5, 6, 7, 8, 9, 14, 15, 17]
        # expect(tree.in_order).to eq(in_order)
      end
    end
  end

  describe "#maximum" do
    it "finds the highest valued node in the tree" do
      expect(filled_tree.maximum.value).to eq(14)
    end
  end

  describe "#minimum" do
    it "finds the lowest valued node in the tree" do
      expect(filled_tree.minimum.value).to eq(0)
    end
  end

  describe "#depth" do
    it "returns the depth count of the tree or input node" do
      expect(filled_tree.depth).to eq(5)
      expect(filled_tree.depth(filled_tree.root.right)).to eq(2)
    end
  end

  describe "#is_balnaced?" do
    it "returns false if the tree is unbalanced" do
      expect(filled_tree.is_balanced?).to eq(false)
    end

    it "returns true if the all nodes are balanced" do
      [4, 2, 5, 1, 3, 6].each { |val| tree.insert(val) }
      expect(tree.is_balanced?).to eq(true)
    end
  end

  describe "#in_order" do
    it "returns an array of all nodes in ascending order" do
      result = [0, 1, 2, 3, 4, 5, 6, 7, 8, 10, 13, 14]
      expect(filled_tree.in_order).to eq(result)
    end
  end
end
