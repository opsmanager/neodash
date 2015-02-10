require 'xkcd'

class XkcdJob < Dashing::Job

  protected

  def do_execute
    title, image = XKCD.img.split(" : ")
    { title: title, image: image }
  end

end

