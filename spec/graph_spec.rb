# coding: utf-8
require 'spec_helper'

RSpec.describe Rubynet::Graph do

  describe '#initialize' do
    it 'creates an empty graph' do
      expect(Rubynet::Graph.new)
    end
  end

end