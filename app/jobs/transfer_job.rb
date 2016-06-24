class TransferJob < ActiveJob::Base
  queue_as :default

  def perform(action, import_type, import_batch = nil)
    action_method = TransferJob.actions action
    raise "Invalid remote action #{action}!" unless action_method

    objects = CollectionSpaceObject.includes(:data_object)
      .where(type: import_type)
      .entries.select { |object|
      (import_batch.nil? or object.data_object.import_batch == import_batch) ? object : nil;
    }

    # TODO: add logging

    objects.each do |object|
      service = RemoteActionService.new(object)
      if service.remote_already_exists?
        service.send action_method if action_method == :remote_delete
      else
        service.send action_method if action_method == :remote_transfer
      end
    end
  end

  def self.actions(action)
    {
      "delete" => :remote_delete,
      "remote_delete" => :remote_delete,
      "transfer" => :remote_transfer,
      "remote_transfer" => :remote_transfer,
    }[action]
  end
end
