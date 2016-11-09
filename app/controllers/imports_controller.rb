class ImportsController < ApplicationController

  def new
    # form
  end

  def create
    file = params[:file]

    if file.respond_to? :path
      file      = file.path
      batch     = params[:batch]
      converter = params[:converter]
      profile   = params[:profile]

      ::SmarterCSV.process(file, {
          chunk_size: 100,
          convert_values_to_numeric: false,
        }.merge(Rails.application.config.csv_parser_options)) do |chunk|
        ImportJob.perform_later(file, batch, converter, profile, chunk)
      end
      flash[:notice] = "Background import job running. Check back periodically for results."
      redirect_to procedures_path
    else
      flash[:error] = "There was an error processing the uploaded file."
      redirect_to import_path
    end
  end

end
