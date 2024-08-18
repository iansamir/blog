def delete_blog_post(blog_filename)
    # Construct the full path with the 'posts' directory
    blog_path = File.join('posts', blog_filename)
    File.delete(blog_path) if File.exist?(blog_path)
  end
  
  def update_index_html(blog_filename)
    index_file = 'index.html'
    updated_lines = []
  
    # Construct the path as it would appear in the HTML link
    blog_link_path = File.join('posts', blog_filename)
    
    File.open(index_file, 'r') do |file|
      file.each_line do |line|
        updated_lines << line unless line.include?(blog_link_path)
      end
    end
  
    File.open(index_file, 'w') do |file|
      updated_lines.each { |line| file.write(line) }
    end
  end
  
  if __FILE__ == $0
    if ARGV.empty?
      puts "Please provide the filename of the blog post to delete."
      exit
    end
  
    blog_filename = ARGV[0]
    # Check if the file exists in the 'posts' folder
    blog_path = File.join('posts', blog_filename)
    if File.exist?(blog_path)
      delete_blog_post(blog_filename)
      update_index_html(blog_filename)
      puts "Deleted '#{blog_path}' and updated 'index.html'."
    else
      puts "File '#{blog_path}' does not exist."
    end
  end
  