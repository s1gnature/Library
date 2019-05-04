2019.5.4 firebaseChatApp_editMessage


채팅방에서 채팅 입력 시 DB상에서 comment들이 계속 추가되는것이 아닌 갱신이 되는걸 수정함.
처음에 Comments 아래에 바로 message, uid, timestamp 가 있어서 메세지들이 누적이 되지 못했음.

//수정1 -> err
그래서 childByAutoID로 각각 메세지들을 담아서 DB로 보내줬음. 이러니까 allkeys로 DB에서 데이터를 불러올 때
이게 순서대로 불러와지는게 아니라 무작위? 로 불러와져서 시간대 별로 메세지가 나타나지 않고 뒤죽박죽 나와버림.

//수정2 -> fixed
그래서 아예 childByAutoID 가 아니라 timestamp에 찍힌 값들을 이름으로 줘버려서 나중에 key값들 sort 하면 시간 순서대로 나오게 코드를 작성함. 어차피 timestamp값이 계속 늘어나는 값이므로 DB에서 값을이 겹칠 일이 없음!!
valueKeys = value.allkeys as! [String] 으로 만들어 주고 valueKeys.sorted() 로 정렬 해준다음에
for key in valueKeys 로 각 key 값들을 Commnets[key] (-> 여기서는 snapshot.value에 해당)
로 value값을 찾아와서 comment [message, uid, timestamp] 에 넣어주고 리스트에 append 시켰음.

이렇게 하면 DB상에서 가져온 값들을 시간순으로 정렬해서 받아오기 때문에 tableView에 뿌려줄 때 바로 순서대로 뿌려주면댐!