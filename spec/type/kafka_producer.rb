require "kafka"

module Serverspec
  module Type

    class KafkaProducer < Base
      
      def initialize(brokers)
        super("Kafka Producer #{brokers}")
        @brokers = brokers
        @valid = true
      end

      def valid?
        @valid = true
        begin
          kafka = Kafka.new([@brokers])
          producer = kafka.producer
          10.times do |i|
            producer.produce("test-message#{i}", topic: "test-topic")
          end
          producer.deliver_messages
        rescue => e
          @valid = false
          raise e
        ensure
          producer.shutdown
        end
        @valid
      end

    end

    def kafka_producer(brokers)
      KafkaProducer.new(brokers)
    end
  end
end

include Serverspec::Type
