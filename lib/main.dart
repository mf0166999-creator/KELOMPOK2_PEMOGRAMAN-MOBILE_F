import 'package:flutter/material.dart';

void main() {
  runApp(const EcoPowerApp());
}

class EcoPowerApp extends StatelessWidget {
  const EcoPowerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EcoPower',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF16875B)),
        scaffoldBackgroundColor: const Color(0xFFF3F7F4),
      ),
      home: const EcoPowerDashboard(),
    );
  }
}

class EnergySource {
  const EnergySource({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.detail,
  });

  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final String detail;
}

class EnergyMatchTarget {
  const EnergyMatchTarget({
    required this.sourceName,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String sourceName;
  final String title;
  final String description;
  final IconData icon;
}

const energySources = [
  EnergySource(
    name: 'Energi Air',
    description: 'Aliran air menggerakkan turbin.',
    icon: Icons.water_drop_rounded,
    color: Color(0xFF2585D8),
    detail:
        'Energi air memanfaatkan aliran atau jatuhan air untuk memutar turbin '
        'dan menghasilkan listrik.',
  ),
  EnergySource(
    name: 'Energi Surya',
    description: 'Cahaya matahari jadi listrik.',
    icon: Icons.solar_power_rounded,
    color: Color(0xFFE5A000),
    detail:
        'Panel surya mengubah cahaya matahari menjadi energi listrik tanpa '
        'pembakaran bahan bakar.',
  ),
  EnergySource(
    name: 'Energi Panas Bumi',
    description: 'Panas dari dalam bumi.',
    icon: Icons.thermostat_rounded,
    color: Color(0xFFE36C4A),
    detail:
        'Panas dari dalam bumi dimanfaatkan untuk menghasilkan uap yang '
        'menggerakkan turbin pembangkit listrik.',
  ),
  EnergySource(
    name: 'Energi Bioenergi',
    description: 'Berasal dari bahan organik.',
    icon: Icons.compost_rounded,
    color: Color(0xFF71933D),
    detail:
        'Bioenergi berasal dari bahan organik, seperti limbah pertanian dan '
        'sisa tanaman, yang dapat diolah menjadi energi.',
  ),
  EnergySource(
    name: 'Energi Angin',
    description: 'Angin memutar turbin.',
    icon: Icons.air_rounded,
    color: Color(0xFF4779C7),
    detail:
        'Turbin angin mengubah energi gerak angin menjadi energi listrik '
        'melalui putaran bilah turbin.',
  ),
  EnergySource(
    name: 'Energi Laut',
    description: 'Gelombang & pasang surut.',
    icon: Icons.waves_rounded,
    color: Color(0xFF168E9B),
    detail:
        'Energi laut memanfaatkan gerakan gelombang dan perubahan pasang '
        'surut untuk menggerakkan sistem pembangkit.',
  ),
];

const energyMatchTargets = [
  EnergyMatchTarget(
    sourceName: 'Energi Air',
    title: 'Sungai & bendungan',
    description: 'Aliran dan jatuhan air',
    icon: Icons.water,
  ),
  EnergyMatchTarget(
    sourceName: 'Energi Surya',
    title: 'Cahaya matahari',
    description: 'Sinar matahari ditangkap panel',
    icon: Icons.wb_sunny_rounded,
  ),
  EnergyMatchTarget(
    sourceName: 'Energi Panas Bumi',
    title: 'Panas dari dalam bumi',
    description: 'Uap panas dari bawah permukaan',
    icon: Icons.landscape_rounded,
  ),
  EnergyMatchTarget(
    sourceName: 'Energi Bioenergi',
    title: 'Limbah organik',
    description: 'Sisa tanaman dan bahan organik',
    icon: Icons.grass_rounded,
  ),
  EnergyMatchTarget(
    sourceName: 'Energi Angin',
    title: 'Area berangin',
    description: 'Angin memutar bilah turbin',
    icon: Icons.air_rounded,
  ),
  EnergyMatchTarget(
    sourceName: 'Energi Laut',
    title: 'Gelombang & pasang surut',
    description: 'Gerakan ombak dan air laut',
    icon: Icons.waves_rounded,
  ),
];

class EcoPowerDashboard extends StatefulWidget {
  const EcoPowerDashboard({super.key});

  @override
  State<EcoPowerDashboard> createState() => _EcoPowerDashboardState();
}

class _EcoPowerDashboardState extends State<EcoPowerDashboard> {
  final Set<String> _activeTapSources = {};
  final Set<String> _matchedDragSources = {};

  void _resetDemo() {
    setState(() {
      _activeTapSources.clear();
      _matchedDragSources.clear();
    });
  }

  void _recordMatch(EnergySource source, EnergyMatchTarget target) {
    if (source.name != target.sourceName) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Belum cocok. Coba pasangkan dengan sumber alamnya.'),
            duration: Duration(seconds: 2),
          ),
        );
      return;
    }

    setState(() {
      _matchedDragSources.add(source.name);
    });
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Benar! ${source.name} cocok dengan ${target.title}.'),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  void _showSourceInformation(EnergySource source) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: Icon(source.icon, color: source.color, size: 36),
          title: Text(source.name),
          content: Text(source.detail),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EcoPower Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF16875B),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            tooltip: 'Reset uji coba',
            onPressed: _resetDemo,
            icon: const Icon(Icons.restart_alt),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeCard(),
              const SizedBox(height: 26),
              const _SectionHeading(
                title: 'Jelajahi Energi Terbarukan',
                description: 'Daftar sumber energi yang akan digunakan pada uji coba gestur.',
              ),
              const SizedBox(height: 14),
              _buildEnergyGrid(hint: 'SUMBER ENERGI'),
              const SizedBox(height: 30),
              const _SectionHeading(
                title: 'Uji Coba Gestur',
                description: 'Coba setiap interaksi pada section yang berbeda.',
              ),
              const SizedBox(height: 18),
              _buildTapSection(),
              const SizedBox(height: 24),
              _buildLongPressSection(),
              const SizedBox(height: 24),
              _buildDragSection(),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _resetDemo,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset Uji Coba'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF16875B),
                    padding: const EdgeInsets.all(14),
                    side: const BorderSide(color: Color(0xFF16875B)),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE2ECE5)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.groups_rounded, color: Color(0xFF16875B)),
                        SizedBox(width: 9),
                        Text(
                          'Identitas Kelompok 2',
                          style: TextStyle(
                            color: Color(0xFF1D3529),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14),
                    _GroupMemberRow(
                      name: 'La Ode Muh. Fathir',
                      studentId: '202431131',
                      role: 'Ketua',
                    ),
                    SizedBox(height: 10),
                    _GroupMemberRow(
                      name: 'Nabila Ramadani',
                      studentId: '202431155',
                      role: 'Anggota',
                    ),
                    SizedBox(height: 14),
                    Divider(height: 1, color: Color(0xFFE2ECE5)),
                    SizedBox(height: 12),
                    Center(
                      child: Text(
                        'EcoPower | Sustainable Energy',
                        style: TextStyle(color: Colors.black54, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF126B4A), Color(0xFF53B887)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Energi Bersih untuk Masa Depan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    height: 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 9),
                Text(
                  'Jelajahi potensi energi terbarukan '
                  'melalui tampilan interaktif.',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          Icon(Icons.eco_rounded, size: 52, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildEnergyGrid({
    required String hint,
    bool tapDemo = false,
    bool longPressDemo = false,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 560 ? 3 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: energySources.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 174,
          ),
          itemBuilder: (context, index) {
            final source = energySources[index];
            return EnergySourceCard(
              source: source,
              hint: hint,
              onTap: tapDemo
                  ? () {
                      setState(() {
                        if (!_activeTapSources.add(source.name)) {
                          _activeTapSources.remove(source.name);
                        }
                      });
                    }
                  : null,
              onLongPress: longPressDemo
                  ? () => _showSourceInformation(source)
                  : null,
              active: tapDemo && _activeTapSources.contains(source.name),
            );
          },
        );
      },
    );
  }

  Widget _buildTapSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(
          number: '1',
          title: 'Tap',
          description: 'Ketuk kartu: warnanya berubah. Ketuk lagi untuk mengembalikan warna.',
          compact: true,
        ),
        const SizedBox(height: 12),
        _buildEnergyGrid(hint: 'KETUK UBAH WARNA', tapDemo: true),
      ],
    );
  }

  Widget _buildLongPressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(
          number: '2',
          title: 'Long Press',
          description:
              'Tekan dan tahan kartu untuk membuka informasi sumber energi.',
          compact: true,
        ),
        const SizedBox(height: 12),
        _buildEnergyGrid(hint: 'TEKAN & TAHAN', longPressDemo: true),
      ],
    );
  }

  Widget _buildDragSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(
          number: '3',
          title: 'Drag/Pan Gesture',
          description:
              'Seret setiap sumber energi ke pasangan alam yang sesuai.',
          compact: true,
        ),
        const SizedBox(height: 12),
        _DragMatchBoard(
          matchedSources: _matchedDragSources,
          onAccept: _recordMatch,
          onReset: () {
            setState(_matchedDragSources.clear);
          },
        ),
      ],
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.title,
    required this.description,
    this.number,
    this.compact = false,
  });

  final String title;
  final String description;
  final String? number;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final heading = Text(
      title,
      style: TextStyle(
        fontSize: compact ? 17 : 19,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF1D3529),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (number == null)
          heading
        else
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCEFE2),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  number!,
                  style: const TextStyle(
                    color: Color(0xFF16875B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 9),
              heading,
            ],
          ),
        const SizedBox(height: 5),
        Text(
          description,
          style: const TextStyle(color: Colors.black54, fontSize: 12),
        ),
      ],
    );
  }
}

class EnergySourceCard extends StatelessWidget {
  const EnergySourceCard({
    required this.source,
    required this.hint,
    this.onTap,
    this.onLongPress,
    this.active = false,
    this.compact = false,
    super.key,
  });

  final EnergySource source;
  final String hint;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool active;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final foreground = active ? Colors.white : const Color(0xFF26352C);
    final secondary = active ? Colors.white70 : Colors.black54;

    final cardContent = Padding(
      padding: EdgeInsets.all(compact ? 10 : 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: active ? Colors.white24 : source.color.withAlpha(24),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              source.icon,
              color: active ? Colors.white : source.color,
              size: 24,
            ),
          ),
          const Spacer(),
          Text(
            source.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: foreground,
              fontSize: 14,
              height: 1.15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            source.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: secondary, fontSize: 10, height: 1.2),
          ),
          const SizedBox(height: 7),
          Text(
            active ? 'WARNA BERUBAH' : hint,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: active ? Colors.white : source.color,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );

    return Card(
      margin: EdgeInsets.zero,
      elevation: active ? 5 : 1,
      clipBehavior: Clip.antiAlias,
      color: active ? source.color : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: active ? source.color : const Color(0xFFE8EEE9),
        ),
      ),
      child: onTap == null && onLongPress == null
          ? cardContent
          : InkWell(onTap: onTap, onLongPress: onLongPress, child: cardContent),
    );
  }
}

class _DragMatchBoard extends StatelessWidget {
  const _DragMatchBoard({
    required this.matchedSources,
    required this.onAccept,
    required this.onReset,
  });

  final Set<String> matchedSources;
  final void Function(EnergySource, EnergyMatchTarget) onAccept;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final remainingSources = energySources
        .where((source) => !matchedSources.contains(source.name))
        .toList();
    final isComplete = remainingSources.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubheading(
          icon: Icons.drag_indicator_rounded,
          title: 'Sumber energi',
          subtitle: 'Seret kartu ke pasangan yang tepat',
        ),
        const SizedBox(height: 10),
        if (isComplete)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2E5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xFF16875B)),
                SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'Hebat! Semua sumber energi sudah cocok.',
                    style: TextStyle(
                      color: Color(0xFF126B4A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 560 ? 3 : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: remainingSources.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  mainAxisExtent: 154,
                ),
                itemBuilder: (context, index) {
                  final source = remainingSources[index];
                  return Draggable<EnergySource>(
                    data: source,
                    maxSimultaneousDrags: 1,
                    feedback: Material(
                      color: Colors.transparent,
                      child: SizedBox(
                        width: constraints.maxWidth / columns - 10,
                        height: 154,
                        child: EnergySourceCard(
                          source: source,
                          hint: 'LEPAS DI PASANGAN',
                          compact: true,
                        ),
                      ),
                    ),
                    childWhenDragging: Opacity(
                      opacity: 0.35,
                      child: EnergySourceCard(
                        source: source,
                        hint: 'SEDANG DIGESER',
                        compact: true,
                      ),
                    ),
                    child: EnergySourceCard(
                      source: source,
                      hint: 'SERET KARTU',
                      compact: true,
                    ),
                  );
                },
              );
            },
          ),
        const SizedBox(height: 18),
        _buildSubheading(
          icon: Icons.place_rounded,
          title: 'Pasangan sumber alam',
          subtitle: 'Lepaskan kartu pada kotak yang sesuai',
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 560 ? 3 : 2;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: energyMatchTargets.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 116,
              ),
              itemBuilder: (context, index) {
                final target = energyMatchTargets[index];
                final matched = matchedSources.contains(target.sourceName);
                return DragTarget<EnergySource>(
                  onWillAcceptWithDetails: (details) =>
                      !matchedSources.contains(details.data.name),
                  onAcceptWithDetails: (details) =>
                      onAccept(details.data, target),
                  builder: (context, candidates, rejected) {
                    final hovering = candidates.isNotEmpty;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        color: matched
                            ? const Color(0xFFE0F2E5)
                            : hovering
                            ? const Color(0xFFD9EEE0)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: matched || hovering
                              ? const Color(0xFF16875B)
                              : const Color(0xFFE2ECE5),
                          width: hovering ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            matched ? Icons.check_circle_rounded : target.icon,
                            color: const Color(0xFF16875B),
                            size: 25,
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  target.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF26352C),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  matched ? 'COCOK' : target.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: matched
                                        ? const Color(0xFF16875B)
                                        : Colors.black54,
                                    fontSize: 9,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
        if (matchedSources.isNotEmpty && !isComplete) ...[
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Ulangi pencocokan'),
            ),
          ),
        ],
        if (isComplete) ...[
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh),
              label: const Text('Mainkan Lagi'),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSubheading({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF16875B), size: 20),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.black54, fontSize: 10),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GroupMemberRow extends StatelessWidget {
  const _GroupMemberRow({
    required this.name,
    required this.studentId,
    required this.role,
  });

  final String name;
  final String studentId;
  final String role;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.person_outline_rounded,
          color: Color(0xFF16875B),
          size: 20,
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Color(0xFF26352C),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                studentId,
                style: const TextStyle(color: Colors.black54, fontSize: 11),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFE5F2E9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            role,
            style: const TextStyle(
              color: Color(0xFF16875B),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
