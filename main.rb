require 'rubygems'
require 'google/apis'
require 'google/apis/youtube_v3'
require 'json'

@service = Google::Apis::YoutubeV3::YouTubeService.new()
@service.key = YOUR_API_KEY

def search_channels(query)
  @service.list_searches('snippet', q: query, type: 'channel').items.each do |item|
    print_channel_info(get_channel_info(item.id.channel_id))
  end
end

def get_channel_info(channel_id)
  @service.list_channels('brandingSettings, id, snippet, statistics', id: channel_id).items.first
end

def print_channel_info(item)
  puts ("\nChannel Name: #{item.snippet.title} \n" + 
        "Subscriber Count: #{subscriber_count(item.statistics)} \n" +
        "Video Count: #{item.statistics.video_count} \n" +
        "Average View Count: #{item.statistics.view_count/item.statistics.video_count} \n" +
        "Channel Description: #{item.snippet.description.chomp} \n" +
        "Email: #{get_email_from_description(item.snippet.description)} \n\n")
end

def subscriber_count(statistics_info)
  unless statistics_info.hidden_subscriber_count
    statistics_info.subscriber_count
  else
    'Subscriber Count is hidden'
  end
end

def get_email_from_description(description)
  description.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b/i).join(', ')
end

def get_query_from_console
  puts "Enter keyword or phrase:"
  gets.chomp
end

search_channels(get_query_from_console)
