class AnotherTestWorker
  include Sidekiq::Worker

  def perform(*args)
    10.times do
      puts 'Another test worker'
      sleep 1
    end
  end
end
