# coding: utf-8

module Rubynet

  class Graph

    attr_accessor :data, :nodes, :adj

    def initialize(**attr)
      self.data = {}
      self.nodes = self.node_factory
      self.adj = self.node_factory

      # Conversion.make_graph(input, self) if input
      self.data.merge!(attr)
    end

    def adj_factory
      {}
    end

    def node_factory
      {}
    end

    def name
      self.data.fetch(:name, '')
    end

    def name=(name)
      self.data[:name] = name
    end

    def to_s
      self.name
    end

    def node?(_node)
      self.nodes.key?(_node)
    end

    def nodes_size
      self.nodes.size
    end

    def add_node(_node, attr_dict=nil,**attr)
      if attr_dict.nil?
        attr_dict = attr
      else
        begin
          attr_dict.merge!(attr) {|_k, v1, _v2| v1}
        rescue StandardError
          raise RubynetError, 'attr_dict argument must be a hash-like type'
        end
      end
      create_or_update_node(_node, attr_dict)
    end

    def add_nodes(_nodes, **attr)
      _nodes.each do |_node|
        if _node.respond_to?(:each)
          n, n_attr = _node
          begin
            n_attr.merge!(attr) {|_k, v1, _v2| v1}
          rescue StandardError
            raise RubynetError, 'attr_dict argument must be a hash-like type'
          end
          create_or_update_node(n, n_attr)
        else
          create_or_update_node(_node, attr)
        end
      end

    end

    def remove_node(_node)
      return unless self.adj.key?(_node)

      self.nodes.delete(_node)

      self.adj.delete(_node).each_key do |key|
        self.adj[key].delete(_node)
      end

    end

    private

    def create_or_update_node(_node, attr)
      if self.node?(_node)
        self.nodes[_node].merge!(attr)
      else
        self.nodes[_node] = attr
        self.adj[_node] = self.adj_factory
      end
    end

  end

end