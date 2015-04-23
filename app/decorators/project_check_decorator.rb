class ProjectCheckDecorator < Draper::Decorator
  delegate :id

  def project_name
    object.project.name
  end

  def last_check_date
    if object.last_check_date.present?
      h.l object.last_check_date
    else
      "not checked yet"
    end
  end

  def css_date_class
    "warning" if object.last_check_date.nil?
  end

  def css_disabled_state
    '<i class="glyphicon glyphicon-time"></i>'
  end
end
