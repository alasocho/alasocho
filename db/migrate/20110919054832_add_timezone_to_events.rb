class AddTimezoneToEvents < ActiveRecord::Migration
  def change
    add_column :events, :timezone, :string

    say_with_time "Setting the timezone to America/Montevideo for all events" do
      # This is a reasonable default, since all the events in production are in
      # this timezone, except for a couple, which are test events :)
      Event.update_all(timezone: "America/Montevideo")
    end
  end
end
