class CompaniesController < ApplicationController
  before_action :set_company, except: %i[index create new]

  def index
    @companies = Company.all

    if params[:name]
      @companies = @companies.where(['name like ?', '%' + params[:name] + '%'])
    end
  end

  def new
    @company = Company.new
  end

  def show
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      redirect_to companies_path, notice: "Company details saved successfully!"
    else
      flash[:alert] = @company.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
  end

  def update
    if @company.update(company_params)
      redirect_to companies_path, notice: "Company details updated successfully!"
    else
      flash[:alert] = @company.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    if @company.destroy
      flash[:notice] = 'The company has been deleted successfully!'
    else
      flash[:alert] = 'Error! unable to delete the company at the moment. Please try again later!'
    end

    redirect_to companies_path
  end

  private

  def company_params
    params.require(:company).permit(
      :name,
      :legal_name,
      :description,
      :zip_code,
      :phone,
      :email,
      :owner_id,
      :brand_color,
      services: []
    )
  end

  def set_company
    @company = Company.find_by(id: params[:id])
  end
end
