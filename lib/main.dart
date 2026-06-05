import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pendaftaran Seminar Estetik',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFF5F7), // Latar belakang pink susu super lembut
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFD1DC), // Soft Pastel Pink
          primary: const Color(0xFFFFB7CE),   // Pink muda utama yang cantik
          secondary: const Color(0xFFFFE3EC), // Pink pastel sangat muda
          background: const Color(0xFFFFF5F7),
        ),
        useMaterial3: true,
        fontFamily: 'Sans-Serif',
      ),
      debugShowCheckedModeBanner: false,
      home: const SeminarDashboardPage(),
    );
  }
}

// Model Data Pengajuan Seminar
class PengajuanSeminar {
  final int id;
  String namaMahasiswa;
  String nim;
  String jenisSeminar;
  String judulPenelitian;
  String status;

  PengajuanSeminar({
    required this.id,
    required this.namaMahasiswa,
    required this.nim,
    required this.jenisSeminar,
    required this.judulPenelitian,
    required this.status,
  });
}

class SeminarDashboardPage extends StatefulWidget {
  const SeminarDashboardPage({super.key});

  @override
  State<SeminarDashboardPage> createState() => _SeminarDashboardPageState();
}

class _SeminarDashboardPageState extends State<SeminarDashboardPage> {
  final List<PengajuanSeminar> _listSeminar = [
    PengajuanSeminar(
      id: 1, 
      namaMahasiswa: 'Rian Hidayat', 
      nim: '2201010041', 
      jenisSeminar: 'Proposal', 
      judulPenelitian: 'Implementasi Algoritma KNN untuk Klasifikasi Medis', 
      status: 'Disetujui'
    ),
    PengajuanSeminar(
      id: 2, 
      namaMahasiswa: 'Amalia Putri', 
      nim: '2201010085', 
      jenisSeminar: 'Skripsi', 
      judulPenelitian: 'Pengembangan Aplikasi Pelayanan Surat Berbasis Flutter', 
      status: 'Pending'
    ),
  ];

  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _nimController = TextEditingController();
  final _judulController = TextEditingController();
  String _selectedJenisSeminar = 'Proposal';

  int get totalPengajuan => _listSeminar.length;
  int get totalPending => _listSeminar.where((s) => s.status == 'Pending').length;
  int get totalDisetujui => _listSeminar.where((s) => s.status == 'Disetujui').length;

  // DIALOG EDIT DATA - POP UP CANTIK & FIX DROPDOWN STATE
  void _showEditSeminarDialog(PengajuanSeminar seminar) {
    final editNamaCtrl = TextEditingController(text: seminar.namaMahasiswa);
    final editNimCtrl = TextEditingController(text: seminar.nim);
    final editJudulCtrl = TextEditingController(text: seminar.judulPenelitian);
    String editJenis = seminar.jenisSeminar;
    String editStatus = seminar.status;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: Color(0xFFFFB7CE), size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Edit Data Pengajuan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6C5358)),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: editNamaCtrl,
                      decoration: _inputDecoration('Nama Mahasiswa'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: editNimCtrl,
                      decoration: _inputDecoration('NIM'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: editJudulCtrl,
                      decoration: _inputDecoration('Judul Penelitian'),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: editJenis,
                      decoration: _inputDecoration('Jenis Seminar'),
                      items: ['Proposal', 'Hasil', 'Skripsi'].map((j) => DropdownMenuItem(value: j, child: Text(j))).toList(),
                      onChanged: (val) => setDialogState(() => editJenis = val!),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: editStatus,
                      decoration: _inputDecoration('Status Kelayakan'),
                      items: ['Pending', 'Disetujui', 'Ditolak'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (val) => setDialogState(() => editStatus = val!),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal', style: TextStyle(color: Colors.black38, fontWeight: FontWeight.w600)),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      seminar.namaMahasiswa = editNamaCtrl.text;
                      seminar.nim = editNimCtrl.text;
                      seminar.judulPenelitian = editJudulCtrl.text;
                      seminar.jenisSeminar = editJenis;
                      seminar.status = editStatus;
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB7CE),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: const Text('Simpan', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.star_rounded, color: Color(0xFFFFB7CE)),
            const SizedBox(width: 8),
            const Text(
              'Seminar Hub',
              style: TextStyle(color: Color(0xFF5A464A), fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        shape: const Border(bottom: BorderSide(color: Color(0xFFFFE6EC), width: 2)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                bool isWide = constraints.maxWidth > 800;
                return Flex(
                  direction: isWide ? Axis.horizontal : Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // =========================================================
                    // FORM INPUT PUTIH BORDER SOFT PINK BULAT LUAR (KIRI)
                    // =========================================================
                    Expanded(
                      flex: isWide ? 2 : 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFE3EC).withOpacity(0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            )
                          ],
                          border: Border.all(color: const Color(0xFFFFE3EC), width: 1.5),
                        ),
                        padding: const EdgeInsets.all(28.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.favorite, color: Color(0xFFFFB7CE), size: 20),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Pendaftaran Baru',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF5A464A)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              TextFormField(
                                controller: _namaController,
                                decoration: _inputDecoration('Nama Lengkap Mahasiswa'),
                                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _nimController,
                                      decoration: _inputDecoration('NIM'),
                                      keyboardType: TextInputType.number,
                                      validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: _selectedJenisSeminar,
                                      decoration: _inputDecoration('Tipe Seminar'),
                                      items: ['Proposal', 'Hasil', 'Skripsi'].map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                                      onChanged: (val) => setState(() => _selectedJenisSeminar = val!),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _judulController,
                                decoration: _inputDecoration('Judul Penelitian'),
                                maxLines: 2,
                                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                              ),
                              const SizedBox(height: 28),
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        int nextId = _listSeminar.isEmpty ? 1 : _listSeminar.last.id + 1;
                                        _listSeminar.add(PengajuanSeminar(
                                          id: nextId,
                                          namaMahasiswa: _namaController.text,
                                          nim: _nimController.text,
                                          jenisSeminar: _selectedJenisSeminar,
                                          judulPenelitian: _judulController.text,
                                          status: 'Pending',
                                        ));
                                      });
                                      _namaController.clear();
                                      _nimController.clear();
                                      _judulController.clear();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFFB7CE),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    shadowColor: const Color(0xFFFFB7CE).withOpacity(0.5),
                                  ),
                                  child: const Text('Kirim Pengajuan ✨', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 28, height: 28),
                    // =========================================================
                    // RINGKASAN STATUS MERAH MUDA ESTETIK (KANAN)
                    // =========================================================
                    Expanded(
                      flex: isWide ? 1 : 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFE3EC).withOpacity(0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            )
                          ],
                          border: Border.all(color: const Color(0xFFFFE3EC), width: 1.5),
                        ),
                        padding: const EdgeInsets.all(28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.analytics_outlined, color: Color(0xFFFFB7CE), size: 20),
                                const SizedBox(width: 8),
                                const Text(
                                  'Statistik',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF5A464A)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildSimpleMetric('Total Masuk', '$totalPengajuan', const Color(0xFF5A464A), const Color(0xFFFFE3EC)),
                            _buildSimpleMetric('Menunggu', '$totalPending', const Color(0xFFDCA134), const Color(0xFFFFF6E5)),
                            _buildSimpleMetric('Disetujui', '$totalDisetujui', const Color(0xFF5BB27A), const Color(0xFFEBF7EE)),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 36),
            // =============================================================
            // TABEL DATA MINIMALIS SANGAT BULAT & ESTETIK (BAWAH)
            // =============================================================
            Row(
              children: [
                const Icon(Icons.list_alt_rounded, color: Color(0xFFFFB7CE), size: 22),
                const SizedBox(width: 8),
                const Text(
                  'Log Pengajuan Terbaru',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF5A464A)),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFFFE3EC), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFE3EC).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(const Color(0xFFFFF0F3)),
                    headingTextStyle: const TextStyle(color: Color(0xFF7A5F64), fontWeight: FontWeight.bold, fontSize: 13),
                    dataTextStyle: const TextStyle(color: Color(0xFF4A3B3D), fontSize: 13),
                    horizontalMargin: 24,
                    columnSpacing: 34,
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Nama Lengkap')),
                      DataColumn(label: Text('NIM')),
                      DataColumn(label: Text('Kategori')),
                      DataColumn(label: Text('Judul Penelitian')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Aksi')),
                    ],
                    rows: _listSeminar.map((seminar) {
                      return DataRow(cells: [
                        DataCell(Text('#${seminar.id}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFB7CE)))),
                        DataCell(Text(seminar.namaMahasiswa, style: const TextStyle(fontWeight: FontWeight.w500))),
                        DataCell(Text(seminar.nim)),
                        DataCell(Text(seminar.jenisSeminar)),
                        DataCell(Text(seminar.judulPenelitian)),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: seminar.status == 'Disetujui' 
                                  ? const Color(0xFFEBF7EE) 
                                  : (seminar.status == 'Ditolak' ? const Color(0xFFFDF0F0) : const Color(0xFFFFF6E5)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              seminar.status,
                              style: TextStyle(
                                color: seminar.status == 'Disetujui' 
                                      ? const Color(0xFF388E3C) 
                                      : (seminar.status == 'Ditolak' ? const Color(0xFFD32F2F) : const Color(0xFFF57C00)), 
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.favorite_border, color: Color(0xFFFFB7CE), size: 20),
                            onPressed: () => _showEditSeminarDialog(seminar),
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF8A7175), fontSize: 13, fontWeight: FontWeight.w500),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      filled: true,
      fillColor: const Color(0xFFFFFBFB),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFFFE3EC))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFFFE3EC), width: 1.2)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFFFB7CE), width: 1.8)),
    );
  }

  Widget _buildSimpleMetric(String label, String value, Color textColor, Color badgeColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF5A464A), fontSize: 14, fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textColor)),
        ],
      ),
    );
  }
}