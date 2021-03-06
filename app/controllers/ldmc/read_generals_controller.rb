require_dependency "ldmc/application_controller"

module Ldmc
  class ReadGeneralsController < ApplicationController
    before_action :load_subject, only: [:index, :show, :edit, :update, :new, :create, :destroy]
    before_action :set_read_general, only: [:show, :edit, :update]

    def all
      @read_generals = Subject.all.map {|s| s.read_general}.flatten
      @sorted_generals= @read_generals.sort {|a,b| a.read_ann.delete('P').to_i <=> b.read_ann.delete('P').to_i}
      
    end
    
    
    def show
    end

    def edit
    end

    def new
      @read_general = @subject.build_read_general
    end

    def create
      @read_general = @subject.build_read_general(read_general_params)

      respond_to do |format|
        if @read_general.save
          format.html { redirect_to [@subject, @read_general], notice: 'Read General was successfully created.' }
          format.json { render action: 'show', status: :created, location: @read_general }
        else
          format.html { render action: 'new' }
          format.json { render json: @read_general.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      
      respond_to do |format|
        @read_general.assign_attributes(read_general_params)
        @read_general.updated_by=current_user.id
        
        if @read_general.save
          format.html { redirect_to read_generals_path}
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @read_general.errors, status: :unprocessable_entity }
        end
      end
    end

    private
    def set_read_general
      @read_general = @subject.read_general
    end
    
    def load_subject
      @subject = Subject.find(params[:subject_id])
    end

    def read_general_params
      params.require(:read_general)
            .permit(
                    {lesion_dir: []},
                    :level_dir,
                    :level_flair,
                    :read_ann,
                    :indication,
                    :updated_by
                    )
    end
  end
end
