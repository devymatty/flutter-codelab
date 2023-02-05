///
///
/// Copyright (c) 2022 Razeware LLC
/// Permission is hereby granted, free of charge, to any person
/// obtaining a copy of this software and associated documentation
/// files (the "Software"), to deal in the Software without
/// restriction, including without limitation the rights to use,
/// copy, modify, merge, publish, distribute, sublicense, and/or
/// sell copies of the Software, and to permit persons to whom
/// the Software is furnished to do so, subject to the following
/// conditions:

/// The above copyright notice and this permission notice shall be
/// included in all copies or substantial portions of the Software.

/// Notwithstanding the foregoing, you may not use, copy, modify,
/// merge, publish, distribute, sublicense, create a derivative work,
/// and/or sell copies of the Software in any work that is designed,
/// intended, or marketed for pedagogical or instructional purposes
/// related to programming, coding, application development, or
/// information technology. Permission for such use, copying,
/// modification, merger, publication, distribution, sublicensing,
/// creation of derivative works, or sale is expressly withheld.

/// This project and source code may use libraries or frameworks
/// that are released under various Open-Source licenses. Use of
/// those libraries and frameworks are governed by their own
/// individual licenses.

/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
/// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
/// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
/// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
/// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
/// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
/// DEALINGS IN THE SOFTWARE.
///
///
import 'package:article_finder/bloc/article_detail_bloc.dart';
import 'package:article_finder/bloc/article_list_bloc.dart';
import 'package:article_finder/bloc/bloc_provider.dart';
import 'package:article_finder/data/article.dart';
import 'package:article_finder/ui/article_detail_screen.dart';
import 'package:article_finder/ui/article_list_item.dart';
import 'package:flutter/material.dart';

class ArticleListScreen extends StatelessWidget {
  const ArticleListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ArticleListBloc>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Articles')),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search ...',
              ),
              onChanged: bloc.searchQuery.add,
            ),
          ),
          Expanded(
            child: _buildResults(bloc),
          )
        ],
      ),
    );
  }

  Widget _buildResults(ArticleListBloc bloc) {
    // 1
    return StreamBuilder<List<Article>?>(
      stream: bloc.articlesStream,
      builder: (context, snapshot) {
        // 2
        final results = snapshot.data;
        if (results == null) {
          return const Center(child: CircularProgressIndicator());
        } else if (results.isEmpty) {
          return const Center(child: Text('No Results'));
        }
        // 3
        return _buildSearchResults(results);
      },
    );
  }

  Widget _buildSearchResults(List<Article> results) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final article = results[index];
        return InkWell(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ArticleListItem(article: article),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  bloc: ArticleDetailBloc(id: article.id),
                  child: const ArticleDetailScreen(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
