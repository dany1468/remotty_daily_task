require 'trello'
require './remotty'

class DailyTaskCoach
  def encourage_organizing_tasks
    notify! ['【今日のタスクを整理しよう :exclamation: 昨日の残件はこれだけだ。】', fetch_active_tasks_with_label]
  end

  def notify_remaining_tasks
    notify! ['【今日の残りタスクはこれだけだ、がんばろう :v:】', fetch_active_tasks_with_label]
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
  
  def fetch_active_tasks_with_label
    fetch_all_cards.reject {|card| done?(card) }.map {|card|
      if label_names = labels(card)
        "#{label_names.map {|label| "[#{label}]" }.join('')} #{card.name}"
      else
        card.name
      end
    }
  end

  def fetch_all_task_with_done_label
    fetch_all_cards.map {|card|
      task = "#{card.name}"
      label_icon = done?(card) ? ':ballot_box_with_check:' : ':white_medium_small_square:'

      "#{label_icon} #{task}"
    }
  end

  def labels(card)
    card.card_labels.map {|label| label['name'] }
  end

  def fetch_all_cards
    Trello::List.find(ENV['TRELLO_LIST_ID']).cards
  end

  def notifier
    @notifier ||= Remotty.new
  end
end
