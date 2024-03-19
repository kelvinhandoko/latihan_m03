import 'dart:io';

Future delayed(int seconds, Function callback) {
  return Future.delayed(Duration(seconds: seconds), callback());
}

class Kuliah {
  static final String _namaMahasiswa = "kelvin";
  static final int _jumlahTagihan = 1000000;

  static prosesPembayaran() async {
    await _checkRegistration();
    await _payment();
  }

  static Future<void> _checkRegistration() async {
    try {
      stdout.write('Masukkan nama anda: ');
      String nama = stdin.readLineSync()!;

      await delayed(2, () => print('sedang memeriksa pendaftaran...'));
      if (nama != _namaMahasiswa) {
        throw Exception('Nama tidak terdaftar');
      }
    } on Exception catch (e) {
      print(e);
      _tryAgain(() => _checkRegistration());
    }
  }

  static void _clearTerminal() {
    Platform.isMacOS
        ? print(Process.runSync("clear", [], runInShell: true).stdout)
        : print(Process.runSync('cmd', ['/c', 'cls'], runInShell: true).stdout);
  }

  static Future<void> _payment() async {
    try {
      stdout.write('Masukkan jumlah pembayaran: ');
      int jumlahPembayaran = int.parse(stdin.readLineSync()!);

      await delayed(2, () => print('Sedang memproses pembayaran...'));
      int sisaPembayaran = _jumlahTagihan - jumlahPembayaran;
      if (sisaPembayaran > 0) {
        throw Exception('Pembayaran kurang ${sisaPembayaran.toString()}');
      }

      if (sisaPembayaran < 0) {
        throw Exception('Pembayaran lebih ${sisaPembayaran.abs().toString()}');
      }

      print('Pembayaran sebesar Rp$_jumlahTagihan berhasil');
      print('Terima kasih dan selamat kuliah');
    } on FormatException {
      print("Jumlah pembayaran harus berupa angka");
      _tryAgain(() => _payment());
    } on Exception catch (e) {
      print(e);
      _tryAgain(() => _payment());
    }
  }

  static void _tryAgain(Function cb) {
    try {
      stdout.write('Coba lagi? (y/n): ');
      List<String> validAnswers = ['y', 'n'];
      String answer = stdin.readLineSync()!.toLowerCase();
      if (!validAnswers.contains(answer)) {
        throw FormatException("jawaban tidak valid (hanya y/n)");
      }
      if (answer == 'y') {
        _clearTerminal();
        cb();
      } else {
        print("Terima kasih");
        exit(0);
      }
    } on FormatException catch (e) {
      print(e);
      _tryAgain(cb);
    }
  }
}
