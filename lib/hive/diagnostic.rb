require 'hive'
require 'device_api/android'

module Hive
	class Diagnostic
		attr_accessor :config, :last_run, :message, :device

		def initialize(config, serial)
			@config = config
			@serial = serial
			@device = self.device
		end

		def should_run?
			true
		end

		def run
			Hive.logger.info("Trying to run diagnostic '#{self.class}'")
			if should_run?	
				result = diagnose 
				result = repair(result) if result.failed?
				@last_run = result
			end
			@last_run	
		end

		def pass(message= {}, data = {})
			Hive.logger.info(message)
			require 'hive/results'
			Hive::Results.new("pass", message, data )
		end

		def fail(message ={}, data = {})
			Hive.logger.info(message)
			require 'hive/results'
			Hive::Results.new("fail", message, data)
		end
	end
end
