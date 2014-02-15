# coding: utf-8

require 'spec_helper'

describe Rubo::User do
  it 'should set id and attributes' do
    user = Rubo::User.new(
      'Fake User',
      name: 'fake',
      room: 'chat@room.jabber',
      type: :groupchat,
    )
    expect(user.id).to eql('Fake User')
    expect(user.name).to eql('fake')
    expect(user.room).to eql('chat@room.jabber')
    expect(user.type).to eql(:groupchat)
  end

  it 'should set name from id if no name is given' do
    user = Rubo::User.new(
      'Fake User',
      room: 'chat@room.jabber',
      type: :groupchat,
    )
    expect(user.name).to eql(user.id)
  end
end
