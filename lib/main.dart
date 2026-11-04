import 'package:flutter/material.dart';

void main() => runApp(const HospitalApp());

const navy = Color(0xFF183B56);
const teal = Color(0xFF159A91);
const pale = Color(0xFFEAF7F5);
const ink = Color(0xFF243746);
const muted = Color(0xFF718096);

class HospitalApp extends StatelessWidget {
  const HospitalApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Sehatin',
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF7FAFC),
      colorScheme: ColorScheme.fromSeed(
        seedColor: teal,
        primary: teal,
        surface: Colors.white,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF7FAFC),
        foregroundColor: navy,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF7FAFC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE5EDF2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE5EDF2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: teal, width: 1.5),
        ),
      ),
    ),
    home: const AppShell(),
  );
}

class Doctor {
  final String name, specialty, days, hours, initials;
  final Color color;
  const Doctor(
    this.name,
    this.specialty,
    this.days,
    this.hours,
    this.initials,
    this.color,
  );
}

const doctors = <Doctor>[
  Doctor(
    'dr. Aditya Pratama, Sp.PD',
    'Penyakit Dalam',
    'Senin, Rabu, Jumat',
    '08.00 - 12.00',
    'AP',
    Color(0xFFDCEFEB),
  ),
  Doctor(
    'dr. Maya Putri, Sp.A',
    'Anak',
    'Senin - Kamis',
    '09.00 - 13.00',
    'MP',
    Color(0xFFFFE9D8),
  ),
  Doctor(
    'dr. Rizky Ananda, Sp.JP',
    'Jantung',
    'Selasa, Kamis, Sabtu',
    '08.00 - 11.00',
    'RA',
    Color(0xFFE8E5FA),
  ),
  Doctor(
    'dr. Nadia Permata, Sp.M',
    'Mata',
    'Senin, Rabu, Jumat',
    '10.00 - 14.00',
    'NP',
    Color(0xFFFFE5EB),
  ),
  Doctor(
    'dr. Bima Saputra, Sp.OG',
    'Kebidanan',
    'Selasa - Sabtu',
    '08.00 - 12.00',
    'BS',
    Color(0xFFE1EDFF),
  ),
  Doctor(
    'dr. Citra Lestari, Sp.THT',
    'THT',
    'Senin - Rabu',
    '13.00 - 16.00',
    'CL',
    Color(0xFFFFF0D5),
  ),
  Doctor(
    'dr. Fajar Nugroho, Sp.B',
    'Bedah Umum',
    'Senin, Kamis, Jumat',
    '09.00 - 12.00',
    'FN',
    Color(0xFFE2F2E4),
  ),
  Doctor(
    'dr. Sinta Maharani, Sp.KK',
    'Kulit & Kelamin',
    'Rabu - Sabtu',
    '10.00 - 13.00',
    'SM',
    Color(0xFFFCE4F0),
  ),
];
const departments = [
  'Semua',
  'Penyakit Dalam',
  'Anak',
  'Jantung',
  'Mata',
  'Kebidanan',
  'THT',
  'Bedah Umum',
  'Kulit & Kelamin',
];

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int tab = 0;
  String? scheduleDepartment;
  Map<String, String>? latestTicket;
  void setTicket(Map<String, String> ticket) =>
      setState(() => latestTicket = ticket);
  @override
  Widget build(BuildContext context) {
    void openSchedule([String? department]) {
      setState(() {
        tab = 1;
        scheduleDepartment = department;
      });
    }

    final pages = [
      HomePage(
        onRegister: () => setState(() => tab = 2),
        onSchedule: () => openSchedule(),
        onDepartmentSelected: openSchedule,
        onProfile: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => ProfilePage(
              onRegister: () {
                Navigator.of(context).pop();
                setState(() => tab = 2);
              },
            ),
          ),
        ),
        ticket: latestTicket,
      ),
      SchedulePage(
        key: ValueKey(scheduleDepartment),
        initialDepartment: scheduleDepartment,
        onBack: () => setState(() => tab = 0),
      ),
      RegistrationLanding(
        onCreated: (t) {
          setTicket(t);
          setState(() => tab = 0);
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => TicketPage(ticket: t)));
        },
      ),
    ];
    return PopScope<Object?>(
      canPop: tab == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && tab != 0) setState(() => tab = 0);
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: SizedBox.expand(
                child: IndexedStack(index: tab, children: pages),
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: NavigationBar(
            height: 68,
            selectedIndex: tab,
            onDestinationSelected: (v) => setState(() => tab = v),
            backgroundColor: Colors.white,
            indicatorColor: pale,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Beranda',
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_month_outlined),
                selectedIcon: Icon(Icons.calendar_month_rounded),
                label: 'Jadwal Dokter',
              ),
              NavigationDestination(
                icon: Icon(Icons.confirmation_num_outlined),
                selectedIcon: Icon(Icons.confirmation_num_rounded),
                label: 'Registrasi',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final VoidCallback onRegister, onSchedule;
  final ValueChanged<String> onDepartmentSelected;
  final VoidCallback onProfile;
  final Map<String, String>? ticket;
  const HomePage({
    super.key,
    required this.onRegister,
    required this.onSchedule,
    required this.onDepartmentSelected,
    required this.onProfile,
    this.ticket,
  });
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
    children: [
      Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: pale,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.health_and_safety_rounded,
              color: teal,
              size: 27,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sehatin',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: navy,
                  ),
                ),
                Text(
                  'LAYANAN KESEHATAN DIGITAL',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9,
                    letterSpacing: 1.1,
                    color: muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _info(context),
            tooltip: 'Notifikasi',
            icon: const Icon(Icons.notifications_none_rounded, color: navy),
          ),
          IconButton(
            onPressed: onProfile,
            tooltip: 'Profil pasien',
            icon: const CircleAvatar(
              backgroundColor: Color(0xFFE5EEF4),
              child: Icon(Icons.person_outline, color: navy),
            ),
          ),
        ],
      ),
      const SizedBox(height: 22),
      Container(
        padding: const EdgeInsets.all(21),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF174D64), Color(0xFF159A91)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SELAMAT DATANG 👋',
              style: TextStyle(
                color: Color(0xFFBFEAE3),
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 9),
            const Text(
              'Sehat dimulai dari\nlangkah yang mudah.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                height: 1.2,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Daftar kunjungan dan temukan dokter pilihanmu tanpa antre di loket.',
              style: TextStyle(
                color: Colors.white70,
                height: 1.45,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onRegister,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: navy,
                padding: const EdgeInsets.symmetric(
                  horizontal: 17,
                  vertical: 13,
                ),
              ),
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: const Text(
                'Daftar Berobat',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 22),
      if (ticket != null) ...[
        Row(
          children: [
            const Text(
              'Pendaftaran Terakhir',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: navy,
              ),
            ),
            const Spacer(),
            TextButton(onPressed: onRegister, child: const Text('Daftar lagi')),
          ],
        ),
        TicketMini(ticket: ticket!),
        const SizedBox(height: 20),
      ],
      Row(
        children: [
          const Expanded(
            child: Text(
              'Layanan Utama',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: navy,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Pilih layanan',
            style: TextStyle(fontSize: 11, color: muted),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: ServiceTile(
              icon: Icons.calendar_month_rounded,
              title: 'Jadwal Dokter',
              subtitle: 'Cari dokter & poli',
              color: const Color(0xFFE5F3FF),
              onTap: onSchedule,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ServiceTile(
              icon: Icons.confirmation_num_rounded,
              title: 'Ambil Antrean',
              subtitle: 'Daftar kunjungan',
              color: const Color(0xFFE2F5F0),
              onTap: onRegister,
            ),
          ),
        ],
      ),
      const SizedBox(height: 23),
      Row(
        children: [
          const Expanded(
            child: Text(
              'Poliklinik',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: navy,
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(onPressed: onSchedule, child: const Text('Lihat semua')),
        ],
      ),
      const SizedBox(height: 5),
      Wrap(
        spacing: 9,
        runSpacing: 9,
        children: [
          _PoliChip(
            'Penyakit Dalam',
            Icons.monitor_heart_outlined,
            onTap: () => onDepartmentSelected('Penyakit Dalam'),
          ),
          _PoliChip(
            'Anak',
            Icons.child_care_rounded,
            onTap: () => onDepartmentSelected('Anak'),
          ),
          _PoliChip(
            'Jantung',
            Icons.favorite_border_rounded,
            onTap: () => onDepartmentSelected('Jantung'),
          ),
          _PoliChip(
            'Mata',
            Icons.remove_red_eye_outlined,
            onTap: () => onDepartmentSelected('Mata'),
          ),
          _PoliChip(
            'Kebidanan',
            Icons.pregnant_woman_rounded,
            onTap: () => onDepartmentSelected('Kebidanan'),
          ),
          _PoliChip(
            'THT',
            Icons.hearing_rounded,
            onTap: () => onDepartmentSelected('THT'),
          ),
        ],
      ),
      const SizedBox(height: 22),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFEAF0F4)),
        ),
        child: const Row(
          children: [
            Icon(Icons.info_outline_rounded, color: teal),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informasi Pasien',
                    style: TextStyle(fontWeight: FontWeight.w700, color: navy),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Siapkan KTP dan kartu BPJS (jika menggunakan BPJS) sebelum melakukan pendaftaran.',
                    style: TextStyle(fontSize: 11, height: 1.4, color: muted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 18),
      const Center(
        child: Text(
          'Sehatin • Demo Aplikasi Registrasi Rumah Sakit',
          style: TextStyle(color: Color(0xFF9AA8B4), fontSize: 10),
        ),
      ),
    ],
  );
  static void _info(BuildContext c) => showDialog(
    context: c,
    builder: (_) => AlertDialog(
      title: const Text('Notifikasi'),
      content: const Text('Belum ada notifikasi baru.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c),
          child: const Text('Tutup'),
        ),
      ],
    ),
  );
}

class ServiceTile extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final Color color;
  final VoidCallback onTap;
  const ServiceTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(18),
    child: Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEAF0F4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: teal),
          ),
          const SizedBox(height: 13),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w800, color: navy),
          ),
          const SizedBox(height: 3),
          Text(subtitle, style: const TextStyle(fontSize: 11, color: muted)),
        ],
      ),
    ),
  );
}

class ProfilePage extends StatelessWidget {
  final VoidCallback onRegister;
  const ProfilePage({super.key, required this.onRegister});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Profil Pasien')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFEAF0F4)),
          ),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 34,
                backgroundColor: pale,
                child: Icon(Icons.person_outline, color: teal, size: 36),
              ),
              const SizedBox(height: 14),
              const Text(
                'Data profil belum tersedia',
                style: TextStyle(
                  color: navy,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                'Lengkapi pendaftaran pasien untuk mengisi profil Anda.',
                textAlign: TextAlign.center,
                style: TextStyle(color: muted, fontSize: 12, height: 1.5),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: onRegister,
                icon: const Icon(Icons.assignment_ind_outlined),
                label: const Text('Daftar sebagai pasien'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _PoliChip extends StatelessWidget {
  final String name;
  final IconData icon;
  final VoidCallback onTap;
  const _PoliChip(this.name, this.icon, {required this.onTap});
  @override
  Widget build(BuildContext context) => ActionChip(
    onPressed: onTap,
    avatar: Icon(icon, size: 15, color: teal),
    label: Text(
      name,
      style: const TextStyle(
        fontSize: 11,
        color: ink,
        fontWeight: FontWeight.w600,
      ),
    ),
    backgroundColor: Colors.white,
    side: const BorderSide(color: Color(0xFFE7EEF2)),
    shape: const StadiumBorder(),
  );
}

class SchedulePage extends StatefulWidget {
  final String? initialDepartment;
  final VoidCallback onBack;
  const SchedulePage({super.key, this.initialDepartment, required this.onBack});
  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late String filter;
  String query = '';
  @override
  void initState() {
    super.initState();
    filter = widget.initialDepartment ?? 'Semua';
  }

  @override
  Widget build(BuildContext context) {
    final filtered = doctors
        .where(
          (d) =>
              (filter == 'Semua' || d.specialty == filter) &&
              ('${d.name} ${d.specialty}'.toLowerCase().contains(
                query.toLowerCase(),
              )),
        )
        .toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
      children: [
        Row(
          children: [
            IconButton(
              onPressed: widget.onBack,
              tooltip: 'Kembali ke beranda',
              icon: const Icon(Icons.arrow_back_rounded),
            ),
            const Expanded(
              child: Text(
                'Jadwal Dokter',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: navy,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        const Text(
          'Temukan dokter dan jadwal praktik yang sesuai.',
          style: TextStyle(color: muted, fontSize: 12),
        ),
        const SizedBox(height: 18),
        TextField(
          onChanged: (v) => setState(() => query = v),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search_rounded),
            hintText: 'Cari nama dokter atau spesialisasi',
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 38,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: departments
                .map(
                  (d) => Padding(
                    padding: const EdgeInsets.only(right: 7),
                    child: ChoiceChip(
                      label: Text(d),
                      selected: filter == d,
                      onSelected: (_) => setState(() => filter = d),
                      selectedColor: pale,
                      labelStyle: TextStyle(
                        color: filter == d ? teal : muted,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                      side: BorderSide(
                        color: filter == d ? teal : const Color(0xFFE5EDF2),
                      ),
                      backgroundColor: Colors.white,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Text(
              '${filtered.length} dokter tersedia',
              style: const TextStyle(color: muted, fontSize: 11),
            ),
            const Spacer(),
            const Icon(Icons.access_time_rounded, size: 14, color: muted),
            const SizedBox(width: 4),
            const Text(
              'Jadwal dapat berubah',
              style: TextStyle(color: muted, fontSize: 10),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (filtered.isEmpty)
          const Padding(
            padding: EdgeInsets.all(30),
            child: Center(child: Text('Dokter tidak ditemukan.')),
          ),
        ...filtered.map((d) => DoctorCard(doctor: d)),
      ],
    );
  }
}

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  const DoctorCard({super.key, required this.doctor});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 11),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFEAF0F4)),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: doctor.color,
          child: Text(
            doctor.initials,
            style: const TextStyle(color: navy, fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doctor.name,
                style: const TextStyle(
                  color: navy,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                doctor.specialty,
                style: const TextStyle(
                  color: teal,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 7),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 12,
                    color: muted,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      doctor.days,
                      style: const TextStyle(fontSize: 10, color: muted),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 12, color: muted),
                  const SizedBox(width: 5),
                  Text(
                    doctor.hours,
                    style: const TextStyle(fontSize: 10, color: muted),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 5),
        const Icon(Icons.chevron_right_rounded, color: muted),
      ],
    ),
  );
}

class RegistrationLanding extends StatelessWidget {
  final ValueChanged<Map<String, String>> onCreated;
  const RegistrationLanding({super.key, required this.onCreated});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
    children: [
      const Text(
        'Registrasi Pasien',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w800,
          color: navy,
        ),
      ),
      const SizedBox(height: 5),
      const Text(
        'Pilih jenis pasien untuk memulai pendaftaran.',
        style: TextStyle(fontSize: 12, color: muted),
      ),
      const SizedBox(height: 22),
      _PatientTypeCard(
        icon: Icons.person_search_rounded,
        color: const Color(0xFFE1F3EE),
        title: 'Pasien Lama',
        subtitle: 'Sudah pernah berobat dan memiliki nomor rekam medis.',
        bullets: const [
          'Masukkan nomor rekam medis',
          'Data pasien ditampilkan kembali',
          'Pilih poli dan jadwal kunjungan',
        ],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                RegistrationFlow(isNew: false, onCreated: onCreated),
          ),
        ),
      ),
      const SizedBox(height: 14),
      _PatientTypeCard(
        icon: Icons.person_add_alt_1_rounded,
        color: const Color(0xFFE6F0FF),
        title: 'Pasien Baru',
        subtitle: 'Belum pernah berobat atau belum memiliki nomor rekam medis.',
        bullets: const [
          'Lengkapi identitas diri',
          'Pilih metode pembayaran',
          'Pilih poli dan jadwal kunjungan',
        ],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RegistrationFlow(isNew: true, onCreated: onCreated),
          ),
        ),
      ),
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E9),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.lightbulb_outline_rounded, color: Color(0xFFB98223)),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Pastikan data yang dimasukkan sesuai dengan identitas. Untuk pasien BPJS, siapkan kartu BPJS dan surat rujukan jika diperlukan.',
                style: TextStyle(
                  fontSize: 11,
                  height: 1.5,
                  color: Color(0xFF80652F),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _PatientTypeCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title, subtitle;
  final List<String> bullets;
  final VoidCallback onTap;
  const _PatientTypeCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.bullets,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(20),
    child: Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE7EEF2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: navy, size: 25),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_rounded, color: teal),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              color: navy,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: muted, height: 1.4),
          ),
          const SizedBox(height: 13),
          ...bullets.map(
            (b) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, size: 14, color: teal),
                  const SizedBox(width: 7),
                  Text(b, style: const TextStyle(fontSize: 11, color: ink)),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class RegistrationFlow extends StatefulWidget {
  final bool isNew;
  final ValueChanged<Map<String, String>> onCreated;
  const RegistrationFlow({
    super.key,
    required this.isNew,
    required this.onCreated,
  });
  @override
  State<RegistrationFlow> createState() => _RegistrationFlowState();
}

class _RegistrationFlowState extends State<RegistrationFlow> {
  final _form = GlobalKey<FormState>();
  final Map<String, TextEditingController> fields = {
    for (final k in [
      'rm',
      'nik',
      'name',
      'birth',
      'phone',
      'address',
      'bpjs',
      'referral',
    ])
      k: TextEditingController(),
  };
  String payment = 'Umum',
      poli = 'Penyakit Dalam',
      doctor = doctors.first.name,
      date = 'Kamis, 5 November 2026',
      session = 'Pagi (08.00 - 12.00)';
  int step = 0;
  @override
  void dispose() {
    for (final c in fields.values) {
      c.dispose();
    }
    super.dispose();
  }

  Doctor get selectedDoctor =>
      doctors.firstWhere((d) => d.name == doctor, orElse: () => doctors.first);
  List<Doctor> get availableDoctors =>
      doctors.where((d) => d.specialty == poli).toList();
  void next() {
    if (step == 0 && !_form.currentState!.validate()) return;
    if (step == 2 && availableDoctors.isEmpty) return;
    if (step < 3) {
      setState(() => step++);
    } else {
      final ticket = <String, String>{
        'number':
            'A-${(100 + DateTime.now().millisecondsSinceEpoch % 899).toString()}',
        'name': widget.isNew ? fields['name']!.text : 'Budi Santoso',
        'type': widget.isNew ? 'Pasien Baru' : 'Pasien Lama',
        'poli': poli,
        'doctor': doctor,
        'date': date,
        'session': session,
        'payment': payment,
        'rm': widget.isNew
            ? 'RM-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}'
            : fields['rm']!.text,
      };
      widget.onCreated(ticket);
    }
  }

  @override
  Widget build(BuildContext context) => PopScope<Object?>(
    canPop: step == 0,
    onPopInvokedWithResult: (didPop, _) {
      if (!didPop && step > 0) setState(() => step--);
    },
    child: Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isNew ? 'Registrasi Pasien Baru' : 'Registrasi Pasien Lama',
        ),
        leading: BackButton(
          onPressed: () {
            if (step > 0) {
              setState(() => step--);
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 17),
            child: Column(
              children: [
                Row(
                  children: List.generate(
                    4,
                    (i) => Expanded(
                      child: Container(
                        height: 5,
                        margin: EdgeInsets.only(right: i == 3 ? 0 : 6),
                        decoration: BoxDecoration(
                          color: i <= step ? teal : const Color(0xFFE4EBEF),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    Text(
                      'Langkah ${step + 1} dari 4',
                      style: const TextStyle(fontSize: 10, color: muted),
                    ),
                    const Spacer(),
                    Text(
                      [
                        'Data Pasien',
                        'Pembayaran',
                        'Jadwal Kunjungan',
                        'Konfirmasi',
                      ][step],
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: teal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Form(
              key: _form,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                children: [
                  if (step == 0)
                    _patientForm()
                  else if (step == 1)
                    _paymentForm()
                  else if (step == 2)
                    _scheduleForm()
                  else
                    _confirmation(),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFEDF1F4))),
            ),
            child: Row(
              children: [
                if (step > 0)
                  OutlinedButton(
                    onPressed: () => setState(() => step--),
                    child: const Text('Kembali'),
                  ),
                if (step > 0) const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: next,
                    style: FilledButton.styleFrom(
                      backgroundColor: teal,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(
                      step == 3 ? 'Konfirmasi & Ambil Antrean' : 'Lanjutkan',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  Widget _heading(String title, String subtitle) => Padding(
    padding: const EdgeInsets.only(bottom: 17),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: navy,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: muted, height: 1.4),
        ),
      ],
    ),
  );
  Widget _field(
    String key,
    String label,
    String hint, {
    TextInputType type = TextInputType.text,
    bool required = true,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 13),
    child: TextFormField(
      controller: fields[key],
      keyboardType: type,
      validator: (v) => required && (v == null || v.trim().isEmpty)
          ? '$label wajib diisi'
          : null,
      decoration: InputDecoration(labelText: label, hintText: hint),
    ),
  );
  Widget _patientForm() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _heading(
        'Data Identitas Pasien',
        widget.isNew
            ? 'Lengkapi identitas untuk membuat data pasien baru.'
            : 'Masukkan data untuk menemukan identitas pasien yang sudah terdaftar.',
      ),
      if (!widget.isNew) ...[
        _field('rm', 'Nomor Rekam Medis', 'Contoh: 00012345'),
        _field('birth', 'Tanggal Lahir', 'DD/MM/YYYY'),
      ] else ...[
        _field(
          'nik',
          'NIK',
          '16 digit nomor induk kependudukan',
          type: TextInputType.number,
        ),
        _field('name', 'Nama Lengkap', 'Sesuai KTP'),
        _field('birth', 'Tanggal Lahir', 'DD/MM/YYYY'),
        _field('phone', 'Nomor HP', '08xxxxxxxxxx', type: TextInputType.phone),
        _field('address', 'Alamat Domisili', 'Nama jalan, kelurahan, kota'),
      ],
      if (!widget.isNew)
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: pale,
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Row(
            children: [
              Icon(Icons.verified_user_outlined, color: teal),
              SizedBox(width: 9),
              Expanded(
                child: Text(
                  'Demo: gunakan nomor rekam medis apa saja dan tanggal lahir bebas.',
                  style: TextStyle(fontSize: 10, color: navy),
                ),
              ),
            ],
          ),
        ),
    ],
  );
  Widget _paymentForm() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _heading(
        'Metode Pembayaran',
        'Pilih metode pembayaran yang akan digunakan saat kunjungan.',
      ),
      _paymentChoice(
        'Umum',
        'Pembayaran mandiri di rumah sakit',
        Icons.payments_outlined,
      ),
      const SizedBox(height: 10),
      _paymentChoice(
        'BPJS',
        'Menggunakan kepesertaan BPJS Kesehatan',
        Icons.health_and_safety_outlined,
      ),
      if (payment == 'BPJS') ...[
        const SizedBox(height: 18),
        _field(
          'bpjs',
          'Nomor Kartu BPJS',
          'Masukkan nomor kartu BPJS',
          type: TextInputType.number,
        ),
        _field(
          'referral',
          'Nomor Rujukan',
          'Masukkan nomor rujukan (jika diperlukan)',
          required: false,
        ),
      ],
      const SizedBox(height: 10),
      const Text(
        'Catatan: kelayakan layanan dan rujukan BPJS tidak divalidasi dalam demo ini.',
        style: TextStyle(fontSize: 10, color: muted, height: 1.4),
      ),
    ],
  );
  Widget _paymentChoice(String value, String desc, IconData icon) => InkWell(
    onTap: () => setState(() => payment = value),
    child: Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: payment == value ? pale : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: payment == value ? teal : const Color(0xFFE5EDF2),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: teal, size: 25),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: navy,
                  ),
                ),
                const SizedBox(height: 3),
                Text(desc, style: const TextStyle(fontSize: 10, color: muted)),
              ],
            ),
          ),
          Icon(
            payment == value
                ? Icons.radio_button_checked
                : Icons.radio_button_off,
            color: teal,
          ),
        ],
      ),
    ),
  );
  Widget _scheduleForm() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _heading(
        'Pilih Jadwal Kunjungan',
        'Tentukan poliklinik, dokter, tanggal, dan sesi praktik.',
      ),
      const Text(
        'Poliklinik',
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ink),
      ),
      const SizedBox(height: 7),
      DropdownButtonFormField<String>(
        value: poli,
        isExpanded: true,
        decoration: const InputDecoration(),
        items: departments
            .skip(1)
            .map(
              (d) => DropdownMenuItem(
                value: d,
                child: Text(d, style: const TextStyle(fontSize: 12)),
              ),
            )
            .toList(),
        onChanged: (v) => setState(() {
          poli = v!;
          doctor = availableDoctors.first.name;
        }),
      ),
      const SizedBox(height: 15),
      const Text(
        'Dokter',
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ink),
      ),
      const SizedBox(height: 7),
      DropdownButtonFormField<String>(
        value: availableDoctors.any((d) => d.name == doctor)
            ? doctor
            : availableDoctors.first.name,
        isExpanded: true,
        decoration: const InputDecoration(),
        items: availableDoctors
            .map(
              (d) => DropdownMenuItem(
                value: d.name,
                child: Text(
                  d.name,
                  style: const TextStyle(fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),
        onChanged: (v) => setState(() => doctor = v!),
      ),
      const SizedBox(height: 15),
      const Text(
        'Tanggal Kunjungan',
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ink),
      ),
      const SizedBox(height: 7),
      DropdownButtonFormField<String>(
        value: date,
        isExpanded: true,
        decoration: const InputDecoration(),
        items:
            [
                  'Kamis, 5 November 2026',
                  'Jumat, 6 November 2026',
                  'Sabtu, 7 November 2026',
                  'Senin, 9 November 2026',
                ]
                .map(
                  (d) => DropdownMenuItem(
                    value: d,
                    child: Text(d, style: const TextStyle(fontSize: 11)),
                  ),
                )
                .toList(),
        onChanged: (v) => setState(() => date = v!),
      ),
      const SizedBox(height: 15),
      const Text(
        'Sesi Praktik',
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ink),
      ),
      const SizedBox(height: 7),
      ...['Pagi (08.00 - 12.00)', 'Siang (13.00 - 16.00)'].map(
        (s) => RadioListTile<String>(
          contentPadding: EdgeInsets.zero,
          dense: true,
          activeColor: teal,
          value: s,
          groupValue: session,
          onChanged: (v) => setState(() => session = v!),
          title: Text(s, style: const TextStyle(fontSize: 11)),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Jadwal dan kuota di atas merupakan data simulasi, bukan jadwal operasional rumah sakit.',
          style: TextStyle(fontSize: 10, color: Color(0xFF80652F)),
        ),
      ),
    ],
  );
  Widget _confirmation() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _heading(
        'Periksa Pendaftaran',
        'Pastikan informasi berikut sudah benar sebelum mengambil nomor antrean.',
      ),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: const Color(0xFFE8EEF2)),
        ),
        child: Column(
          children: [
            _summaryRow(
              'Jenis pasien',
              widget.isNew ? 'Pasien Baru' : 'Pasien Lama',
            ),
            _summaryRow(
              'Nama pasien',
              widget.isNew ? fields['name']!.text : 'Budi Santoso',
            ),
            _summaryRow(
              'Rekam medis',
              widget.isNew ? 'Akan dibuat otomatis' : fields['rm']!.text,
            ),
            _summaryRow('Pembayaran', payment),
            const Divider(height: 22),
            _summaryRow('Poliklinik', poli),
            _summaryRow('Dokter', doctor),
            _summaryRow('Tanggal', date),
            _summaryRow('Sesi', session),
          ],
        ),
      ),
      const SizedBox(height: 14),
      const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: teal, size: 18),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Dengan menekan tombol konfirmasi, sistem demo akan membuat nomor antrean dan tiket kunjungan simulasi.',
              style: TextStyle(fontSize: 10, color: muted, height: 1.5),
            ),
          ),
        ],
      ),
    ],
  );
  Widget _summaryRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 105,
          child: Text(
            label,
            style: const TextStyle(fontSize: 10, color: muted),
          ),
        ),
        const Text(': ', style: TextStyle(fontSize: 10, color: muted)),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 10,
              color: navy,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );
}

class TicketPage extends StatelessWidget {
  final Map<String, String> ticket;
  const TicketPage({super.key, required this.ticket});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('E-Tiket Antrean'),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
          icon: const Icon(Icons.close),
        ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
      children: [
        Container(
          padding: const EdgeInsets.all(21),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE6EEF1)),
          ),
          child: Column(
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: const BoxDecoration(
                  color: pale,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: teal, size: 32),
              ),
              const SizedBox(height: 12),
              const Text(
                'Pendaftaran Berhasil!',
                style: TextStyle(
                  fontSize: 20,
                  color: navy,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Simpan tiket ini sebagai bukti pendaftaran.',
                style: TextStyle(color: muted, fontSize: 11),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: pale,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      'NOMOR ANTREAN',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 1.3,
                        color: teal,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      ticket['number']!,
                      style: const TextStyle(
                        fontSize: 39,
                        color: navy,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ticket['poli']!,
                      style: const TextStyle(color: muted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _ticketRow('Nama pasien', ticket['name']!),
              _ticketRow('Jenis pasien', ticket['type']!),
              _ticketRow('No. rekam medis', ticket['rm']!),
              _ticketRow('Dokter', ticket['doctor']!),
              _ticketRow('Tanggal', ticket['date']!),
              _ticketRow('Sesi', ticket['session']!),
              _ticketRow('Pembayaran', ticket['payment']!),
              const Divider(height: 25),
              Container(
                width: 125,
                height: 125,
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE5EDF2)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const CustomPaint(painter: FakeQrPainter()),
              ),
              const SizedBox(height: 8),
              const Text(
                'QR CODE SIMULASI',
                style: TextStyle(
                  fontSize: 9,
                  color: muted,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E9),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.access_time, color: Color(0xFFB98223)),
              SizedBox(width: 9),
              Expanded(
                child: Text(
                  'Datang 30 menit sebelum jadwal pelayanan dan tunjukkan tiket kepada petugas pendaftaran. Nomor antrean ini hanya berlaku untuk simulasi.',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF80652F),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        FilledButton.icon(
          onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
          icon: const Icon(Icons.home_outlined),
          label: const Text('Kembali ke Beranda'),
          style: FilledButton.styleFrom(
            backgroundColor: teal,
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ],
    ),
  );
  Widget _ticketRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 10, color: muted),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 10,
              color: navy,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );
}

class TicketMini extends StatelessWidget {
  final Map<String, String> ticket;
  const TicketMini({super.key, required this.ticket});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFE7EEF2)),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: pale,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.confirmation_num_outlined, color: teal),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ticket['number']!,
                style: const TextStyle(
                  fontSize: 17,
                  color: navy,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                '${ticket['poli']} • ${ticket['date']}',
                style: const TextStyle(fontSize: 10, color: muted),
              ),
            ],
          ),
        ),
        const Icon(Icons.check_circle, color: teal),
      ],
    ),
  );
}

class FakeQrPainter extends CustomPainter {
  const FakeQrPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = navy;
    const n = 21;
    final cell = size.width / n;
    for (int y = 0; y < n; y++) {
      for (int x = 0; x < n; x++) {
        bool finder(int ox, int oy) {
          final dx = x - ox, dy = y - oy;
          if (dx < 0 || dx > 6 || dy < 0 || dy > 6) return false;
          return dx == 0 ||
              dx == 6 ||
              dy == 0 ||
              dy == 6 ||
              (dx >= 2 && dx <= 4 && dy >= 2 && dy <= 4);
        }

        final inFinder =
            (x < 7 && y < 7) || (x >= 14 && y < 7) || (x < 7 && y >= 14);
        final dark =
            finder(0, 0) ||
            finder(14, 0) ||
            finder(0, 14) ||
            (!inFinder && ((x * 7 + y * 11 + x * y) % 5 < 2));
        if (dark)
          canvas.drawRect(
            Rect.fromLTWH(x * cell, y * cell, cell * .88, cell * .88),
            p,
          );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
