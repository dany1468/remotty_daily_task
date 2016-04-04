require 'dotenv'

Dotenv.load

require './config/trello'
require 'thor'
require './daily_task_coach'

class Command < Thor
  desc 'remained_tasks', "notify all today's tasks"
  def remained_tasks
    DailyTaskCoach.new.notify_remaining_tasks
  end

  desc 'start_today', 'notify starting today message'
  def start_today
    DailyTaskCoach.new.encourage_organizing_tasks
  end

  desc 'finish_today', 'notify finishing today message'
  def finish_today
    DailyTaskCoach.new.encourage_reviewing_tasks
  end
end

Command.start(ARGV)
