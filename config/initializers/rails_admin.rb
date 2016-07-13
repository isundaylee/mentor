RailsAdmin.config do |c|

  c.authenticate_with do
    authenticate_or_request_with_http_basic('Sign in to the admin portal. ') do |u, p|
      Rails.env.production? ?
        (u == ENV['ADMIN_USERNAME'] && p == ENV['ADMIN_PASSWORD']) :
        (u == 'admin' && p == 'password')
    end
  end

  c.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
  end

  c.excluded_models << "Participation"
  c.excluded_models << "Segment"
end
