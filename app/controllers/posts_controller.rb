class PostsController < ApplicationController

  def distance_of_time_in_words(time_now, post_created_at)
    time_now - post_created_at
  end
end
