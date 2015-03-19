# coding: utf-8
require 'spec_helper'

RSpec.describe Rubynet::Graph do
  subject(:graph) { Rubynet::Graph.new }

  describe '#initialize' do
    let(:container) { Rubynet::Graph::Container.new}

    context 'with empty created graph' do

      it { expect(graph.data).to eql({}) }
      it { expect(graph.nodes).to eql(container) }
      it { expect(graph.adj).to eql(container) }
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
      it { expect(graph.nodes[:dummy]).to eql(graph.node_factory) }
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
      before { graph.add_nodes(1..3) }
      let(:node) { 'Hello world!' }
      let!(:length) { graph.nodes.size }
      before { graph.add_node(node, { name: node, size: node.size }) }

      it { expect(graph.nodes.size).to eql(length + 1) }
      it { expect(graph.nodes[2]).to eql(graph.node_factory) }
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
      before do
        nodes = list.map { |i| [i, { name: i.to_s }] }
        graph.add_nodes(nodes)
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

end