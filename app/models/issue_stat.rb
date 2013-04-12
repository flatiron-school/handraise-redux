class IssueStat < ActiveRecord::Base
  attr_accessible :issue_id, :status, :wait_time

  STATUS_MAP = {
    :closed => 0,
    :post_help => 1, 
    :assigned => 2, 
    :assignable => 3
  }

  ## Returns IssueStats by Status
  def self.closed
    IssueStat.where(:status => IssueStat::STATUS_MAP[:closed])
  end

  def self.post_help
    IssueStat.where(:status => IssueStat::STATUS_MAP[:post_help])
  end

  def self.assigned
    IssueStat.where(:status => IssueStat::STATUS_MAP[:assigned])
  end

  def self.assignable
    IssueStat.where(:status => IssueStat::STATUS_MAP[:assignable])
  end

  ## Calculates each issue_stat and saves it into database
  def calculate_issue_stat
    # stats are in minutes  
    if self.status == IssueStat::STATUS_MAP[:assignable]
      self.wait_time = (Time.now - self.created_at)/60
    else
      self.wait_time = (self.updated_at - self.created_at)/60
    end
    self.save
  end

  ## Metaprogramming issue stats for each status category
  def self.calculable_by(status_key)
    
    define_singleton_method "#{status_key}_issues_total_wait_time" do
        IssueStat.send(status_key).inject(0) do |time, issue_stat|
          time + issue_stat.wait_time
        end
    end  

    define_singleton_method "#{status_key}_issues_average_wait_time" do
      if IssueStat.send(status_key).count == 0
        0 
      else
        IssueStat.send("#{status_key}_issues_total_wait_time") / IssueStat.send(status_key).count 
      end
    end 

  end 

  calculable_by :closed
  calculable_by :post_help
  calculable_by :assigned
  calculable_by :assignable

  
  ## Reset issue_stats table
  def self.reset_stats  
    IssueStat.all.each do |stat|
      stat.destroy
    end
  end
  
end
