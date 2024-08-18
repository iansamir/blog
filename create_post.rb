require 'date'

def ensure_posts_directory_exists
  Dir.mkdir('posts') unless Dir.exist?('posts')
end

def find_latest_blog
  max_blog_num = 0
  Dir.glob('posts/blog*.html').each do |filename|
    match = filename.match(/blog(\d+)\.html/)
    max_blog_num = [max_blog_num, match[1].to_i].max if match
  end
  max_blog_num
end

def create_new_blog(blog_num, title)
  new_blog_filename = "posts/blog#{blog_num}.html"
  date_str = Date.today.strftime("%b. %d, %Y")
  content = <<~HTML
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>#{title}</title>
        <link rel="icon" href="../images/icon.png" type="image/png">
        <style>
            .text {
                margin-left: 10vw;
                margin-top: 100px;
                width: 50vw;
                font-family: Verdana, Geneva, Tahoma, sans-serif;
            }
            @media (max-width: 600px) {
                .text {
                    width: 70vw;
                }
            }
        </style>
    </head>
    <body>
        <div class="text">
            <a href="../index.html">Home</a>
            <br /><br />
            #{title}
            <br />
            #{date_str}
            <br />
            <hr><br />
            Content goes here.
            <br /><br />
            <!-- Add your points or content here -->
        </div>
    </body>
    </html>
  HTML
  File.write(new_blog_filename, content)
  new_blog_filename
end

def update_index_html(new_blog_filename, title)
  index_file = 'index.html'
  new_entry = "        \\ --- <a href=\"#{new_blog_filename}\">#{title}</a><br />\n"
  
  lines = File.readlines(index_file)
  insert_position = lines.size - 3  # Adjust if needed
  lines.insert(insert_position, new_entry)
  File.write(index_file, lines.join)
end

if __FILE__ == $0
  ensure_posts_directory_exists

  if ARGV.empty?
    puts "Please provide the title for the new blog post."
    exit
  end

  title = ARGV.join(" ")  # Joins all arguments into a single string, assuming the title may contain spaces
  latest_blog_num = find_latest_blog
  new_blog_num = latest_blog_num + 1
  new_blog_filename = create_new_blog(new_blog_num, title)
  update_index_html(new_blog_filename, title)
  puts "Created '#{new_blog_filename}' and updated 'index.html' with title '#{title}'"
end

  