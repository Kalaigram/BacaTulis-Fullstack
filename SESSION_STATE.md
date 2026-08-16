# Session State — CRUD-RUBY (update 16 Aug 2026)

## README + jaminan minimal 5 data per tabel (SELESAI ✔)
- **`README.md`** dibuat di root proyek: deskripsi, fitur, stack, prasyarat, instalasi, env block Windows,
  build CSS manual, akun demo (8 user, password `password`), tabel data dummy, testing/linter, struktur
  proyek, tabel rute utama, dan catatan penting (mysql2/trilogy, parallelize off, CSRF per-form).
- **Semua tabel dijamin ≥5 baris dari seed** (seeds.rb sekarang idempotent top-up `sessions` ke 5):
  users=8, categories=5, posts=24 (21 publikasi/3 draft), comments=12, sessions=5.
- Status tetap hijau: 61 test / 290 assertions, rubocop 57 files 0 offenses.

## Fitur lengkap + data dummy profesional (SELESAI ✔)
- **Registrasi**: `resource :registration` (`new`/`create`) — daftar akun baru (nama/email/password),
  langsung auto-login. Link di halaman masuk & sebaliknya. User model validasi format email (`URI::MailTo::EMAIL_REGEXP`).
- **Kategori** (admin CRUD, `resources :categories, except: :show`): tabel kategori + jumlah post, form create/edit,
  slug otomatis (`parameterize`), hapus = post jadi tanpa kategori (`dependent: :nullify`). Filter kategori di index post + select di form post.
- **Komentar** (semua user): form + daftar di halaman post (urut terbaru), badge role penulis, hapus oleh pemilik/owner/admin.
  Route nested `POST /posts/:post_id/comments` + `DELETE /comments/:id`.
- **Dashboard**: kartu Total/Publikasi/Draft (+Total Pengguna admin), 5 post terbaru, + **Komentar Terbaru** (admin).
- **Sidebar**: Dashboard / Semua Post / Post Saya / Kategori (admin) / Pengguna (admin).
- **Seed dummy profesional & idempotent**: 8 pengguna (nama Indonesia + email realistik), 5 kategori
  (Ruby/Rails/Database & SQL/Frontend/Karier), **24 post** (21 publikasi, 3 draft) judul+isi topik teknis nyata,
  `created_at` tersebar 3 bulan, **12 komentar** lintas user. Post placeholder lama dibersihkan di seed.
  Login page menampilkan info akun demo.
- **Test: 61 runs, 290 assertions, 0 failures, 0 errors** (registrations/categories/comments controller tests baru;
  posts test + filter kategori + create dgn kategori). **Rubocop: 57 files, 0 offenses**.
- **PENTING — parallelize dimatikan** (`test/test_helper.rb`): `parallelize(workers: 0)` karena MySQL rawan
  `ActiveRecord::Deadlocked` saat insert fixture paralel (>50 test). Jangan nyalakan tanpa alasan kuat.
- **CSRF di Rails 8.1**: token per-form (terikat action+method) — saat verifikasi manual via curl harus ambil
  token dari form yang tepat (regex `action="/posts/10/comments"...value="([^"]+)"`), bukan token pertama.
- **Verifikasi e2e via curl**: registrasi → auto-login → dashboard; login admin → /categories (tabel, 5 kategori),
  /posts (24 post, toolbar filter), /posts/:id (komentar + form + badge kategori), POST komentar → 302 → komentar tampil.
  Data verifikasi dibersihkan kembali ke 8/24/12.

## Dashboard layout + fitur sebelumnya (SELESAI ✔)
- **Layout dashboard** (`app/views/layouts/application.html.erb`): daisyUI drawer `lg:drawer-open`.
  Sidebar menu (Dashboard / Semua Post / Post Saya / Pengguna-admin) + navbar hamburger (lg:hidden) +
  dropdown profil + tombol keluar. Untuk tamu (belum login) hanya render konten tanpa sidebar.
- **Fitur baru**:
  - Dashboard (`dashboard#index`, root) — kartu statistik Total/Publikasi/Draft (+ Total Pengguna utk admin) + 5 post terbaru.
  - Profil (`resource :profile`) — lihat + edit nama/email + ganti password (kosongkan = tidak diubah).
  - Manajemen user (admin, `resources :users`) — ganti role inline, hapus user (guard: tidak bisa ubah/hapus diri sendiri).
  - Pencarian post (`q` LIKE title/body via `sanitize_sql_like`) + filter status (draft/published) + pagination
    manual 6/halaman (`Post.paginate` + partial `_pagination` memakai `url_for(request.params.merge(...))`).
  - Post punya `status` (enum draft:0/published:1, default published) + badge di index/dashboard/show + select di form.
  - User punya kolom `name` (nullable, fallback tampil email). Role user sekarang enum (`user`/`admin`).
- **Model**: `Post` scopes `search`/`by_status`/`paginate`; `User` enum role.
- **Test: 43 runs, 192 assertions, 0 failures, 0 errors** (dashboard, profiles, users controller tests baru;
  posts test ditambah: create draft, filter status, search). **Rubocop: 46 files, 0 offenses**.
- **Verifikasi end-to-end (curl dgn CSRF + cookie jar)**: login admin 302, / = dashboard+drawer+sidebar,
  /users = tabel+admin, /posts?scope=mine = 200, /profile tampil "Admin Utama".
- Migrasi baru: `20260817000001_add_name_to_users`, `20260817000002_add_status_to_posts` (sudah dijalankan dev+test).

## UI: daisyUI 5 + Tailwind CSS v4 (SELESAI ✔)
- Stack: **Tailwind CSS v4.3.3 + daisyUI 5.7.17** via npm (@tailwindcss/cli), di-build ke `app/assets/builds/tailwind.css`.
- **Tema custom "rails"** di `app/assets/stylesheets/application.css` (via `@plugin "daisyui/theme"`): primary = Rails red #D30001,
  light (default) + rails-dark (prefersdark). Layout: strip merah atas + logo "R" kotak merah ala Rails di navbar.
- Gem `cssbundling-rails` ditambahkan (1.4.3, 126 gems).
- **Windows workaround di `config/boot.rb`**: `ENV["SKIP_CSS_BUILD"]="1"` karena cssbundling-rails mendeteksi tool
  pakai `command -v` yang tak ada di cmd/PowerShell. CSS di-build MANUAL.
- Semua view di-rewrite ke komponen daisyUI: navbar+dropdown menu, card, badge role, alert flash, fieldset form, btn.
- `app/assets/stylesheets/application.css` = input Tailwind v4 (`@import "tailwindcss"; @plugin "daisyui"; @source "../views";`).
- Layout pakai `stylesheet_link_tag "tailwind"` (hasil build), bukan `:app`.
- `bin/dev` = spawn server + `npm run watch:css` berdampingan.
- `.gitignore` + `app/assets/builds/.keep` + `node_modules`.

### Workflow CSS (WAJIB manual di Windows):
```powershell
npm run build:css     # build sekali
npm run watch:css     # watch saat develop (atau pakai bin/dev yang sudah jalanin watch)
```

## STATUS SEBELUMNYA: app + MySQL adapter SELESAI ✔
- **Adapter MySQL**: mysql2 0.5.7 (bukan trilogy — trilogy TIDAK dukung Windows, issue #138/#83).
- **trilogy TIDAK mendukung Windows** — maintainer tutup issue #138 & #83 ("Windows support has not been added").
  Header POSIX (poll.h, sys/socket.h, arpa/inet.h) memang TIDAK ada di repo MSYS2 mana pun & tidak pernah
  ada di mingw-w64 (history v2.0.8..master 404). => jangan kembali ke trilogy.

## Solusi final yang bekerja (MySQL)
- mysql2 0.5.7 di-compile source (platform ruby only, no prebuilt ucrt) **terhadap libmariadb (mingw-built)**:
  - Paket MSYS2: `mingw-w64-ucrt-x86_64-libmariadbclient-3.4.9-1` diekstrak ke `D:\msysroot\ucrt64`
    (bin: libmariadb.dll + mariadb_config/mysql_config; include: mariadb/ & mysql/; lib: libmysqlclient.dll.a alias built-in).
  - mysql2 0.5.7 ternyata MASIH kompatibel Ruby 4.0.6 (`rb_wait_for_single_fd` masih ada, cuma deprecated).
  - build cmd: `gem install mysql2 -v 0.5.7 -- --with-mysql-dir=D:/msysroot/ucrt64`
- **Gemfile**: `gem "mysql2"`; **database.yml**: `adapter: mysql2`.
- `bundle install` OK — 126 gems di `D:\gembundle\crud_ruby` (bcrypt ikut tercompile). Gemfile.lock ADA sekarang.
- `db:create`, `db:migrate` (3 migrasi), `db:seed` OK. users=2, posts=6, admins=1.
- **test: 24 runs, 91 assertions, 0 failures, 0 errors** (mulanya 11 error dari `cookies.signed`
  di Rack::Test → SignInHelper di `test/test_helper.rb` diubah jadi login sungguhan via POST /session).
- **rubocop: 38 files, 0 offenses** (fix 2 spasi di posts_controller.rb:49).
- **Server + login end-to-end OK**: GET /session/new=200, POST login (dgn CSRF token)=302, /posts=200 + flash "Berhasil masuk".

## CARA JALANKAN (WAJIB env block ini, karena C: penuh & libmariadb.dll di D:)
```powershell
$env:HOME="D:\MY GITHUB\CRUD-RUBY\.bundle\home"; $env:USERPROFILE=$env:HOME
$env:HOMEDRIVE="D:"; $env:HOMEPATH="\MY GITHUB\CRUD-RUBY\.bundle\home"
$env:TEMP="D:\MY GITHUB\CRUD-RUBY\.bundle\tmp"; $env:TMP=$env:TEMP
$env:GEM_HOME="D:\gembundle\crud_ruby\ruby\4.0.0"; $env:GEM_PATH=$env:GEM_HOME
$env:PATH="C:\Ruby40-x64\bin;C:\Ruby40-x64\msys64\ucrt64\bin;C:\Ruby40-x64\msys64\usr\bin;D:\msysroot\ucrt64\bin;$env:PATH"
cd "D:\MY GITHUB\CRUD-RUBY"
ruby bin\rails server   # (gunakan "ruby bin\rails ...", bukan "bin\rails ..." di PowerShell)
```
- `D:\msysroot\ucrt64\bin` di PATH = biar libmariadb.dll ketemu saat runtime.
- `ruby bin\rails test` / `ruby bin\rails db:migrate` dst pakai env yang sama.
- Demo akun: admin@example.com / user@example.com, password "password".

## Catatan infra
- `.bundle/config`: BUNDLE_PATH=`D:/gembundle/crud_ruby`, BUNDLE_CACHE_PATH=`D:/MY GITHUB/CRUD-RUBY/.bundle/cache`.
- `D:\msys2_pkgs\`: arsip ucrt64.db/ucrt64.files/mingw64.files + ekstrak (files\, mingw64_files\) + tarball libmariadbclient — boleh dihapus kalau mau hemat space.
- `D:\msysroot\ucrt64\`: libmariadbclient (DLL+headers+import lib) — JANGAN dihapus, dipakai runtime.
- Vendor lama `D:\MY GITHUB\CRUD-RUBY\vendor\bundle` (122 gems lama) TIDAK dipakai — bisa dihapus.
- Path proyek ada spasi (`MY GITHUB`) => gem native build hanya bekerja via bundle path no-spaces (D:\gembundle).