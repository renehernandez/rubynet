# coding: utf-8

module Rubynet

  class Graph

    class Container

      def initialize(generated = nil)
        @objects = generated ? generated : {}
      end

      def method_missing(name, *args, &block)
        if @objects.class.instance_methods(true).include?(name)
          self.class.class_eval %Q|
            def #{name}(*args, &block)
              @objects.#{name}(*args, &block)
            end
          |
          send(name, *args, &block)
        end
      end

      def []=(key, value)
        attr = {}
        begin
          attr.merge!(value)
        rescue StandardError
          raise RubynetError, 'value argument must be a hash-like type'
        end

        @objects[key] = attr
      end

      def to_s
        format('Container: %{dict}', dict: @objects)
      end

    end

    attr_accessor :data, :nodes, :adj

    def initialize(input=nil, **attr)
      self.data = {}
      self.nodes = Container.new(self.node_factory)
      self.adj = Container.new(self.adj_factory)

      Conversion.make_graph(input, self) if input
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

    def node?(_node)
      self.nodes.key?(_node)
    end

    def to_s
      self.name
    end

    def add_node(_node, attr_dict=nil,**attr)
      if attr_dict.nil?
        attr_dict = attr
      else
        begin
          attr_dict.merge!(attr)
        rescue StandardError
          raise RubynetError, 'attr_dict argument must be a hash-like type'
        end
      end
      if self.node?(_node)
        self.nodes[_node].merge!(attr_dict)
      else
        self.adj[_node] = adj_factory
        self.nodes[_node] = attr_dict
      end
    end

    def add_nodes(_nodes, **attr)
      _nodes.each do |_node|
        if _node.respond_to?(:each)
          n, n_attr = _node
          if self.node?(n)
            self.nodes[n].merge!(attr).merge!(n_attr)
          else
            self.adj[n] = adj_factory
            self.nodes[n] = attr.merge(n_attr)
          end
        elsif self.node?(_node)
          self.nodes[_node].merge!(attr)
        else
          self.adj[_node] = adj_factory
          self.nodes[_node] = {}.merge!(attr)
        end
      end

    end


  end

end