import 'dart:async';
import 'dart:developer';

import 'package:chat_gpt_flutter/chat_gpt_flutter.dart';
import 'package:thuyngoc/MenuBar/question_answer.dart';
import 'package:flutter/material.dart';

class ChatCompletionPage extends StatefulWidget {
  final ChatGpt chatGpt;

  const ChatCompletionPage({required this.chatGpt});

  @override
  State<ChatCompletionPage> createState() => _ChatCompletionPageState();
}

class _ChatCompletionPageState extends State<ChatCompletionPage> {
  String? answer;
  bool loading = false;
  final testPrompt =
      'Which Disney character famously leaves a glass slipper behind at a royal ball?';

  final List<QuestionAnswer> questionAnswers = [];

  late TextEditingController textEditingController;

  StreamSubscription<CompletionResponse>? streamSubscription;
  StreamSubscription<StreamCompletionResponse>? chatStreamSubscription;
  List<String> chatSuggestions = [
    'Mèo biếng ăn',
    'Cách dạy chó đi vệ sinh đúng chỗ',
    'Bạn có thể giúp tôi tìm thông tin về thú cưng không?',
    'Cảm ơn!',
    'Điều gì mới?',
    'Có thể bạn giúp tôi với...',
  ];
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    chatStreamSubscription?.cancel();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            
            if (questionAnswers.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/talk.png',
                        width: 400,
                        height: 400,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Hãy bắt đầu tìm hiểu thú cưng nào!',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  itemCount: questionAnswers.length,
                  itemBuilder: (context, index) {
                    final questionAnswer = questionAnswers[index];
                    final answer = questionAnswer.answer.toString().trim();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          margin:
                              EdgeInsets.only(left: 10, right: 10, top: 20),
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade50,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Người dùng: ${questionAnswer.question}',
                              style: TextStyle(
                                color: Color.fromARGB(255, 48, 48, 48),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (answer.isEmpty && loading)
                          const Center(
                            child: CircularProgressIndicator(),
                          )
                        else
                          Container(
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 20),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade100,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Pet Tracker: $answer',
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 23, 22, 22),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                ),
              ),
              if (chatSuggestions.isNotEmpty)
              Container(
                height: 50,
                color: Colors.white,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: chatSuggestions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _textController.text = chatSuggestions[index];
                          });
// Future.delayed(Duration(milliseconds: 100), () {
//       _sendChatMessage();
//     });                        
},
                        child: Text(
                          chatSuggestions[index],
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 8,),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                 Expanded(
  child: TextFormField(
    controller: textEditingController,
    decoration: const InputDecoration(hintText: 'Nhập câu hỏi ...'),
    onFieldSubmitted: (_) => _sendChatMessage(),
  ),
),

                  const SizedBox(width: 12),
                  ClipOval(
                    child: Material(
                      color: Color.fromARGB(255, 136, 202, 191),
                      child: InkWell(
                        onTap: _sendChatMessage,
                        child: const SizedBox(
                          width: 48,
                          height: 48,
                          child: Icon(
                            Icons.send_rounded,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


  _sendChatMessage() async {
    final question = textEditingController.text;
    
    setState(() {
      textEditingController.clear();
      loading = true;
      questionAnswers.add(
        QuestionAnswer(
          question: question,
          answer: StringBuffer(),
        ),
      );
    });
    final testRequest = ChatCompletionRequest(
      stream: true,
      maxTokens: 4000,
      messages: [Message(role: Role.user.name, content: question)],
      model: ChatGptModel.gpt35Turbo,
    );
    await _chatStreamResponse(testRequest);

    setState(() => loading = false);
  }

  _chatStreamResponse(ChatCompletionRequest request) async {
    chatStreamSubscription?.cancel();
    try {
      final stream = await widget.chatGpt.createChatCompletionStream(request);
      chatStreamSubscription = stream?.listen(
        (event) => setState(
          () {
            if (event.streamMessageEnd) {
              chatStreamSubscription?.cancel();
            } else {
              return questionAnswers.last.answer.write(
                event.choices?.first.delta?.content,
              );
            }
          },
        ),
      );
    } catch (error) {
      setState(() {
        loading = false;
        questionAnswers.last.answer.write("Error");
      });
      log("Error occurred: $error");
    }
  }
}
