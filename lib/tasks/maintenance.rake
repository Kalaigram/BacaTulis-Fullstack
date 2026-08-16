namespace :maintenance do
  desc "Hapus post draft yang sudah lama tidak diperbarui"
  task cleanup_drafts: :environment do
    count = Post.draft.where("updated_at < ?", 30.days.ago).destroy_all.size
    puts "Dihapus #{count} post draft lama."
  end
end
