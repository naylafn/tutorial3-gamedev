# Tutorial 3 - Game Development
### Nayla Farah Nida [2306213426]

Fitur yang diimplementasikan:
1. Double Jump
   Saya menggunakan counter ```jump_count``` untuk jumlah lompatan karakter dengan variabel ```max_jump``` bernilai 2. Kemudian dalam fungsi ```_physics_process```
   terdapat conditional jika karakter menyentuh lantai, maka counter akan di reset menjadi 0.
2. Crouch
   Secara visual, implementasi fitur ini memanfaatkan ```AnimatedSprite2D```. Ketika ```is_crouching``` bernilai True, maka jalankan animasi ```sprite.play("crouch")```.
   Kemudian secara physics, ```CollisionShape2D``` untuk karakter ketika sedang crouch akan menjadi lebih pendek (mengubah atribut ```collision.position.y```).
3. Climb
   Fitur climb memanfaatkan signal dari scene ```Ladder.tscn```. Ketika karakter masuk ke ```Area2D```, animasi karakter akan berubah ```sprite.play("climb")``` dan
   karakter dapat bergerak secara vertikal (selama karakter berada dalam area ```CollisionShape2D``` ladder),
4. Swim
   Ketika karakter masuk ke area water, signal body_entered memanggil fungsi ```enter_water()``` yang mengubah variabel ```is_in_water``` menjadi true,
   dan ```exit_water()``` menjadi false saat keluar. Selama ```is_in_water``` bernilai true, gravity dikurangi sehingga karakter tidak jatuh secepat di darat,
   dan input ui_up memungkinkan karakter bergerak ke atas (berenang).

Polishing:
- Menggunakan node bertipe ```AnimatedSprite2D``` untuk animasi aksi karakter dan animasi scene ```Water.tscn```.
- Menyesuaikan orientasi karakter secara otomatis dengan membalik sprite (flip_h) sesuai arah pergerakan kiri atau kanan.
- Mengatur ukuran CollisionShape2D secara dinamis pada kondisi tertentu (seperti crouch) untuk menjaga kesesuaian antara visual karakter dan physics.
- Menggunakan node Area2D pada objek interaktif (water dan ladder) untuk mendeteksi interaksi karakter secara efisien melalui signal body_entered dan body_exited.

Terdapat 2 node untuk karakter dalam folder (```Player.tscn``` dan ```Player_2.tscn```). Karakter ```Player.tscn``` menggunakan ```Sprite2D``` yang saya gunakan selama latihan tutorial,
sedangkan ```Player_2.tscn``` bertipe ```AnimatedSprite2D``` saya gunakan untuk mengerjakan tugas tutorial :)

Referensi:
- [Godot 4 Animated Sprite Tutorial | 2D & 3D](https://youtu.be/tfdXgiMwUBw?si=kEczKK-YwCqzqjHd)
- [Kenney Assets](https://kenney.nl/assets)
