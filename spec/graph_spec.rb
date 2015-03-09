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

    context 'with no attributes' do
      before { graph.add_node(:dummy)}
      let(:container) { Rubynet::Graph::Container.new }

      it { expect(graph.node?(:dummy)).to be_truthy }
      it { expect(graph.nodes.size).to eql(size + 1) }
      it { expect(graph.nodes[:dummy]).to eql(graph.node_factory) }
    end

    context 'with attr_dict' do
      
    end

  end

  describe '#add_nodes' do

  end

  describe '#node?' do
    before { graph.add_node(2) }

    it { expect(graph.node?(2)).to be_truthy }
    it { expect(graph.node?('20')).to be_falsey }

  end

end