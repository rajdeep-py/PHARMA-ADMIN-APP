# pharma_erp_admin_app

Flutter-based Admin Console for **Naiyo24 / Pharma ERP**.

This app is built as a modular admin UI with consistent patterns:
**Model → Repository (provider) → AsyncNotifier (Riverpod) → Screen + Cards → Router (GoRouter)**.

> Note: Some modules currently use **in-memory repositories** (seeded sample data + async delays) so the UI can run without a backend. The README section “Future: Dio integration” describes how to connect real APIs.

## Features

### Core
- Authentication screens: Splash, Login, Signup
- Dashboard
- Side navigation drawer + reusable `AppAppBar`

### Management modules
- MR Management (list, details, onboard/edit)
- ASM Management (list, details, onboard/edit)
- Doctor Management (list/search/filter, details, add/edit with photo picker)
- DCR Management (list/search/filter, details bottom sheet)
- Trip Plan Management (calendar + editor)
- Order Management
	- List/search/filter
	- Order details bottom sheet
	- Admin status update
	- Create order + Edit order
- Visual Ads Management (list/search, create/edit, preview)
- Attendance Records (calendar + filtering + export helpers)
- Salary Slip management (employee list + bottom sheets)
- Distributor management (list, details, add/edit)
- Chemist Shop management (list, details)
- Team Management (list, details, chat room, create/edit)
- Announcements (list + create/edit)
- Profile screen
- Subscription plans
	- Plan history (active/inactive, plan name, amount, transaction id)
	- Buy a new plan (monthly/quarterly/annual plan cards)

## Tech Stack
- Flutter (Material)
- Dart SDK: `^3.11.4`
- Routing: `go_router`
- State management: `flutter_riverpod`
- Common utilities: `url_launcher`, `image_picker`, `file_picker`, `record`, `just_audio`, `video_player`, `table_calendar`, etc.

## How to clone and run

### Prerequisites
- Flutter SDK installed and available on PATH
- Xcode (for iOS), Android Studio (for Android), or Chrome (for web)
- Run `flutter doctor` and resolve any issues

### Clone
```bash
git clone <YOUR_REPO_URL>
cd pharma_erp_admin_app
```

### Install dependencies
```bash
flutter pub get
```

### Run
Pick one:
```bash
flutter run
```
```bash
flutter run -d chrome
```

### Quality checks
```bash
flutter analyze
flutter test
dart format .
```

## Project Structure

Generated/build folders like `build/`, `.dart_tool/`, and IDE folders are intentionally not expanded here.

### Top level
```text
pharma_erp_admin_app/
	README.md
	analysis_options.yaml
	pubspec.yaml
	pubspec.lock
	assets/
	lib/
	test/
	android/   (Flutter scaffold)
	ios/       (Flutter scaffold)
	web/       (Flutter scaffold)
	linux/     (Flutter scaffold)
	macos/     (Flutter scaffold)
	windows/   (Flutter scaffold)
```

### Assets
```text
assets/
	font/
		BricolageGrotesque-VariableFont_opsz,wdth,wght.ttf
	images/
		director.jpeg
	logo/
		naiyo24_logo.png
```

### Source (lib)
```text
lib/
	main.dart
	routes/
		app_router.dart
	theme/
		app_theme.dart
	widgets/
		app_bar.dart
		side_nav_bar.dart
	utils/
		attachment_playback.dart
		attachment_playback_io.dart
		attachment_playback_stub.dart
		attachment_playback_web.dart
		attendance_export.dart
		attendance_export_io.dart
		attendance_export_stub.dart
		attendance_export_web.dart
		video_controller_factory.dart
		video_controller_factory_io.dart
		video_controller_factory_stub.dart
	models/
		about_us.dart
		announcement.dart
		asm_management.dart
		attendance.dart
		chemist_shop.dart
		count.dart
		dcr.dart
		distributor.dart
		doctor.dart
		mr_management.dart
		order.dart
		plans.dart
		salary_slip.dart
		team_management.dart
		terms_conditions.dart
		trip_plan.dart
		user.dart
		visual_ads.dart
	providers/
		about_us_provider.dart
		announcement_provider.dart
		asm_management_provider.dart
		attendance_management_provider.dart
		auth_provider.dart
		chemist_shop_provider.dart
		dashboard_provider.dart
		dcr_provider.dart
		distributor_provider.dart
		doctor_provider.dart
		mr_management_provider.dart
		order_provider.dart
		payment_provider.dart
		profile_provider.dart
		salary_slip_provider.dart
		team_management_provider.dart
		terms_conditions_provider.dart
		trip_plan_provider.dart
		visual_ads_provider.dart
	notifiers/
		about_us_notifier.dart
		announcement_notifier.dart
		asm_management_notifier.dart
		attendance_management_notifier.dart
		auth_notifier.dart
		chemist_shop_notifier.dart
		dashboard_notifier.dart
		dcr_notifier.dart
		distributor_notifier.dart
		doctor_notifier.dart
		mr_management_notifier.dart
		order_notifier.dart
		payment_notifier.dart
		profile_notifier.dart
		salary_slip_notifier.dart
		team_management_notifier.dart
		terms_conditions_notifier.dart
		trip_plan_notifier.dart
		visual_ads_notifier.dart
	screens/
		about_us/
			about_us_screen.dart
		announcement/
			announcement_management_screen.dart
			create_edit_announcement_screen.dart
		asm_management/
			asm_details_screen.dart
			asm_management_screen.dart
			onboard_edit_asm_screen.dart
		attendance/
			attendance_management_screen.dart
		auth/
			login_screen.dart
			signup_screen.dart
			splash_screen.dart
		chemist_shop/
			chemist_shop_detail_screen.dart
			chemist_shop_screen.dart
		dashboard/
			dashboard_screen.dart
		dcr/
			dcr_screen.dart
		distributor/
			add_edit_distributor_screen.dart
			distributor_detail_screen.dart
			distributor_screen.dart
		doctor/
			add_edit_doctor_screen.dart
			doctor_detail_screen.dart
			doctor_screen.dart
		mr_management/
			mr_details_screen.dart
			mr_management_screen.dart
			onboard_edit_mr_screen.dart
		order/
			create_edit_order_screen.dart
			order_screen.dart
		payment/
			plan_history_screen.dart
			plan_screen.dart
		profile/
			profile_screen.dart
		salary_slip/
			salary_slip_screen.dart
		team_management/
			create_edit_team_screen.dart
			team_chat_room_screen.dart
			team_details_screen.dart
			team_management_screen.dart
		terms_conditions/
			terms_conditions_screen.dart
		trip_plan/
			create_edit_trip_plan_screen.dart
			trip_plan_screen.dart
		visual_ads/
			create_edit_visual_ads_screen.dart
			visual_ad_preview_screen.dart
			visual_ads_management_screen.dart
	cards/
		about_us/
			about_us_contact_card.dart
			about_us_description_card.dart
			about_us_director_card.dart
			about_us_header_card.dart
		announcement/
			announcement_card.dart
		asm_management/
			asm_bank_details_card.dart
			asm_card.dart
			asm_contact_card.dart
			asm_header_card.dart
			asm_headquarter_card.dart
			asm_search_bar.dart
		attendance/
			attendance_details_card.dart
			calendar_card.dart
			download_attendance_sheet_card.dart
			filter_card.dart
		chemist_shop/
			chemist_shop_card.dart
			chemist_shop_contact_card.dart
			chemist_shop_description_card.dart
			chemist_shop_header_card.dart
			chemist_shop_search_bar.dart
		dashboard/
			count_card.dart
			footer_card.dart
			welcome_card.dart
		dcr/
			dcr_card.dart
			dcr_details_bottomsheet.dart
			dcr_search_filter_bar.dart
		distributor/
			distributor_card.dart
			distributor_contact_card.dart
			distributor_description_card.dart
			distributor_header_card.dart
			distributor_order_info_card.dart
			distributor_search_filter_bar.dart
		doctor/
			doctor_card.dart
			doctor_chamber_card.dart
			doctor_contact_card.dart
			doctor_education_card.dart
			doctor_experience_card.dart
			doctor_header_card.dart
			doctor_search_filter_bar.dart
		mr_management/
			mr_bank_details_card.dart
			mr_card.dart
			mr_contact_card.dart
			mr_header_card.dart
			mr_headquarter_card.dart
			mr_search_bar.dart
		order/
			order_card.dart
			order_details_bottomsheet.dart
			order_search_filter_bar.dart
		payment/
			plan_card.dart
		profile/
			profile_header_card.dart
			profile_option_card.dart
		salary_slip/
			employee_card.dart
			employee_search_bar.dart
			upload_salary_slip_bottomsheet.dart
			view_salary_slip_bottomsheet.dart
		team_management/
			team_card.dart
			team_description_card.dart
			team_header_card.dart
			team_memebers_card.dart
			team_search_bar.dart
		terms_conditions/
			terms_conditions_card.dart
			terms_conditions_header_card.dart
		trip_plan/
			day_plan_card.dart
			trip_plan_calendar_card.dart
			trip_plan_card.dart
			trip_plan_search_bar.dart
		visual_ads/
			visual_ads_card.dart
			visual_ads_search_bar.dart
```

### Tests
```text
test/
	widget_test.dart
```

## Future: Backend Integration (Dio + PrettyDioLogger)

When you’re ready to connect real APIs, recommended steps:

### 1) Add dependencies
```bash
flutter pub add dio pretty_dio_logger
```

### 2) Add a Dio client + logger
Create a dedicated client (example structure suggestion):
```text
lib/
	network/
		dio_client.dart
```

Example (concept):
```dart
final dioProvider = Provider<Dio>((ref) {
	final dio = Dio(
		BaseOptions(
			baseUrl: 'https://api.yourdomain.com',
			connectTimeout: const Duration(seconds: 15),
			receiveTimeout: const Duration(seconds: 15),
		),
	);

	dio.interceptors.add(
		PrettyDioLogger(
			requestHeader: true,
			requestBody: true,
			responseHeader: false,
			responseBody: true,
			error: true,
			compact: true,
		),
	);

	return dio;
});
```

### 3) Replace in-memory repositories
Each module already follows a repository pattern (see `lib/providers/*_provider.dart`).
You can introduce API-backed repositories that use Dio and swap the provider implementation.

Example approach:
- Keep the abstract repository interface
- Implement `ApiXRepository(dio)`
- Use Riverpod provider to return API repository in prod

### 4) Handle auth tokens
Add an interceptor to attach `Authorization: Bearer <token>` from your auth notifier/provider.

---

If you want, I can also scaffold `lib/network/dio_client.dart` and update one module (e.g., Orders) to demonstrate the full in-memory → API migration pattern.
