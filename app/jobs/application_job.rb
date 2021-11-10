class ApplicationJob < ActiveJob::Base
  self.queue_adapter = :sucker_punch
end
