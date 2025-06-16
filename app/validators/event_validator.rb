class EventValidator < ActiveModel::Validator

  def validate(record)
    return true unless record.is_event?
    record.errors.add(:duration, "Duration must be entered.") if record.duration.nil?
    record.errors.add(:attendees, "Attendees must be selected.") if record.attendees.nil?
    record.errors.add(:frequency, "Frequency must be selected.") if record.frequency.nil?
    record.errors
  end

end
