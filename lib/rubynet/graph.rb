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
      data.fetch(:name, '')
    end

    def name=(name)
      data[:name] = name
    end

    def to_s
      name
    end

    def each(&block)
      nodes.each(&block)
    end

    def add_node(n, attr_dict=nil,**attr)
      if attr_dict.nil?
        attr_dict = attr
      else
        # begin
        #   attr_dict.merge(attr)
        # rescue StandardError
        #   raise RubynetError, 'attr_dict argument must be a hash-like type'
        # end
      end
      if node.include?(n)
        node[n].merge!(attr_dict)
      else
        adj[n] = {}
        node[n] = attr_dict
      end

    end
    def nodes(data = false)
      data ? @node.keys : @node.map {|k,v| [k, v]}
    end

  end

end

g = Rubynet::Graph.new(name:'yeah')
g.add_node(1, name:'1')
puts g
puts g.node[1]
g.add_node(1, name:'2')
puts g.node[1]