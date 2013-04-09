module CalculableBy

  def calculable_by(status_key)

    define_singleton_method "wait_time_#{status_key}_in_seconds" do
        if status_key == :closed
          Issue.send(status_key).inject(0) do |time, issue|
            time + (Time.updated - issue.created_at) 
          end
        else
          Issue.send(status_key).inject(0) do |time, issue|
            time + (Time.now - issue.created_at) 
          end
        end
    end

    define_singleton_method "total_#{status_key}_issues" do
      Issue.send(status_key).size
    end

    define_singleton_method "average_wait_time_#{status_key}" do
      if "total_#{status_key}_issues" == 0
        0
      else
        (Issue.send("wait_time_#{status_key}_in_seconds")/60)/Issue.send("total_#{status_key}_issues")
      end
    end

  end

end

