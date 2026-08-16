# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Bersihkan data demo placeholder dari versi sebelumnya agar dataset konsisten.
Post.where("title LIKE 'Post contoh %' OR title = 'Post dari admin'").destroy_all

categories = {}
[ "Ruby", "Rails", "Database & SQL", "Frontend", "Karier" ].each do |name|
  category = Category.find_or_initialize_by(slug: name.parameterize)
  category.name = name
  category.save!
  categories[name.parameterize] = category
end

user_data = [
  [ "admin@example.com", "Admin Utama", :admin ],
  [ "user@example.com", "User Biasa", :user ],
  [ "budi.santoso@example.com", "Budi Santoso", :user ],
  [ "siti.rahayu@example.com", "Siti Rahayu", :user ],
  [ "agus.wijaya@example.com", "Agus Wijaya", :user ],
  [ "dewi.lestari@example.com", "Dewi Lestari", :user ],
  [ "rizky.pratama@example.com", "Rizky Pratama", :user ],
  [ "maya.anggraini@example.com", "Maya Anggraini", :user ]
]

users = user_data.map do |email, name, role|
  user = User.find_or_initialize_by(email_address: email)
  user.name = name
  user.role = role
  user.password = "password" unless user.password_digest.present?
  user.save!
  user
end

post_data = [
  {
    title: "Mengenal Ruby: Bahasa yang Mengutamakan Kebahagiaan Programmer",
    body: "Ruby adalah bahasa pemrograman yang dirancang oleh Yukihiro Matsumoto dengan prinsip bahwa pemrogram harus merasa senang saat menulis kode. Sintaksnya yang elegan dan mudah dibaca membuat Ruby menjadi pilihan populer untuk memulai belajar pemrograman.\n\nDi artikel ini kita akan membahas sejarah singkat Ruby, filosofi \"Matz is nice and so we are nice\", serta mengapa komunitasnya sangat ramah terhadap pemula.",
    user: "admin@example.com", category: "ruby", status: :published, created_days_ago: 75
  },
  {
    title: "Instalasi Ruby di Windows: Panduan Lengkap",
    body: "Menginstal Ruby di Windows kini jauh lebih mudah dengan bantuan RubyInstaller. Setelah instalasi, jangan lupa menambahkan DevKit agar gem dengan ekstensi native bisa tercompile dengan lancar.\n\nKami juga membahas cara memverifikasi instalasi lewat perintah ruby -v dan gem -v, plus tips mengatasi error PATH yang sering muncul.",
    user: "admin@example.com", category: "ruby", status: :published, created_days_ago: 70
  },
  {
    title: "Metode dan Blok di Ruby untuk Pemula",
    body: "Blok adalah salah satu konsep paling khas di Ruby. Dalam artikel ini kita belajar bedanya block, proc, dan lambda, lengkap dengan contoh penggunaan seperti each, map, dan yield.\n\nDengan memahami blok, kode Ruby kamu akan jauh lebih ekspresif dan ringkas.",
    user: "user@example.com", category: "ruby", status: :published, created_days_ago: 60
  },
  {
    title: "Memahami Enumerable: Map, Select, dan Reduce",
    body: "Enumerable adalah modul paling bermanfaat di Ruby. Artikel ini menjelaskan map, select, reduce, dan friend-nya dengan studi kasus pengolahan data sederhana.\n\nSetelah membaca, kamu akan terbiasa menulis kode fungsional yang lebih bersih dibandingkan loop manual.",
    user: "user@example.com", category: "ruby", status: :draft, created_days_ago: 10
  },
  {
    title: "Kenapa Ruby 3.x Terasa Jauh Lebih Cepat?",
    body: "Proyek Ruby 3x3 menargetkan performa tiga kali lebih cepat dibanding Ruby 2.0. Hasilnya terlihat nyata pada versi 3.x berkat MJIT, YJIT, dan berbagai optimasi GC.\n\nKita bandingkan benchmark sederhana dan membahas kapan YJIT mulai memberi manfaat di aplikasi produksi.",
    user: "rizky.pratama@example.com", category: "ruby", status: :published, created_days_ago: 55
  },
  {
    title: "Membuat Aplikasi Blog Pertama dengan Rails 8",
    body: "Rails 8 hadir dengan banyak penyederhanaan, termasuk autentikasi bawaan dan build-tool yang lebih modern. Artikel ini memandu pembuatan aplikasi blog dari nol sampai bisa dijalankan di local.\n\nIkuti langkah demi langkah: scaffold, migrasi database, dan fitur CRUD pertama kamu.",
    user: "admin@example.com", category: "rails", status: :published, created_days_ago: 65
  },
  {
    title: "Hotwire dan Turbo: Interaksi Tanpa Refresh di Rails",
    body: "Hotwire memungkinkan aplikasi Rails terasa seperti SPA tanpa menulis JavaScript rumit. Turbo Drive menangani navigasi, sementara Turbo Frames dan Streams mengubah bagian halaman secara dinamis.\n\nKita pelajari kapan memakai frames vs streams, plus pola umum yang dipakai tim produksi.",
    user: "admin@example.com", category: "rails", status: :published, created_days_ago: 50
  },
  {
    title: "Autentikasi di Rails 8: has_secure_password dan Session",
    body: "Mulai Rails 7.1, autentikasi sederhana bisa dibangun dengan has_secure_password plus model Session. Rails 8 membawa pola ini ke level lebih matang tanpa perlu gem eksternal.\n\nArtikel ini membahas cookie session yang aman, helper login-logout, dan best practice menyimpan session di database.",
    user: "user@example.com", category: "rails", status: :published, created_days_ago: 45
  },
  {
    title: "Active Record: Query yang Sering Dipakai Sehari-hari",
    body: "Active Record adalah ORM bawaan Rails yang sangat ekspresif. Kita bahas scope, eager loading, batas jumlah query, dan pola pencarian yang sering muncul di aplikasi nyata.\n\nDilengkapi contoh kode yang bisa langsung kamu coba di konsol Rails.",
    user: "budi.santoso@example.com", category: "rails", status: :published, created_days_ago: 40
  },
  {
    title: "Mengoptimalkan Query N+1 di Rails",
    body: "Masalah N+1 adalah penyebab utama aplikasi Rails lambat. Dengan includes dan preload yang tepat, jumlah query bisa turun drastis.\n\nKita ukur dampaknya menggunakan log query dan bullet gem, lalu lihat perbedaannya sebelum dan sesudah optimasi.",
    user: "admin@example.com", category: "rails", status: :published, created_days_ago: 35
  },
  {
    title: "Deploy Rails ke Server Sendiri: Panduan Praktis",
    body: "Deploy Rails tidak harus menggunakan layanan mahal. Dengan VPS murah, Kamal, dan Docker, aplikasi Rails 8 bisa berjalan di server kamu sendiri dalam hitungan menit.\n\nArtikel ini membahas konfigurasi Kamal, reverse proxy, dan SSL dengan Let's Encrypt.",
    user: "budi.santoso@example.com", category: "rails", status: :draft, created_days_ago: 5
  },
  {
    title: "SQL vs NoSQL: Kapan Harus Memakai Apa?",
    body: "Memilih antara database relasional dan NoSQL adalah keputusan arsitektur penting. Artikel ini membandingkan karakteristik SQL (relasional) dan NoSQL (dokumen, key-value, graph) dengan contoh kasus nyata.\n\nTujuannya supaya kamu bisa memilih berdasarkan kebutuhan konsistensi, skalabilitas, dan struktur data.",
    user: "agus.wijaya@example.com", category: "database-sql", status: :published, created_days_ago: 58
  },
  {
    title: "Belajar MySQL untuk Pemula",
    body: "MySQL adalah database relasional paling populer untuk aplikasi web. Kita mulai dari membuat database, tabel, sampai query SELECT, JOIN, dan GROUP BY yang sering dipakai.\n\nKamu juga belajar tips keamanan dasar seperti menghindari SQL injection dengan parameter binding.",
    user: "agus.wijaya@example.com", category: "database-sql", status: :published, created_days_ago: 30
  },
  {
    title: "Indexing Database: Trik Agar Query Cepat",
    body: "Index bisa mempercepat query puluhan kali lipat, tapi salah pakai malah bikin INSERT lambat. Artikel ini menjelaskan jenis index, cara memilih kolom yang tepat, dan membaca EXPLAIN untuk menemukan bottleneck.\n\nDisertai contoh kasus tabel posts yang mulai melambat karena jutaan baris.",
    user: "agus.wijaya@example.com", category: "database-sql", status: :published, created_days_ago: 20
  },
  {
    title: "Transaksi Database dan Kapan Menggunakannya",
    body: "Transaksi memastikan sekumpulan operasi database berjalan all-or-nothing. Kita bahas ACID, penggunaan begin-transaction di Rails, dan pola yang benar untuk menjaga konsistensi data.\n\nTermasuk pembahasan locking dan kapan transaksi justru tidak diperlukan.",
    user: "dewi.lestari@example.com", category: "database-sql", status: :published, created_days_ago: 15
  },
  {
    title: "Migrasi Data yang Aman di Produksi",
    body: "Mengubah skema database di produksi berisiko jika tidak direncanakan. Artikel ini membahas strategi expand-contract: menambah kolom baru, backfill, lalu menghapus kolom lama secara bertahap.\n\nDilengkapi checklist sebelum menjalankan migrasi besar di jam sibuk.",
    user: "dewi.lestari@example.com", category: "database-sql", status: :draft, created_days_ago: 3
  },
  {
    title: "Tailwind CSS 4: Apa yang Baru?",
    body: "Tailwind CSS 4 mengubah cara kerja besar-besaran dengan engine CSS-first yang jauh lebih cepat. Kini konfigurasi cukup lewat CSS tanpa file config terpisah.\n\nKita bahas fitur baru seperti @theme, source detection otomatis, dan peningkatan performa build yang signifikan.",
    user: "maya.anggraini@example.com", category: "frontend", status: :published, created_days_ago: 42
  },
  {
    title: "Belajar Flexbox dan Grid dalam 30 Menit",
    body: "Flexbox dan Grid adalah dua sistem layout CSS yang wajib dikuasai. Artikel ini menjelaskan perbedaan keduanya dan kapan memakai yang mana dengan contoh layout nyata: navbar, kartu, dan dashboard.\n\nSemua contoh bisa langsung dicoba di browser tanpa framework apapun.",
    user: "maya.anggraini@example.com", category: "frontend", status: :published, created_days_ago: 28
  },
  {
    title: "DaisyUI: Komponen UI Tanpa Ribet untuk Tailwind",
    body: "DaisyUI menyediakan komponen siap pakai seperti button, card, drawer, dan modal di atas Tailwind. Cukup tulis class tertentu, tampilan langsung rapi dan konsisten.\n\nKita coba membangun halaman dashboard sederhana hanya dalam beberapa menit, lengkap dengan tema gelap-terang.",
    user: "siti.rahayu@example.com", category: "frontend", status: :published, created_days_ago: 25
  },
  {
    title: "Dark Mode di Web App dengan CSS Modern",
    body: "Mendukung dark mode kini semudah menggunakan media query prefers-color-scheme dan CSS custom properties. Artikel ini membahas pola yang dipakai daisyUI dan Tailwind untuk tema dinamis.\n\nKamu juga belajar mempersistensi pilihan tema pengguna di localStorage.",
    user: "siti.rahayu@example.com", category: "frontend", status: :published, created_days_ago: 12
  },
  {
    title: "Membangun Portofolio Developer yang Dilirik Recruiter",
    body: "Portofolio bukan sekadar kumpulan repository. Artikel ini membahas cara menyusun proyek yang menunjukkan dampak, menulis README yang baik, dan menghubungkannya dengan CV.\n\nDisertai daftar hal yang sering membuat portofolio ditolak recruiter.",
    user: "rizky.pratama@example.com", category: "karier", status: :published, created_days_ago: 48
  },
  {
    title: "Cara Menulis CV Teknis yang Menarik",
    body: "CV developer sering terlalu ramai atau terlalu kosong. Kita bahas format yang direkomendasikan, cara menonjolkan stack yang relevan, dan menghindari red flag yang bikin lamaran diabaikan.\n\nAda juga template CV satu halaman yang bisa langsung kamu adaptasi.",
    user: "siti.rahayu@example.com", category: "karier", status: :published, created_days_ago: 22
  },
  {
    title: "Persiapan Interview Coding: Strategi Jitu",
    body: "Interview coding bukan cuma soal kemampuan, tapi juga strategi. Artikel ini membahas pola soal umum, cara berpikir aloud, dan bagaimana membangun komunikasi yang baik dengan pewawancara.\n\nTermasuk daftar topik yang wajib diulang sebelum interview: struktur data, algoritma, dan SQL.",
    user: "dewi.lestari@example.com", category: "karier", status: :published, created_days_ago: 8
  },
  {
    title: "Skill yang Wajib Dimiliki Backend Engineer di 2026",
    body: "Lanskap backend terus berubah. Selain bahasa pemrograman dan database, kemampuan microservices, observability, dan keamanan API kini menjadi pembeda utama kandidat.\n\nKita susun peta belajar realistis untuk pemula sampai level menengah berdasarkan kebutuhan industri 2026.",
    user: "budi.santoso@example.com", category: "karier", status: :published, created_days_ago: 6
  }
]

post_data.each do |data|
  author = users.find { |u| u.email_address == data[:user] }
  author.posts.find_or_create_by!(title: data[:title]) do |post|
    post.body = data[:body]
    post.status = data[:status]
    post.category = categories[data[:category]]
    post.created_at = Time.current - data[:created_days_ago].days
  end
end

comment_data = [
  { post: "Mengenal Ruby: Bahasa yang Mengutamakan Kebahagiaan Programmer",
    user: "user@example.com", created_days_ago: 72,
    body: "Baru pertama kenal Ruby dan langsung suka dengan filosofinya. Artikel ini sangat membantu!" },
  { post: "Mengenal Ruby: Bahasa yang Mengutamakan Kebahagiaan Programmer",
    user: "budi.santoso@example.com", created_days_ago: 71,
    body: "Tambahan: coba juga baca buku Programming Ruby (Pickaxe), masih relevan sampai sekarang." },
  { post: "Mengenal Ruby: Bahasa yang Mengutamakan Kebahagiaan Programmer",
    user: "maya.anggraini@example.com", created_days_ago: 69,
    body: "Setuju soal komunitas yang ramah. Slack Ruby Indonesia juga aktif lho, worth it buat gabung." },
  { post: "Membuat Aplikasi Blog Pertama dengan Rails 8",
    user: "siti.rahayu@example.com", created_days_ago: 62,
    body: "Berhasil diikuti sampai selesai! Tutorial yang jelas dan urut. Terima kasih banyak." },
  { post: "Membuat Aplikasi Blog Pertama dengan Rails 8",
    user: "rizky.pratama@example.com", created_days_ago: 60,
    body: "Ada bagian deploy-nya juga? Semoga dilanjut, karena itu yang paling bikin penasaran." },
  { post: "Belajar MySQL untuk Pemula",
    user: "dewi.lestari@example.com", created_days_ago: 28,
    body: "Penjelasan JOIN-nya enak dibaca. Kalau bisa ditambah contoh INNER vs LEFT JOIN lebih banyak dong." },
  { post: "Belajar MySQL untuk Pemula",
    user: "admin@example.com", created_days_ago: 27,
    body: "Noted! Kami akan buat artikel lanjutan khusus soal JOIN dalam beberapa minggu ke depan." },
  { post: "DaisyUI: Komponen UI Tanpa Ribet untuk Tailwind",
    user: "maya.anggraini@example.com", created_days_ago: 24,
    body: "Akhirnya nemu penjelasan drawer yang gampang dicerna. Langsung saya coba di project sampingan." },
  { post: "DaisyUI: Komponen UI Tanpa Ribet untuk Tailwind",
    user: "user@example.com", created_days_ago: 23,
    body: "Bagaimana cara custom warna primary-nya? Saya mau pakai warna brand sendiri." },
  { post: "Persiapan Interview Coding: Strategi Jitu",
    user: "agus.wijaya@example.com", created_days_ago: 7,
    body: "Poin soal komunikasi itu underrated banget. Baru sadar setelah interview pertama saya gagal karena terlalu diam." },
  { post: "Persiapan Interview Coding: Strategi Jitu",
    user: "admin@example.com", created_days_ago: 6,
    body: "Betul, berpikir aloud itu skill yang harus dilatih. Semoga sukses interview berikutnya!" },
  { post: "Skill yang Wajib Dimiliki Backend Engineer di 2026",
    user: "rizky.pratama@example.com", created_days_ago: 5,
    body: "Peta belajarnya realistis. Akhirnya tahu harus mulai dari mana untuk observability." }
]

comment_data.each do |data|
  post = Post.find_by!(title: data[:post])
  author = users.find { |u| u.email_address == data[:user] }
  post.comments.find_or_create_by!(user: author, body: data[:body]) do |comment|
    comment.created_at = Time.current - data[:created_days_ago].days
  end
end

# Pastikan tabel sessions juga berisi minimal 5 baris data demo.
session_sources = [
  { ip: "192.168.1.10", ua: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/126.0" },
  { ip: "192.168.1.24", ua: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) Safari/605.1.15" },
  { ip: "172.16.4.3",   ua: "Mozilla/5.0 (X11; Linux x86_64) Firefox/127.0" },
  { ip: "10.0.0.55",    ua: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Edge/126.0" },
  { ip: "192.168.1.87", ua: "PostmanRuntime/7.38.0" }
]

while Session.count < 5
  index = Session.count % session_sources.size
  source = session_sources[index]
  stamp = Time.current - (index * 3).days
  users[index % users.size].sessions.create!(ip_address: source[:ip], user_agent: source[:ua], created_at: stamp, updated_at: stamp)
end

puts "Seed selesai: #{User.count} pengguna, #{Category.count} kategori, #{Post.count} post (#{Post.published.count} publikasi, #{Post.draft.count} draft), #{Comment.count} komentar, #{Session.count} sesi."
puts "Demo: admin@example.com / user@example.com (password: password)"
