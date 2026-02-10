import 'package:commons/router/navigation_helper.dart';
import 'package:demo_valorant/features/utils/atoms_design/organisms/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/injectors/injector.dart';
import '../../../../core/router/app_router.dart';
import '../../../../firebase_login_functions.dart';
import '../bloc/topics_bloc/topics_bloc.dart';
import '../topics_router/topics_router.dart';
import '../widgets/topic_accordion_widget.dart';

class TopicsPage extends StatelessWidget {
  const TopicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TopicsBloc>()..add(GetTopicsEvent()),
      child: CustomScaffold(
        headerOnLogout: () async{
            await AuthService().signOut();
            if (context.mounted) {
              NavigationHelper.goToAndReplace(
                context,
                AppRouter.login.path,
              );
            }
        },
        headerIcon:  Icons.my_library_books,
        headerColorIcon: Colors.blueAccent,
        headerTitle: 'Documentación',
        showArrowBack: false,
        body: BlocBuilder<TopicsBloc, TopicsState>(
          builder: (context, state) {
            if (state is TopicsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TopicsError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is TopicsLoaded) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.topics.length,
                      itemBuilder: (context, index) {
                        final topic = state.topics[index];
                        return TopicAccordionWidget(
                          key: ValueKey(topic.id),
                          topic: topic,
                          onTapInEmpty: () {},
                          onSubtopic: (subtopic) {
                            context.pushNamed(
                              TopicsRouter.subtopicDetail.name,
                              extra: {
                                'subtopic': subtopic
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }
            return const Center(child: Text('No topics loaded'));
          },
        ),
      ),
    );
  }
}
