# coding: utf-8
require 'spec_helper'

RSpec.describe Rubynet::Graph do
  subject(:graph) { Rubynet::Graph.new }

  describe '#initialize' do

    context 'with empty created graph' do

      it { expect(graph.data).to eql({}) }
      it { expect(graph.nodes).to eql(graph.node_factory) }
      it { expect(graph.adj).to eql(graph.node_factory) }
      it { expect(graph.name).to eql('') }
      it { expect(graph.to_s).to eql('') }
    end

    context 'with some initial data' do
      subject(:graph) { Rubynet::Graph.new(size: 20, match: 200, value: '23') }

      it { expect(graph.data[:size]).to eql(20) }
      it { expect(graph.data[:match]).to eql(200) }
      it { expect(graph.data[:value]).to eql('23') }
      it { expect(graph.name).to eql('') }
      it { expect(graph.to_s).to eql('') }
    end

    context 'with name as part of data' do
      subject(:graph) { Rubynet::Graph.new(name: 'Great') }

      it { expect(graph.name).to eql('Great') }
      it { expect(graph.to_s).to eql('Great') }
    end

  end

  describe '#adj_factory' do
    it 'returns an empty hash' do
      expect(graph.adj_factory).to eql({})
    end
  end

  describe '#node_factory' do
    it 'returns an empty hash' do
      expect(graph.node_factory).to eql({})
    end
  end

  describe '#name' do
    it { expect(graph.name).to eql(graph.data.fetch(:data, ''))}
  end

  describe '#name=' do
    context 'when assigning a name' do
      before { graph.name = 'SuperGraph' }

      it { expect(graph.name).to eql('SuperGraph')}
    end
  end

  describe '#to_s' do
    it { expect(graph.to_s).to eql(graph.name) }
  end

  describe '#add_node' do
    let!(:size) { graph.nodes.size}

    context 'without attributes' do
      before { graph.add_node(:dummy)}

      it { expect(graph.node?(:dummy)).to be_truthy }
      it { expect(graph.nodes.size).to eql(size + 1) }
      it { expect(graph.nodes[:dummy]).to eql({}) }
    end

    context 'with attr_dict' do
      before { graph.add_node(243, { name: 'dummy', weight: 1 }) }

      it { expect(graph.node?(243)).to be_truthy }
      it { expect(graph.nodes.size).to eql(size + 1) }
      it { expect(graph.nodes[243]).to eql({weight: 1, name:'dummy'}) }
    end

    context 'with attr_dict and **attr' do
      before { graph.add_node(50, {name:'not so dummy', weight: 1},
                              name: 'dummy', weight: 10) }

      it { expect(graph.node?(50)).to be_truthy }
      it { expect(graph.nodes.size).to eql(size + 1) }
      it 'attr_dict has priority over **attr' do
        expect(graph.nodes[50]).to eql({weight: 1, name:'not so dummy'})
      end
    end

    context 'with existing nodes in graph' do
      subject(:graph) do
        graph = Rubynet::Graph.new
        graph.add_nodes(1..3)
        graph
      end

      let(:node) { 'Hello world!' }
      let!(:length) { graph.nodes.size }
      before { graph.add_node(node, { name: node, size: node.size }) }

      it { expect(graph.nodes.size).to eql(length + 1) }
      it { expect(graph.nodes[2]).to eql({ }) }
      it { expect(graph.nodes[node]).to eql({ name: node, size: node.size }) }
    end

  end

  describe '#add_nodes' do
    let(:list) { 1..5 }

    context 'without attributes' do
      before {graph.add_nodes(list)}

      it { expect(graph.nodes.size).to eql(list.size) }
      it { expect(graph.node?(20)).to be_falsey }
      it { expect(graph.nodes[4]).to eql(graph.node_factory) }
    end

    context 'with **attr' do
      before { graph.add_nodes(list, name:'we all are dummies', weigth:2,
                              height: 10) }

      it { expect(graph.nodes.size).to eql(list.size) }
      it { expect(graph.nodes[4]).to eql({name:'we all are dummies', weigth:2,
                                          height: 10}) }
      it { expect(graph.node?(3)).to be_truthy }
    end

    context 'with custom attributes and **attr(a.k.a common attributes)' do
      before do
        nodes = list.map { |i| [i, { name: i.to_s }] }
        common = { name: 'black', weight: 2.5 }
        graph.add_nodes(nodes, common)
      end

      it { expect(graph.nodes.size).to eql(list.size) }
      it { expect(graph.nodes[3]).to eql({ name: '3', weight: 2.5 }) }
    end

    context 'when adding new nodes, previous node attributes are not
            modified' do
      subject(:graph) do
        graph = Rubynet::Graph.new
        nodes = list.map { |i| [i, { name: i.to_s }] }
        graph.add_nodes(nodes)
        graph
      end

      before { graph.add_nodes(10..20, name: 'new name',
                               date: DateTime.new(2015,2,3)) }


      it { expect(graph.nodes.size).to eql(list.size + (10..20).size) }
      it { expect(graph.nodes[3]).to eql({ name: '3'}) }
      it { expect(graph.nodes[13]).to eql({ name: 'new name',
                                            date: DateTime.new(2015,2,3) }) }
    end

  end

  describe '#node?' do
    context 'when adding a single node' do
      before { graph.add_node(2) }

      it { expect(graph.node?(2)).to be_truthy }
      it { expect(graph.node?('2')).to be_falsey }

    end

    context 'when adding multiple nodes' do
      before { graph.add_nodes(5.times.map { |i| [i.to_s, name: 'dummy'] },
                               weight: 1)}

      it { expect(graph.node?('4')).to be_truthy }
      it { expect(graph.node?(10)).to be_falsey }
    end

  end

  describe '#nodes_size' do
    context 'with empty graph' do

      it { expect(graph.nodes_size).to eql(0) }
    end

    context 'when adding a node' do
      let!(:length) { graph.nodes_size }
      before { graph.add_node('yummy', weight: 10) }

      it { expect(graph.nodes_size).to eql(length + 1) }
    end

    context 'when adding multiple nodes' do
      let(:list) { 1..5 }
      let!(:length) { graph.nodes_size }
      before { graph.add_nodes(list, output: false) }

      it { expect(graph.nodes_size).to eql(length + list.size) }
    end

  end

  describe '#add_edge' do
    let!(:size) { graph.nodes_size }

    context 'with no attributes' do
      before { graph.add_edge(10, 'test') }

      it { expect(graph.nodes_size).to eql(size + 2) }
      it { expect(graph.node?(10)).to be_truthy }
      it { expect(graph.node?('test')).to be_truthy }
      it 'edge has the same information from both nodes' do
        expect(graph.adj[10]['test']).to eql({})
        expect(graph.adj['test'][10]).to eql({})
      end
    end

    context 'with attr_dict' do
      before { graph.add_edge(243, 'dummy', { name: 'dummy', weight: 1 }) }

      it { expect(graph.node?(243)).to be_truthy }
      it { expect(graph.node?('dummy')).to be_truthy }
      it { expect(graph.nodes_size).to eql(size + 2) }
      it { expect(graph.adj[243]).to eql({ 'dummy' => { name: 'dummy', weight: 1 } }) }
      it { expect(graph.adj['dummy']).to eql({ 243 => { name: 'dummy', weight: 1 } }) }
      it 'edge has the same information from both nodes' do
        expect(graph.adj[243]['dummy']).to eql({ weight: 1, name:'dummy' })
        expect(graph.adj['dummy'][243]).to eql({ weight: 1, name:'dummy' })
      end
    end

    context 'with attr_dict and **attr' do
      before { graph.add_edge(50, :rene, { name:'not so dummy', weight: 1 },
                              name: 'dummy', weight: 10) }

      it { expect(graph.node?(50)).to be_truthy }
      it { expect(graph.node?(:rene)).to be_truthy }
      it { expect(graph.nodes_size).to eql(size + 2) }
      it 'attr_dict has priority over **attr' do
        expect(graph.adj[50][:rene]).to eql({ weight: 1, name:'not so dummy' })
        expect(graph.adj[:rene][50]).to eql({ weight: 1, name:'not so dummy' })
      end
    end

    context 'with existing edges in graph' do
      subject(:graph) do
        graph = Rubynet::Graph.new
        graph.add_edges((1..3).map {|i| [i, i + 1]})
        graph
      end

      let(:u) { :hello }
      let(:v) { :world }
      let!(:length) { graph.nodes_size }
      before { graph.add_edge(u, v, { name: u.to_s + v.to_s,
                                      size: 10 }) }

      it { expect(graph.nodes_size).to eql(length + 2) }
      it { expect(graph.nodes[2]).to eql({}) }
      it 'edge has the same information from both nodes' do
        expect(graph.adj[u][v]).to eql({ name: u.to_s + v.to_s,
                                            size: 10 })
        expect(graph.adj[v][u]).to eql({ name: u.to_s + v.to_s,
                                         size: 10 })
      end
    end

    context 'when modifying adjacency list' do
      subject(:graph) do
        graph = Rubynet::Graph.new
        graph.add_edge(10, 20)
        graph
      end

      let!(:length) { graph.nodes_size }
      before { graph.add_edge(20, 30) }

      it { expect(graph.nodes_size).to eql(length + 1) }
      it { expect(graph.adj[10]).to eql({ 20 => {} })}
      it { expect(graph.adj[20]).to eql({ 10 => {}, 30 => {} })}
      it { expect(graph.adj[30]).to eql({ 20 => {} })}
    end


  end

  describe '#neighbors' do
    before { graph.add_edges([[1, 2], [2, 3], [1,5], [4, 6], [3, 1]])}

    it { expect(graph.neighbors(1)).to eql([2, 5, 3]) }

  end

end