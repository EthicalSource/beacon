class ContactFormRateLimitValidator < ActiveModel::Validator

  def validate(record)
    return if messages_count(record) < max_general_contacts_per_day
    record.errors.add(:limit, "The limit of messages you can send has been reached.")
    record.errors
  end

  private

  def messages_count(record)
    ContactMessage.past_24_hours.for_ip(record.sender_ip).count
  end

  def max_general_contacts_per_day
    ENV.fetch('MAX_GENERAL_CONTACTS_PER_DAY').to_i
  end

end
