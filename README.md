# BacaTulis — Aplikasi Blog Dashboard

Aplikasi blog berbasis **Ruby on Rails 8** dengan layout dashboard modern (daisyUI + Tailwind CSS v4),
mendukung peran **admin** dan **user**, lengkap dengan manajemen post, kategori, komentar, profil,
serta data dummy yang realistis dan profesional.

## Fitur

- **Autentikasi** (Rails 8 bawaan): login, logout, registrasi akun baru dengan auto-login.
- **Dashboard**: statistik post (total/publikasi/draft), 5 post terbaru, komentar terbaru (admin).
- **Manajemen Post (CRUD)**:
  - Admin dapat melihat & mengelola semua post; user hanya post miliknya.
  - Status **publikasi / draft** dengan badge status.
  - Pencarian judul/isi, filter status & kategori, pagination 6 per halaman.
- **Kategori** (admin): CRUD lengkap, slug otomatis, jumlah post per kategori.
- **Komentar**: semua user dapat berkomentar, hapus oleh pemilik/owner/admin.
- **Profil**: ubah nama, email, dan ganti password.
- **Manajemen Pengguna** (admin): ubah peran (user/admin) dan hapus akun.
- **UI**: tema custom "Rails Red" dengan mode terang/gelap, sidebar responsif (drawer).

## Teknologi

| Bagian      | Teknologi |
|-------------|-----------|
| Framework   | Ruby on Rails 8.1 (Ruby 4.0) |
| Database    | MySQL 8 (adapter `mysql2` 0.5.7) |
| UI          | Tailwind CSS v4.3 + daisyUI 5.7 |
| Auth        | `has_secure_password` + model `Session` |
| Testing     | Minitest (integration test) |
| Linter      | RuboCop |

## Prasyarat

- **Ruby 4.x** + DevKit (MSYS2) — di Windows pakai [RubyInstaller](https://rubyinstaller.org/)
- **MySQL 8** (mis. Laragon/XAMPP) berjalan di `127.0.0.1:3306`
- **Node.js + npm** (untuk build CSS Tailwind/daisyUI)

## Konfigurasi Database

Sesuaikan kredensial di `config/database.yml`. Default:

```yaml
adapter: mysql2
host: 127.0.0.1
username: root
password: <password-mysql-mu>
database: crud_ruby_development
```

> **Catatan khusus Windows**: `mysql2` dikompilasi terhadap **libmariadb** yang tersedia di
> `D:\msysroot\ucrt64`; pastikan `D:\msysroot\ucrt64\bin` masuk `PATH` saat runtime.

## Instalasi & Menjalankan

```bash
# 1. Pasang dependensi
bundle install
npm install

# 2. Siapkan database + data dummy (idempotent, aman dijalankan berulang)
bin/rails db:prepare      # create + migrate + seed (satu perintah)
# atau:
bin/rails db:create db:migrate db:seed

# 3. Build CSS Tailwind/daisyUI
npm run build:css

# 4. Jalankan server
bin/rails server
```

Akses aplikasi di <http://localhost:3000>.

### Env block wajib (khusus Windows di mesin ini)

Karena drive `C:` penuh dan gem native berada di path tanpa spasi, jalankan perintah Rails
dengan env berikut (contoh di PowerShell):

```powershell
$env:HOME="D:\MY GITHUB\CRUD-RUBY\.bundle\home"; $env:USERPROFILE=$env:HOME
$env:HOMEDRIVE="D:"; $env:HOMEPATH="\MY GITHUB\CRUD-RUBY\.bundle\home"
$env:TEMP="D:\MY GITHUB\CRUD-RUBY\.bundle\tmp"; $env:TMP=$env:TEMP
$env:GEM_HOME="D:\gembundle\crud_ruby\ruby\4.0.0"; $env:GEM_PATH=$env:GEM_HOME
$env:PATH="C:\Ruby40-x64\bin;C:\Ruby40-x64\msys64\ucrt64\bin;C:\Ruby40-x64\msys64\usr\bin;D:\msysroot\ucrt64\bin;$env:PATH"
```

Pada PowerShell gunakan `ruby bin\rails ...` (bukan `bin\rails ...`).

### Build CSS (manual di Windows)

cssbundling-rails memakai `command -v` yang tidak tersedia di Windows, sehingga build dilakukan manual:

```bash
npm run build:css   # build sekali
npm run watch:css   # auto-rebuild saat develop
```

## Akun Demo

| Email                  | Peran  | Password |
|------------------------|--------|----------|
| `admin@example.com`    | Admin  | `password` |
| `user@example.com`     | User   | `password` |

Plus 6 akun user dummy lain (semua berpassword `password`):
`budi.santoso@example.com`, `siti.rahayu@example.com`, `agus.wijaya@example.com`,
`dewi.lestari@example.com`, `rizky.pratama@example.com`, `maya.anggraini@example.com`.

### Data dummy

Setiap tabel dijamin berisi minimal **5 baris**:

| Tabel       | Jumlah |
|-------------|--------|
| users       | 8      |
| categories  | 5      |
| posts       | 24 (21 publikasi, 3 draft) |
| comments    | 12     |
| sessions    | 5      |

## Testing & Linter

```bash
ruby bin/rails test    # 61 test / 290 assertions
ruby bin/rails rubocop # 57 files, 0 offenses
```

## Struktur Proyek

```
app/
  controllers/          # posts, sessions, registrations, profiles,
                        # categories, comments, users, dashboard
  controllers/concerns/ # authentication.rb (login/logout, require_admin)
  models/               # user, session, post, category, comment
  views/                # daisyUI + layout drawer sidebar
  assets/stylesheets/   # input Tailwind + tema "rails"/"rails-dark"
config/routes.rb        # definisi seluruh route
db/
  migrate/              # 8 migrasi (users..comments)
  seeds.rb              # data dummy profesional & idempotent
test/                   # integration tests + fixtures
```

## Rute Utama

| Method | Path                  | Keterangan |
|--------|-----------------------|------------|
| GET    | `/`                   | Dashboard |
| POST   | `/session`            | Login |
| DELETE | `/session`            | Logout |
| GET/POST | `/registration`     | Daftar akun |
| GET    | `/posts`              | Daftar post (cari/filter/pagination) |
| GET/POST/PATCH/DELETE | `/posts/…` | CRUD post |
| POST   | `/posts/:id/comments` | Tambah komentar |
| DELETE | `/comments/:id`       | Hapus komentar |
| GET/PATCH | `/profile`         | Lihat/ubah profil |
| GET    | `/categories`         | Kategori (admin) |
| GET/PATCH/DELETE | `/users`      | Manajemen pengguna (admin) |

## Catatan Penting

- **MySQL adapter**: proyek memakai `mysql2` (bukan `trilogy`) karena trilogy **tidak mendukung Windows**.
- **Test paralel dimatikan** (`test/test_helper.rb`, `parallelize(workers: 0)`) untuk menghindari
  deadlock insert fixture MySQL. Jangan nyalakan ulang tanpa alasan kuat.
- **CSRF token Rails 8.1** bersifat per-form (terikat action + method).
- Gunakan `ruby bin/rails ...` untuk semua perintah Rails di PowerShell.

## Lisensi

Proyek contoh/demo untuk keperluan pembelajaran.