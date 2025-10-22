import 'dart:io';
import 'package:dodecathlon/models/post.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user.dart';
import 'package:image_picker/image_picker.dart';
import '../utilities/image_utility.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = Uuid();

class PostCreationScreen extends ConsumerStatefulWidget {
  const PostCreationScreen({
    super.key,
    this.initialImageUrl,
    this.initialTitle,
    this.initialDescription,
    this.title,
  });

  final String? initialImageUrl;
  final String? initialTitle;
  final String? initialDescription;
  final String? title;

  @override
  ConsumerState<PostCreationScreen> createState() => _PostCreationScreenState();
}

class _PostCreationScreenState extends ConsumerState<PostCreationScreen> {

  bool _shareEnabled = false;
  User? currentUser;
  late String? _imageUrl;
  final String _postId = uuid.v4();
  String? _visibility;
  File? _selectedImage;

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  void _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery, maxWidth: 600);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _selectedImage = File(pickedImage.path);
    });

    _imageUrl = await ImageUtility().uploadImage(pickedImage.path, _selectedImage!);
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    if (widget.initialDescription != null){
      _descriptionController.text = widget.initialDescription!;
    }
    _titleController = TextEditingController();
    if (widget.initialTitle != null){
      _titleController.text = widget.initialTitle!;
    }
    _imageUrl = widget.initialImageUrl;
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
  }

  void uploadPost(BuildContext ctx) async {
    Post newPost = Post(
        userId: currentUser!.id!,
        title: _titleController.text,
        createdAt: DateTime.now(),
        description: _descriptionController.text,
        imageUrl: _imageUrl,
        user: currentUser,
        id: _postId,
        highlighted: false,
    );
    
    String? error = await newPost.upload();

    if(ctx.mounted) {
      Navigator.of(ctx).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => MainScreen()),
            (Route<dynamic> route) => false,
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    currentUser = ref.read(userProvider)!;

    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer.withAlpha(10),
        padding: EdgeInsets.all(20),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (ctx) => MainScreen()),
                              (Route<dynamic> route) => false,
                        );
                      },
                      child: Text('Back', style: TextStyle(fontSize: 20, color: Colors.black)),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        uploadPost(context);
                      },
                      child: Text(
                          'Post', style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primary)),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Text(widget.title != null ? widget.title! : 'What would you like to share?', style: TextStyle(fontSize: 25), textAlign: TextAlign.center,),
                SizedBox(height: 20,),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              currentUser!.profileImageUrl != null
                                  ? currentUser!.profileImageUrl!
                                  : 'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg'
                          ),
                        ),
                        title: Text(currentUser!.userName),
                      ),
                      if (_imageUrl !=  null)
                        GestureDetector(
                          onTap: _takePicture,
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Image.network(_imageUrl!, fit: BoxFit.fill,
                                frameBuilder: (_, image, loadingBuilder, __) {
                                  if (loadingBuilder == null) {
                                    return const SizedBox(
                                      height: 300,
                                      child: Center(child: CircularProgressIndicator()),
                                    );
                                  }
                                  return image;
                                },
                                loadingBuilder: (BuildContext ctx, Widget child, ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const SizedBox(
                                    height: 300,
                                    child: Center(child: CircularProgressIndicator()),
                                  );
                                },
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _imageUrl = null;
                                    });
                                  },
                                  icon: Icon(Icons.delete),
                              )
                            ],
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          controller: _titleController,
                          maxLines: 1,
                          decoration: InputDecoration(
                            hintText: 'Give it a title...',
                            hintStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black45),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          controller: _descriptionController,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Description...',
                            hintStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black45),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                            onPressed: _takePicture,
                            icon: Icon(Icons.attach_file)
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Visibility: '),
                    PopupMenuButton<String>(
                      initialValue: _visibility,
                      onSelected: (String value) {
                        setState(() {
                          _visibility = value;
                        });
                      },
                      itemBuilder: (ctx) {
                        return <PopupMenuEntry<String>>[
                          PopupMenuItem(value: 'Everyone', child: Text('Everyone')),
                          PopupMenuItem(value: 'Friends', child: Text('Friends'))
                        ];
                      },
                      child: Text(_visibility ?? 'Everyone', style: TextStyle(color: Colors.blue),),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}