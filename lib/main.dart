import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Obsidian Seminar System',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF090A0C), 
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E293B),
          primary: const Color(0xFF16181C),     
          secondary: const Color(0xFF94A3B8),   
          background: const Color(0xFF090A0C),
        ),
        useMaterial3: true,
        fontFamily: 'Sans-Serif',
      ),
      debugShowCheckedModeBanner: false,
      home: const SeminarDashboardPage(),
    );
  }
}

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
              backgroundColor: const Color(0xFF16181C), 
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFF2E323A), width: 1),
              ),
              title: const Text(
                'Update Repository Data',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: editNamaCtrl, style: const TextStyle(color: Colors.white), decoration: _inputDecoration('Nama')),
                    const SizedBox(height: 12),
                    TextField(controller: editNimCtrl, style: const TextStyle(color: Colors.white), decoration: _inputDecoration('NIM'), keyboardType: TextInputType.number),
                    const SizedBox(height: 12),
                    TextField(controller: editJudulCtrl, style: const TextStyle(color: Colors.white), decoration: _inputDecoration('Judul'), maxLines: 2),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      dropdownColor: const Color(0xFF16181C),
                      value: editJenis,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Jenis'),
                      items: ['Proposal', 'Hasil', 'Skripsi'].map((j) => DropdownMenuItem(value: j, child: Text(j, style: const TextStyle(color: Colors.white)))).toList(),
                      onChanged: (val) => setDialogState(() => editJenis = val!),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      dropdownColor: const Color(0xFF16181C),
                      value: editStatus,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Status'),
                      items: ['Pending', 'Disetujui', 'Ditolak'].map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(color: Colors.white)))).toList(),
                      onChanged: (val) => setDialogState(() => editStatus = val!),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Color(0xFF94A3B8))),
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
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold)),
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
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth > 700 ? 650 : screenWidth;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: containerWidth,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CORE.WORKSPACE',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1.5),
                  ),
                  const Text(
                    'Sistem Log Kelayakan Seminar Mahasiswa',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.2),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSlimMetric('ALL DATA', '$totalPengajuan', Colors.white),
                      _buildSlimMetric('QUEUE', '$totalPending', const Color(0xFFF59E0B)),
                      _buildSlimMetric('VERIFIED', '$totalDisetujui', const Color(0xFF10B981)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF16181C), 
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF2E323A), width: 1), 
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'INPUT TERMINAL RECORD',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1),
                          ),
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: _namaController,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration('Nama Lengkap Mahasiswa'),
                            validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _nimController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: _inputDecoration('NIM'),
                                  keyboardType: TextInputType.number,
                                  validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  dropdownColor: const Color(0xFF16181C),
                                  value: _selectedJenisSeminar,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: _inputDecoration('Kategori'),
                                  items: ['Proposal', 'Hasil', 'Skripsi'].map((type) => DropdownMenuItem(value: type, child: Text(type, style: const TextStyle(color: Colors.white)))).toList(),
                                  onChanged: (val) => setState(() => _selectedJenisSeminar = val!),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _judulController,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration('Judul Penelitian / Proyek'),
                            maxLines: 2,
                            validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            height: 42,
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
                                backgroundColor: Colors.white, 
                                foregroundColor: Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('COMMIT NEW RECORD', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  const Text(
                    'REGISTRY BUFFER LOG',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 1),
                  ),
                  const SizedBox(height: 14),
                  
                  _listSeminar.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text('Empty database buffer.', style: TextStyle(color: Color(0xFF64748B))),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _listSeminar.length,
                          itemBuilder: (context, index) {
                            final seminar = _listSeminar[index];
                            return _buildFeedCard(seminar);
                          },
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeedCard(PengajuanSeminar seminar) {
    Color statusColor;
    Color statusBg;
    if (seminar.status == 'Disetujui') {
      statusColor = const Color(0xFF10B981);
      statusBg = const Color(0xFF10B981).withOpacity(0.12);
    } else if (seminar.status == 'Ditolak') {
      statusColor = const Color(0xFFEF4444);
      statusBg = const Color(0xFFEF4444).withOpacity(0.12);
    } else {
      statusColor = const Color(0xFFF59E0B);
      statusBg = const Color(0xFFF59E0B).withOpacity(0.12);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF16181C), 
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2E323A)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'UID-${seminar.id}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF475569), fontSize: 12, letterSpacing: 0.5),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E323A),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      seminar.jenisSeminar.toUpperCase(),
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFCBD5E1), letterSpacing: 0.5),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(4), 
                ),
                child: Text(
                  seminar.status.toUpperCase(),
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            seminar.namaMahasiswa,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.3),
          ),
          const SizedBox(height: 2),
          Text(
            'SYS_NIM // ${seminar.nim}',
            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontFamily: 'Courier'),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Divider(color: Color(0xFF2E323A), height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  seminar.judulPenelitian,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8), height: 1.4),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.tune_rounded, color: Colors.white, size: 20), 
                onPressed: () => _showEditSeminarDialog(seminar),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w500),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      filled: true,
      fillColor: const Color(0xFF090A0C), 
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF2E323A))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF2E323A))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white, width: 1.2)),
    );
  }

  Widget _buildSlimMetric(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF16181C),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2E323A)),
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
          const SizedBox(width: 10),
          // SEKARANG SUDAH AMAN (Menggunakan FontWeight.w900)
          Text(value, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: color)),
        ],
      ),
    );
  }
}