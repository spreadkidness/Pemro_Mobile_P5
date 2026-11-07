MP-PM-05 - Keamanan Data & HTTP Dasar

1. Buat proyek:
   flutter create secure_http
2. Ganti pubspec.yaml dan folder lib dengan isi paket ini.
3. Jalankan:
   flutter pub get
4. Tambahkan permission INTERNET pada:
   android/app/src/main/AndroidManifest.xml
   Letakkan di dalam <manifest>, di luar <application>.
5. Pada tag <application>, tambahkan:
   android:allowBackup="false"
   android:usesCleartextTraffic="false"
6. Jalankan:
   flutter analyze
   flutter run

Login adalah simulasi lokal untuk latihan dan tidak mengirim email/kata sandi
ke server. API GET menggunakan HTTPS JSONPlaceholder.

Latihan:
1. Login form + simpan token ke secure storage: LoginScreen.
2. Logout + hapus token + konfirmasi: HomeScreen._logout.
3. GET /posts + model Post + ListView.builder: PostListScreen.
4. Pencarian nama/email secara real-time: UserListScreen.
5. Timeout yang dapat diatur: UserListScreen dan ApiService.getUsers.

Catatan:
- Jangan mencetak token, PIN, kata sandi, atau data pribadi ke debug log.
- JSONPlaceholder merupakan API contoh; login pada proyek ini bukan autentikasi
  akun sungguhan.
