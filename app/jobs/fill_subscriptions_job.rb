class FillSubscriptionsJob < ActiveJob::Base
  queue_as :default

  def perform
    FillSubscriptions.call!
  end
end
