import 'package:flutter/material.dart';
import 'package:newarch/presentation/bottom_sheets/select_country/logic/select_country_bloc.dart';
import 'package:newarch/presentation/bottom_sheets/select_country/view/widgets/select_country_list.dart';
import 'package:newarch/presentation/bottom_sheets/select_country/view/widgets/select_country_search_bar.dart';

class SelectCountryBottomSheet extends StatefulWidget {
  const SelectCountryBottomSheet({super.key});

  @override
  State<SelectCountryBottomSheet> createState() => _SelectCountryState();
}

class _SelectCountryState extends State<SelectCountryBottomSheet> {
  late final bloc = context.selectCountryBloc;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.7,
      expand: false,
      builder: (context, scrollController) {
        return CustomScrollView(
          controller: scrollController,
          slivers: const [
            SelectCountrySearchBar(),
            SelectCountryList(),
          ],
        );
      },
    );
  }
}
