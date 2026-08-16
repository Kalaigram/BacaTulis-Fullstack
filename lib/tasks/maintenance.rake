namespace :maintenance do
  desc "Hapus post draft yang sudah lama tidak diperbarui"
  task cleanup_drafts: :environment do
    count = Post.draft.where("updated_at < ?", 30.days.ago).destroy_all.size
    puts "Dihapus #{count} post draft lama."
  end

  desc "Hapus sesi login yang sudah berumur lebih dari 90 hari"
  task purge_sessions: :environment do
    count = Session.where("created_at < ?", 90.days.ago).destroy_all.size
    puts "Dihapus #{count} sesi lama."
  end
end
