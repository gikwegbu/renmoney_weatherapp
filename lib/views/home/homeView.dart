import 'dart:async';

import 'package:provider/provider.dart';
import 'package:renmoney_weatherapp/config/dependencies.dart';
import 'package:renmoney_weatherapp/core/models/cityModel.dart';
import 'package:renmoney_weatherapp/core/viewModel/homeController.dart';
import 'package:renmoney_weatherapp/utilities/exportedPackages.dart';
import 'package:renmoney_weatherapp/views/home/components/moreWeatherDetails.dart';
import 'package:renmoney_weatherapp/views/home/components/savedWeatherCard.dart';
import 'package:renmoney_weatherapp/views/home/components/weatherListItem.dart';
import 'package:renmoney_weatherapp/views/home/emptySearchState.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeController homeCtrl;
  TextEditingController searchTextCtrl = TextEditingController();
  final FocusNode _searchTextFocus = FocusNode();
  Timer? _debounce;

  bool isSearchTextFieldFocused = false;
  final PageController controller = PageController(
    viewportFraction: 0.5,
    initialPage: 0,
  );

  @override
  void initState() {
    homeCtrl = locator.get<HomeController>();
    super.initState();
    _searchTextFocus.addListener(_onFocusChange);
    safeNavigate(() {
      homeCtrl.loadCities();
      determinePosition(context);
    });
  }


  @override
  Widget build(BuildContext context) {
    homeCtrl = context.watch<HomeController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                onChanged: (val) => _onSearchChanged(val),
                decoration: FormUtils.inputDecoration(
                  hintText: "Search by city...",
                  prefixIcon: const Icon(
                    Icons.search,
                  ),
                  suffixIcon: !isSearchTextFieldFocused
                      ? null
                      : GestureDetector(
                          onTap: clearSearchTextFn,
                          child: const Icon(Icons.cancel_outlined),
                        ),
                ),
                focusNode: _searchTextFocus,
                controller: searchTextCtrl,
              ),
            ),
            ySpace(height: 10),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 20),
                children: [
                  const Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.end,
                    children: [
                      Text(
                        "Swipe",
                        textAlign: TextAlign.end,
                      ),
                      Icon(Icons.arrow_right_alt_outlined)
                    ],
                  ),
                  ySpace(),
                  isObjectEmpty(homeCtrl.savedCityList)
                      ? SizedBox(
                          child: Column(
                            children: [
                              const CircularProgressIndicator.adaptive(),
                              ySpace(),
                              labelText("Loading Saved Cities"),
                            ],
                          ),
                        )
                      : SizedBox(
                          height: 80,
                          child: PageView.builder(
                            padEnds: false,
                            scrollDirection: Axis.horizontal,
                            controller: controller,
                            itemCount: homeCtrl.savedCityList.length,
                            itemBuilder: (ctx, i) {
                              final city = homeCtrl.savedCityList[i];
                              return SavedWeatherCard(
                                city: city,
                                onTap: () {
                                  showMoreDetails(city);
                                },
                              );
                            },
                          )),
                  ySpace(height: 30),
                  isObjectEmpty(homeCtrl.filteredCityList)
                      ? EmptySearchState(
                          text: searchTextCtrl.text,
                        )
                      : ListView.separated(
                          itemCount: homeCtrl.filteredCityList.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, i) {
                            final city = homeCtrl.filteredCityList[i];
                            return WeatherListItem(
                              onTap: () => showMoreDetails(city),
                              city: city,
                            );
                          },
                          separatorBuilder: (ctx, i) => ySpace(),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    // In situations where we are actually making an API call to the server
    // This will help reduce the speed those calls are being made...
    _debounce = Timer(const Duration(milliseconds: 300), () {
      homeCtrl.setFilteredCityList(query);
    });
  }

  void showMoreDetails(CityModel city) {
    customShowBottomSheet(
      ctx: context,
      child: MoreWeatherDetails(city: city),
    );
  }

  void _onFocusChange() {
    setState(() {
      isSearchTextFieldFocused = _searchTextFocus.hasFocus;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchTextCtrl.dispose();
    _searchTextFocus.dispose();
    _searchTextFocus.removeListener(_onFocusChange);
    super.dispose();
  }

  void clearSearchTextFn() {
    closeKeyPad(context);
    searchTextCtrl.clear();
    homeCtrl.resetFilteredCityList();
  }
}
