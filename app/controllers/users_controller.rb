# frozen_string_literal: true

class UsersController < ApplicationController
  def statistics
    if current_user.nil?
      return respond_to do |format|
        format.html { redirect_to(users_url) }
        format.json { render(json: {}, status: :unauthorized) }
      end
    end

    end_date = Date.today + 1
    start_date = end_date.last_month

    end_date = Date.strptime(params[:end_date], '%m/%d/%Y') + 1 if params[:end_date].present?

    start_date = Date.strptime(params[:start_date], '%m/%d/%Y') if params[:start_date].present?

    @number_distinct_user = UserEvent.group(:identifier)
                                     .where('event_datetime BETWEEN ? AND ?', start_date, end_date)
                                     .select('identifier, count(identifier) as count')
                                     .order('COUNT(user_events.identifier) DESC')
                                     .first

    @number_login_user =  UserEvent.where.not(email: nil)
                                   .where('event_datetime BETWEEN ? AND ?', start_date, end_date)
                                   .select('email, count(email) as count')
                                   .group(:email)
                                   .order('COUNT(user_events.email) DESC')
                                   .first

    @most_visited_product = UserEvent.where(event_type: UserEvent.event_types[:product_view])
                                     .where('event_datetime BETWEEN ? AND ?', start_date, end_date)
                                     .select("extended_data -> 'name' as product_name")
                                     .each_with_object({}) do |element, count|
                                       count[element.product_name] = 0 if count[element.product_name].nil?
                                       count[element.product_name] += 1
                                     end
                                     .sort_by { |_k, v| v }
                                     .reverse
                                     .first

    @most_recorded_event = UserEvent.select('event_type, count(event_type) as count')
                                    .where('event_datetime BETWEEN ? AND ?', start_date, end_date)
                                    .group(:event_type)
                                    .order('COUNT(user_events.event_type) DESC')
                                    .first

    @user_events = UserEvent.all
    if params[:search].present?
      @user_events = @user_events.where('email like ? or identifier like ?',
                                        "%#{params[:search]}%", "%#{params[:search]}%")
    end

    @user_events = @user_events.where('event_datetime BETWEEN ? AND ?', start_date, end_date)
                               .order(event_datetime: :desc)
                               .paginate(page: params[:page], per_page: 20)
  end
end
