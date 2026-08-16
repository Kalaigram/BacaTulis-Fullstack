namespace :demo do
  desc "Reset data demo ke kondisi seed (hapus lalu seed ulang)"
  task reset: :environment do
    puts "Menghapus data demo..."
    Comment.destroy_all
    Post.destroy_all
    Session.destroy_all
    Category.destroy_all
    User.destroy_all
    puts "Menjalankan seed..."
    Rake::Task["db:seed"].invoke
    puts "Data demo selesai di-reset."
  end
end
