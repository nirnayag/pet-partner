import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/core/models/pet/pet.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/views/patient_profile/patient_profile_viewmodel.dart';
import 'package:partner/ui/widgets/error_state.dart';
import 'package:partner/ui/widgets/loading_shimmer.dart';
import 'package:partner/ui/widgets/patient_profile_widgets.dart';
import 'package:stacked/stacked.dart';

/// Detail screen for a single pet patient.
///
/// Receives [petId] via the constructor (passed
/// through the Stacked router).
class PatientProfileView
    extends StackedView<PatientProfileViewModel> {
  /// Creates a [PatientProfileView].
  const PatientProfileView({
    required this.petId,
    super.key,
  });

  /// The pet to display.
  final String petId;

  @override
  Widget builder(
    BuildContext context,
    PatientProfileViewModel viewModel,
    Widget? child,
  ) {
    // Loading
    if (viewModel.isBusy) {
      return Scaffold(
        backgroundColor: kcBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              _AppBar(viewModel: viewModel),
              const Expanded(
                child: LoadingShimmer(
                  type: ShimmerType.detail,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Error
    if (viewModel.errorMessage != null) {
      return Scaffold(
        backgroundColor: kcBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              _AppBar(viewModel: viewModel),
              Expanded(
                child: ErrorState(
                  message: viewModel.errorMessage!,
                  onRetry: viewModel.retry,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final pet = viewModel.pet;
    if (pet == null) {
      return Scaffold(
        backgroundColor: kcBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              _AppBar(viewModel: viewModel),
              const Expanded(
                child: Center(
                  child: Text('Pet not found'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: kcBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              _ProfileHeader(
                viewModel: viewModel,
                pet: pet,
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    _OverviewTab(),
                    VisitHistoryTab(),
                    VaccinationTab(),
                    MedicationsTab(),
                    LabsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  PatientProfileViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      PatientProfileViewModel(petId: petId);

  @override
  void onViewModelReady(
    PatientProfileViewModel viewModel,
  ) =>
      viewModel.initialise();
}

// ====================================================
// App bar (reusable for loading/error states)
// ====================================================

class _AppBar extends StatelessWidget {
  const _AppBar({required this.viewModel});

  final PatientProfileViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: kcVeryLightGrey,
            width: 0.5,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: viewModel.goBack,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: kcPrimaryColor,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          Text(
            'Patient Profile',
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: kcDarkGreyColor,
            ),
          ),
          const Icon(
            Icons.more_vert_rounded,
            color: kcPrimaryColor,
          ),
        ],
      ),
    );
  }
}

// ====================================================
// Profile header with pet data + tabs
// ====================================================

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.viewModel,
    required this.pet,
  });

  final PatientProfileViewModel viewModel;
  final Pet pet;

  @override
  Widget build(BuildContext context) {
    final subtitle = _buildSubtitle(pet);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: kcVeryLightGrey,
            width: 0.5,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: viewModel.goBack,
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: kcPrimaryColor,
                ),
                padding: EdgeInsets.zero,
                constraints:
                    const BoxConstraints(),
              ),
              Text(
                'Patient Profile',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: kcDarkGreyColor,
                ),
              ),
              if (viewModel.canEditPet)
                GestureDetector(
                  onTap: () {
                    // TODO(pets): navigate edit
                  },
                  child: Text(
                    'Edit',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: kcPrimaryColor,
                    ),
                  ),
                )
              else
                const Icon(
                  Icons.more_vert_rounded,
                  color: kcPrimaryColor,
                ),
            ],
          ),
          const SizedBox(height: 24),
          _PetAvatar(photoUrl: pet.photoUrl),
          const SizedBox(height: 12),
          Text(
            pet.name,
            style: GoogleFonts.manrope(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: kcDarkGreyColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: kcPrimaryColor,
            ),
          ),
          if (pet.allergies.isNotEmpty) ...[
            const SizedBox(height: 20),
            _AllergyBanner(
              allergies: pet.allergies,
            ),
          ],
          const SizedBox(height: 24),
          const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorSize:
                TabBarIndicatorSize.label,
            labelPadding:
                EdgeInsets.only(right: 24),
            indicatorColor: kcPrimaryColor,
            labelColor: kcPrimaryColor,
            unselectedLabelColor: kcMediumGrey,
            labelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            dividerColor: Colors.transparent,
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'History'),
              Tab(text: 'Vaccinations'),
              Tab(text: 'Meds'),
              Tab(text: 'Labs'),
            ],
          ),
        ],
      ),
    );
  }

  String _buildSubtitle(Pet pet) {
    final parts = <String>[
      if (pet.breed != null) pet.breed!,
      if (pet.dateOfBirth != null)
        _calculateAge(pet.dateOfBirth!),
      if (pet.weight != null)
        '${pet.weight}${pet.weightUnit ?? 'kg'}',
    ];
    return parts.join(' \u2022 ');
  }

  String _calculateAge(DateTime dob) {
    final now = DateTime.now();
    var years = now.year - dob.year;
    var months = now.month - dob.month;
    if (now.day < dob.day) months--;
    if (months < 0) {
      years--;
      months += 12;
    }
    if (years > 0) {
      return '$years yr${years > 1 ? 's' : ''}';
    }
    return '$months mo';
  }
}

// ====================================================
// Pet avatar
// ====================================================

class _PetAvatar extends StatelessWidget {
  const _PetAvatar({this.photoUrl});

  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 96,
          height: 96,
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(44),
            child: photoUrl != null
                ? Image.network(
                    photoUrl!,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) =>
                            _placeholder(),
                  )
                : _placeholder(),
          ),
        ),
        Positioned(
          bottom: 4,
          right: 4,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: kcPrimaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.pets_rounded,
              size: 14,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _placeholder() {
    return Container(
      color: kcVeryLightGrey,
      alignment: Alignment.center,
      child: const Icon(
        Icons.pets,
        color: kcLightGrey,
        size: 36,
      ),
    );
  }
}

// ====================================================
// Allergy banner
// ====================================================

class _AllergyBanner extends StatelessWidget {
  const _AllergyBanner({required this.allergies});

  final List<String> allergies;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFFCDD2),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_rounded,
            color: Colors.red,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Allergy Alert',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.red,
                  ),
                ),
                Text(
                  allergies.join(', '),
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color:
                        Colors.red.withValues(
                      alpha: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ====================================================
// Overview tab (uses real pet data where available)
// ====================================================

class _OverviewTab extends ViewModelWidget<
    PatientProfileViewModel> {
  const _OverviewTab();

  @override
  Widget build(
    BuildContext context,
    PatientProfileViewModel viewModel,
  ) {
    final pet = viewModel.pet;
    if (pet == null) {
      return const SizedBox.shrink();
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        100,
      ),
      child: Column(
        children: [
          _InfoGrid(pet: pet),
          const SizedBox(height: 24),
          if (pet.notes != null &&
              pet.notes!.isNotEmpty) ...[
            _QuickNotes(notes: pet.notes!),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }
}

// ====================================================
// Info grid
// ====================================================

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.pet});

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: [
        _InfoCard(
          icon: Icons.cake_rounded,
          title: 'DOB',
          value: pet.dateOfBirth != null
              ? _formatDate(pet.dateOfBirth!)
              : 'Unknown',
          subtitle: pet.dateOfBirth != null
              ? _ageString(pet.dateOfBirth!)
              : '',
        ),
        _InfoCard(
          icon: Icons.female_rounded,
          title: 'GENDER',
          value: pet.gender?.toUpperCase() ??
              'Unknown',
          subtitle: '',
        ),
        _InfoCard(
          icon: Icons
              .medical_services_rounded,
          title: 'SPECIES',
          value: pet.species.toUpperCase(),
          subtitle: pet.breed ?? '',
        ),
        _InfoCard(
          icon: Icons.qr_code_rounded,
          title: 'MICROCHIP',
          value: pet.microchipNumber ?? 'N/A',
          subtitle: pet.microchipNumber != null
              ? 'Registered'
              : '',
        ),
      ],
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', //
    ];
    return '${months[d.month - 1]}'
        ' ${d.day}, ${d.year}';
  }

  String _ageString(DateTime dob) {
    final now = DateTime.now();
    var y = now.year - dob.year;
    var m = now.month - dob.month;
    if (now.day < dob.day) m--;
    if (m < 0) {
      y--;
      m += 12;
    }
    if (y > 0) return '$y years old';
    return '$m months old';
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String value;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: kcVeryLightGrey.withValues(
            alpha: 0.5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: kcMediumGrey),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: kcMediumGrey,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: kcDarkGreyColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: kcMediumGrey,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

// ====================================================
// Quick notes
// ====================================================

class _QuickNotes extends StatelessWidget {
  const _QuickNotes({required this.notes});

  final String notes;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Notes',
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: kcDarkGreyColor,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFDE7),
            borderRadius:
                BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFFFFF9C4),
            ),
          ),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.sticky_note_2_rounded,
                color: Color(0xFFFBC02D),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  notes,
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: kcDarkGreyColor
                        .withValues(
                      alpha: 0.8,
                    ),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
