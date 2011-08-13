require "resque-retry"

class Job
  extend Resque::Plugins::Retry

  LAZY_ENVIRONMENTS = %w(development test)

  def self.inherited(subclass)
    subclass.attempt_retries
  end

  # Configure this job to attempt a number of retries (after a set delay).
  def self.attempt_retries(times=3, delay=60)
    @retry_limit = times
    @retry_delay = delay
  end

  # Add a job to the queue. If we're currently running in any of the
  # environments listed in +LAZY_ENVIRONMENTS+ then it automatically performs
  # the job.
  def self.enqueue(*args)
    if LAZY_ENVIRONMENTS.include? Rails.env
      Rails.logger.debug "Performing job instead of enqueuing: #{name}"
      perform(*args)
    else
      Resque.enqueue self, *args
    end
  end

  # Perform this job. In case of any errors, log them and re-raise.
  # This method delegates to the instance method +perform+, and you should
  # define that method on subclasses.
  def self.perform(*args)
    new.perform(*args)
  rescue Exception => exception
    Rails.logger.error "Job #{name} failed with: #{exception}"
    Rails.logger.error "  " + exception.backtrace.join("\n  ")
    raise
  end

  # Redefine this method and implement the job's logic here.
  def perform(*)
  end
end
