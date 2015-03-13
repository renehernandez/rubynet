# coding: utf-8

require 'spec_helper'

RSpec.describe Rubynet::Graph::Container do
  subject(:container) { Rubynet::Graph::Container.new}

  describe '#initialize' do

    context 'when creating container it just works' do

      it { expect(container).to eql(Rubynet::Graph::Container.new)}
    end

    context 'with missed method it defaults to wrapped @objects ivar' do

      it { expect(container.keys).to eql([]) }
      it { expect(container.values).to eql([]) }
    end

  end

  describe '#[]=' do

    context 'when assign a non hash-like type' do

      it { expect{ container[10] = 5 }.to raise_error(
                                              Rubynet::RubynetError) }
      it { expect{ container[10] = [:hello, 5, 'yum'] }.to raise_error(
                                                    Rubynet::RubynetError) }
    end

    context 'with valid data type' do
      it { expect{ container[:empty] = {} }.to_not raise_error }
      it { expect{ container[30] = {name:'bob'} }.to_not raise_error }
    end

  end

  describe '#to_s' do

    context 'with empty container' do

      it { expect(container.to_s).to eql(format('Container: %{d}', d: {}))}
    end

  end

end