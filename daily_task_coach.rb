require 'trello'
require 'active_support/all'
require './remotty'

class DailyTaskCoach
  def encourage_organizing_tasks
    notify! ['【今日のタスクを整理しよう :exclamation: 昨日の残件はこれだけだ。】', fetch_active_tasks]
  end

  def notify_remaining_tasks
    notify! ['【今日の残りタスクはこれだけだ、がんばろう :v:】', fetch_active_tasks]
  end

  def encourage_reviewing_tasks
    notify! ['【一日お疲れ様。今日のタスクの消化を振り返ろう】', fetch_all_task_with_done_label]
  end

  private

  def done?(card)
    card.card_labels.any? {|label| label['name'] == 'done' }
  end
  
  def notify!(messages)
    notifier.post_message! messages.join("\n")
  end
  
  def fetch_active_tasks
    fetch_all_cards.reject {|card| done?(card) }.map(&:name)
  end

  def fetch_all_task_with_done_label
    fetch_all_cards.map {|card|
      task = "#{card.name}"
      done?(card) ? "[done] #{task}" : task
    }
  end

  def fetch_all_cards
    Trello::List.find(ENV['TRELLO_LIST_ID']).cards
  end

  def notifier
    @notifier ||= Remotty.new
  end
end