# frozen_string_literal: true

module ToastHelper
  def flash_class(type)
    base_class = 'absolute top-4 right-2 w-72 shadow-xl alert z-10 opacity-90 pointer-events-none'
    type_class = {
      notice: 'alert-success',
      alert: 'alert-error'
    }

    "#{base_class} #{type_class[type.to_sym]}"
  end
end
