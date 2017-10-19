class TestWorker
  include Sidekiq::Worker

  def perform(*args)
    10.times do
      puts 'Test worker'
      sleep 1
    end
  end
end
