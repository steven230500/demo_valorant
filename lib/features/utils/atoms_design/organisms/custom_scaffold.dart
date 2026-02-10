import 'package:commons/router/navigation_helper.dart';
import 'package:demo_valorant/features/utils/helper_demo.dart';
import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final double? webMaxHeight;
  final double? webMaxWidth;
  final Future<void> Function()? headerOnLogout;
  final String? headerTitle;
  final IconData? headerIcon;
  final Color? headerColorIcon;
  final MainAxisAlignment? headerMainAxisAlignment;
  final bool showArrowBack;
  final Widget? floatingActionButton;

  const CustomScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.webMaxHeight,
    this.webMaxWidth,
    this.headerOnLogout,
    this.headerTitle,
    this.headerIcon,
    this.headerColorIcon,
    this.headerMainAxisAlignment,
    this.showArrowBack = true,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return isMobile(context) ? _buildMobile() : _buildWeb(context);
  }

  Widget _buildWeb(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      floatingActionButton: floatingActionButton,
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: webMaxWidth ?? 1200,
              maxHeight: webMaxHeight ?? size.height,
            ),
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 40.0,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment:
                          headerMainAxisAlignment ??
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            children: [
                              if (headerIcon != null)
                                Icon(
                                  headerIcon ?? Icons.my_library_books,
                                  color: headerColorIcon ?? Colors.blueAccent,
                                  size: 40,
                                ),
                              if (showArrowBack)
                                IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    NavigationHelper.goBack(context);
                                  },
                                ),
                              SizedBox(width: 10),
                              if (headerTitle != null)
                                Flexible(
                                  child: Text(
                                    headerTitle ?? '',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (headerOnLogout != null)
                          IconButton(
                            icon: Icon(
                              Icons.logout_rounded,
                              color: Colors.redAccent,
                            ),
                            onPressed: headerOnLogout,
                            tooltip: 'Cerrar Sesión',
                          ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Expanded(child: body),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobile() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          appBar ??
          AppBar(
            title: Text(
              headerTitle ?? '',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            backgroundColor: Colors.white,
            actions: headerOnLogout != null
                ? [
                    IconButton(
                      icon: Icon(Icons.logout_rounded, color: Colors.redAccent),
                      onPressed: headerOnLogout,
                      tooltip: 'Cerrar Sesión',
                    ),
                  ]
                : null,
          ),

      body: Padding(
        padding: EdgeInsets.only(
          top: appBar != null ? 0 : 20,
          left: 20,
          right: 20,
          bottom: 20,
        ),
        child: body,
      ),
    );
  }
}
