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
      { }
    end

    def node_factory
      { }
    end

    def edge_factory
      { }
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

    def edge?(u, v)
      self.adj.key?(u) && self.adj[u].key?(v)
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
      if self.node?(_node)
        self.nodes[_node].merge!(attr_dict)
      else
        self.nodes[_node] = attr_dict
        self.adj[_node] = self.adj_factory
      end
    end

    def add_nodes(_nodes, **attr)
      unless _nodes.respond_to?(:each)
        raise RubynetError, '_nodes argument must respond to container each
                            method'
      end
      _nodes.each do |_node|
        if _node.respond_to?(:each)
          n, n_attr = _node
          add_node(n, n_attr, attr)
        else
          add_node(_node, attr)
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

    def remove_nodes(_nodes)
      unless _nodes.respond_to?(:each)
        raise RubynetError, '_nodes argument must respond to container each
                            method'
      end

      _nodes.each {|_node| self.remove_node(_node) }
    end

    def add_edge(u, v, attr_dict = nil, **attr)
      if attr_dict.nil?
        attr_dict = attr
      else
        begin
          attr_dict.merge!(attr) {|_k, v1, _v2| v1}
        rescue StandardError
          raise RubynetError, 'attr_dict argument must be a hash-like type'
        end
      end

      unless self.nodes.key?(u)
        self.nodes[u] = { }
        self.adj[u] = self.adj_factory
      end
      unless self.nodes.key?(v)
        self.nodes[v] = { }
        self.adj[v] = self.adj_factory
      end

      e_attr = self.adj[u].fetch(v, self.edge_factory).merge(attr_dict)
      self.adj[u][v] = self.adj[v][u] = e_attr
    end

    def add_edges(_edges, **attr)
      unless _edges.respond_to?(:each)
        raise RubynetError, '_edges argument must respond to container each
                            method'
      end

      _edges.each do |_edge|
        case _edge.size
        when 2
          u, v = _edge
          self.add_edge(u, v, attr)
        when 3
          u, v, e_attr = _edge
          self.add_edge(u, v, e_attr, attr)
        else
          raise RubynetError, format('Edge tuple %(e) must be a 2-tuple or
                                    3-tuple', e: _edge)
        end
      end
    end

    def remove_edge(u, v)
      edge = self.adj[u].delete(v)
      edge &&= self.adj[v].delete(u) if u != v
      unless edge
        raise RubynetError, format('The edge <{u},{v}> is not in the graph',
                                   u: u, v: v)
      end
    end

    def remove_edges(_edges)
      unless _edges.respond_to?(:each)
        raise RubynetError, '_edges argument must respond to container each
                            method'
      end
      _edges.each { |_edge| self.remove_edge(*_edge)}
    end

  end

end