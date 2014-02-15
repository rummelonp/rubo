# coding: utf-8

require 'spec_helper'

describe Rubo::Brain do
  let(:brain) do
    Rubo::Brain.new(Rubo::Robot.new(:null))
  end

  it 'should be saved when closed' do
    saved = false
    listner = ->(data) do
      saved = true
      expect(data.abc).to eql(1)
    end
    expect(listner).to receive(:call).and_call_original
    brain.on(:save, &listner)
    brain.data.abc = 1
    brain.close
    expect(saved).to be_true
  end

  it 'should be closed' do
    closed = false
    listner = -> do
      closed = true
    end
    expect(listner).to receive(:call).and_call_original
    brain.on(:close, &listner)
    brain.close
    expect(closed).to be_true
  end
end
