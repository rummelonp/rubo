# coding: utf-8

require 'rubo/adaptable'
require 'rubo/message'
require 'twitter'

module Rubo
  module Adapters
    # @private
    class Twitter
      include Adaptable

      def initialize(robot)
        super
        @options = {
          consumer_key:        ENV['RUBO_TWITTER_KEY'],
          consumer_secret:     ENV['RUBO_TWITTER_SECRET'],
          access_token:        ENV['RUBO_TWITTER_TOKEN'],
          access_token_secret: ENV['RUBO_TWITTER_TOKEN_SECRET'],
        }
      end

      def send(envelope, *strings)
        robot.logger.info "Twitter: Sending strings to \"#{envelope.user.name}\""
        strings.each do |str|
          tweets_text = str.split("\n")
          tweets_text.each do |tweet_text|
            @bot.send(envelope.user.name, tweet_text, envelope.message.id)
          end
        end
      end

      def reply(envelope, *strings)
        robot.logger.info 'Twitter: Replying'
        send(envelope, *strings)
      end

      def run
        unless @options.values.all?
          robot.logger.error "The environment variable " +
            "`RUBO_TWITTER_KEY`, " +
            "`RUBO_TWITTER_SECRET`, " +
            "`RUBO_TWITTER_TOKEN`, " +
            "`RUBO_TWITTER_TOKEN_SECRET` " +
            "is required"
          exit 1
        end

        @bot = TwitterStreaming.new(@options)
        @bot.once(:connected) do
          emit(:connected)
          robot.logger.info 'Twitter: Connected'
        end
        @bot.connect do |status|
          robot.logger.info "Twitter: Received \"#{status.text}\" " +
            "from \"#{status.user.screen_name}\""
          user = robot.brain.user_for_id(status.user.id.to_s,
            name: status.user.screen_name,
          )
          receive(TextMessage.new(user, status.text, status.id.to_s))
        end
      rescue Interrupt
        robot.shutdown
      end

      def close
        robot.logger.info "Twitter: Disconnecting"
        @bot.disconnect
      end
    end

    register :twitter, Twitter

    # @private
    class TwitterStreaming
      include EventEmitter

      def initialize(options = {})
        @rest_client = ::Twitter::REST::Client.new(options)
        @streaming_client = ::Twitter::Streaming::Client.new(options)
      end

      def connect(&block)
        @streaming_thread = Thread.new do
          @streaming_client.user do |status|
            emit(:connected)
            if status.is_a?(::Twitter::Tweet)
              block.call(status)
            end
          end
        end
        @streaming_thread.run
        @streaming_thread.join
      end

      def disconnect
        @streaming_thread.kill if @streaming_thread
      end

      def send(screen_name, text, in_reply_to_status_id)
        status = "@#{screen_name} #{text}"
        @rest_client.update(status, in_reply_to_status_id: in_reply_to_status_id)
      end
    end
  end
end
