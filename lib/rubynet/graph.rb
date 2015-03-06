# coding: utf-8

module Rubynet

  class Graph
    include Enumerable

    attr_accessor :data, :node, :adj

    def initialize(input=nil, **attr)
      self.data = {}
      self.node = {}
      self.adj = {}

      self.data.merge!(attr)
    end

    def name
      self.data.fetch(:name, '')
    end

    def name=(name)
      self.data[:name] = name
    end

    def [](n)
      self.adj[n]
    end

    def size
      self.node.size
    end

    def to_s
      self.name
    end

    def each(&block)
      self.node.keys.each(&block)
    end

    def each_pair(&block)
      self.node.each(&block)
    end

    def nodes(data = false)
      data ? self.node.to_a : self.node.keys
    end

    def add_node(_node, attr_dict=nil,**attr)
      if attr_dict.nil?
        attr_dict = attr
      else
        begin
          attr_dict.merge(attr)
        rescue StandardError
          raise RubynetError, 'attr_dict argument must be a hash-like type'
        end
      end
      if self.node.include?(_node)
        self.node[_node].merge!(attr_dict)
      else
        self.adj[_node] = {}
        self.node[_node] = attr_dict
      end
    end

    def add_nodes(_nodes, **attr)
      _nodes.each do |_node|
        if _node.respond_to?(:each)
          n, n_attr = _node[]
          if self.node.key?(n)
            self.node[n].merge!(attr).merge!(n_attr)
          else
            self.adj[n] = { }
            self.node[n] = attr.merge(n_attr)
          end
        elsif self.node.key? _node
          self.node[_node].merge!(attr)
        else
          self.adj[_node] = {}
          self.node[_node] = {}.merge!(attr)
        end
      end

    end


  end

end