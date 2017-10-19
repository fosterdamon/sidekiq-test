class AnotherTestWorker < ApplicationJob
  queue_as :default

  def perform(*args)
    10.times do
      puts 'Another test worker - application job'
      sleep 1
    end
  end
end
