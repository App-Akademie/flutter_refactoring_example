import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const A());

class A extends StatelessWidget {
  const A({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const BlgScr(),
    );
  }
}

class BlgScr extends StatefulWidget {
  const BlgScr({super.key});

  @override
  State<BlgScr> createState() => _StateForBlgScren();
}

class _StateForBlgScren extends State<BlgScr> {
  addCommentFunction(int postId, String comment) async {
    var urlToAddComment = 'https://jsonplaceholder.typicode.com/comments';
    var res = await http.post(
      Uri.parse(urlToAddComment),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"postId": postId, "body": comment}),
    );
    if (res.statusCode == 201) {
      var urlAPI = 'https://jsonplaceholder.typicode.com/posts';
      var responseFromServer = await http.get(Uri.parse(urlAPI));
      if (responseFromServer.statusCode == 200) {
        var dataFromServer = json.decode(responseFromServer.body);
        setState(() {
          blogs = dataFromServer;
          doo = false;
        });
      } else {
        setState(() {
          blogs = [];
          doo = false;
        });
      }
    }
  }

  List<dynamic> blogs = [];
  bool doo = true;
  bool isUpdating = false;
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller4 = TextEditingController();
  final TextEditingController controller6 = TextEditingController();

  ftch() async {
    var urlApi = 'https://jsonplaceholder.typicode.com/posts';
    var responseFromServer = await http.get(Uri.parse(urlApi));
    if (responseFromServer.statusCode == 200) {
      var dataFromServer = json.decode(responseFromServer.body);
      setState(() {
        blogs = dataFromServer;
        doo = false;
      });
    } else {
      setState(() {
        blogs = [];
        doo = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    ftch();
  }

  add_post_function(String titleParam, String bodyParam) async {
    var urlToAddPost = 'https://jsonplaceholder.typicode.com/posts';
    var r = await http.post(
      Uri.parse(urlToAddPost),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"title": titleParam, "body": bodyParam}),
    );
    if (r.statusCode == 201) {
      var urlAPI = 'https://jsonplaceholder.typicode.com/posts';
      var responseFromServer = await http.get(Uri.parse(urlAPI));
      if (responseFromServer.statusCode == 200) {
        var dataFromServer = json.decode(responseFromServer.body);
        setState(() {
          blogs = dataFromServer;
          doo = false;
        });
      } else {
        setState(() {
          blogs = [];
          doo = false;
        });
      }
    }
  }

  int toUpdate = -1;
  int slctPost = -1;

  startUpdatePost_FUNCTION(
      int idParam, String currentTitle, String currentBody) {
    ctrl3.text = currentTitle;
    controller4.text = currentBody;
    setState(() {
      toUpdate = idParam;
      isUpdating = true;
    });
  }

  final TextEditingController ctrl2 = TextEditingController();

  UPDATE_POST_FUNCTION(int idParam, String titleParam, String bodyParam) async {
    var urlToUpdatePost = 'https://jsonplaceholder.typicode.com/posts/$idParam';
    var res = await http.put(
      Uri.parse(urlToUpdatePost),
      headers: {"Content-Type": "application/json"},
      body:
          json.encode({"id": idParam, "title": titleParam, "body": bodyParam}),
    );
    if (res.statusCode == 200) {
      var urlAPI = 'https://jsonplaceholder.typicode.com/posts';
      var responseFromServer = await http.get(Uri.parse(urlAPI));
      if (responseFromServer.statusCode == 200) {
        var dataFromServer = json.decode(responseFromServer.body);
        setState(() {
          blogs = dataFromServer;
          doo = false;
        });
      } else {
        setState(() {
          blogs = [];
          doo = false;
        });
      }
      setState(() {
        toUpdate = -1;
        isUpdating = false;
      });
    }
  }

  final TextEditingController ctrl3 = TextEditingController();

  Widget buildBlogPost(dynamic postParam) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScrPstDtl(post: postParam),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      postParam['title'],
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.comment),
                        onPressed: () {
                          setState(() {
                            slctPost = postParam['id'];
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => startUpdatePost_FUNCTION(
                            postParam['id'],
                            postParam['title'],
                            postParam['body']),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => DeletePostFunction(postParam['id']),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(postParam['body']),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUpdateFormFunction() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: ctrl3,
            decoration: const InputDecoration(hintText: 'Update Title'),
          ),
          TextField(
            controller: controller4,
            decoration: const InputDecoration(hintText: 'Update Body'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () =>
                UPDATE_POST_FUNCTION(toUpdate, ctrl3.text, controller4.text),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Update Post'),
          ),
          ElevatedButton(
            onPressed: () => setState(() {
              toUpdate = -1;
              isUpdating = false;
            }),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Cancel Update'),
          ),
        ],
      ),
    );
  }

  Widget buildInputFormFunction() {
    return buildInputFormFunctionInner();
  }

  Container buildContainer() {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: controller1,
              decoration: const InputDecoration(hintText: 'New Post Title'),
            ),
            TextField(
              controller: ctrl2,
              decoration: const InputDecoration(hintText: 'New Post Body'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => add_post_function(controller1.text, ctrl2.text),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
              ),
              child: const Text('Add Post'),
            )
          ],
        ),
      ),
    );
  }

  Container buildInputFormFunctionInner() {
    return buildContainer();
  }

  Widget buildCommentFormFunction() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Add Comment:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: controller6,
            decoration: const InputDecoration(hintText: 'Your Comment'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              addCommentFunction(slctPost, controller6.text);
              setState(() {
                slctPost = -1;
              });
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Add Comment'),
          ),
          ElevatedButton(
            onPressed: () => setState(() {
              slctPost = -1;
            }),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Cancel Comment'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blog Posts')),
      body: doo
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                toUpdate != -1 ? buildUpdateFormFunction() : Container(),
                slctPost != -1 ? buildCommentFormFunction() : Container(),
                Expanded(
                  child: ListView.builder(
                    itemCount: blogs.length,
                    itemBuilder: (context, iii) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ScrPstDtl(post: blogs[iii]),
                            ),
                          );
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        blogs[iii]['title'],
                                        style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.comment),
                                          onPressed: () {
                                            setState(() {
                                              slctPost = blogs[iii]['id'];
                                            });
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () => (int idParam,
                                                  String currentTitle,
                                                  String currentBody) {
                                            ctrl3.text = currentTitle;
                                            controller4.text = currentBody;
                                            setState(() {
                                              toUpdate = idParam;
                                              isUpdating = true;
                                            });
                                          }(
                                              blogs[iii]['id'],
                                              blogs[iii]['title'],
                                              blogs[iii]['body']),
                                          // Style for the icon button
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () => (blogs[iii]['id']),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(blogs[iii]['body']),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                isUpdating ? Container() : buildInputFormFunction(),
              ],
            ),
    );
  }

  DeletePostFunction(int idParam) async {
    var urlToDeletePost = 'https://jsonplaceholder.typicode.com/posts/$idParam';
    var r = await http.delete(Uri.parse(urlToDeletePost));
    if (r.statusCode == 200) {
      ftch();
    }
  }
}

class ScrPstDtl extends StatefulWidget {
  final dynamic post;
  const ScrPstDtl({super.key, this.post});

  @override
  State<ScrPstDtl> createState() => _ScrPstDtlState();
}

class _ScrPstDtlState extends State<ScrPstDtl> {
  addNewComment(String commentText) async {
    var urlToAddComment = 'https://jsonplaceholder.typicode.com/comments';
    var responseForAddComment = await http.post(
      Uri.parse(urlToAddComment),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"postId": widget.post['id'], "body": commentText}),
    );
    if (responseForAddComment.statusCode == 201) {
      fetchComments();
    }
  }

  Widget buildCommentSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Comments:',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          isLoadingComments
              ? const CircularProgressIndicator()
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: comments.length,
                  itemBuilder: (context, i) {
                    return MyWidget(
                      name: comments[i]['name'],
                      body: comments[i]['body'],
                    );
                  },
                ),
          TextField(
            controller: c,
            decoration: const InputDecoration(hintText: 'Write a comment...'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
              onPressed: () {
                addNewComment(c.text);
                c.clear();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Add Comment'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.post['title'])),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.post['body'],
                style: const TextStyle(fontSize: 18),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Comments:',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  isLoadingComments
                      ? const CircularProgressIndicator()
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: comments.length,
                          itemBuilder: (context, idx) {
                            return MyWidget(
                              name: comments[idx]['name'],
                              body: comments[idx]['body'],
                            );
                          },
                        ),
                  TextField(
                    controller: c,
                    decoration:
                        const InputDecoration(hintText: 'Write a comment...'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      addNewComment(c.text);
                      c.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Add Comment'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  fetchComments() async {
    var urlAPI =
        'https://jsonplaceholder.typicode.com/posts/${widget.post['id']}/comments';
    var responseFromServer = await http.get(Uri.parse(urlAPI));
    if (responseFromServer.statusCode == 200) {
      var commentsData = json.decode(responseFromServer.body);
      setState(() {
        comments = commentsData;
        isLoadingComments = false;
      });
    } else {
      setState(() {
        comments = [];
        isLoadingComments = false;
      });
    }
  }

  List<dynamic> comments = [];
  bool isLoadingComments = true;
  final TextEditingController c = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchComments();
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key, required this.name, required this.body});
  final String name;
  final String body;

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.name),
      subtitle: Text(widget.body),
    );
  }
}
