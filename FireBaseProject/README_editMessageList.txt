2019.5.4 firebaseChatApp_editMessage


ä�ù濡�� ä�� �Է� �� DB�󿡼� comment���� ��� �߰��Ǵ°��� �ƴ� ������ �Ǵ°� ������.
ó���� Comments �Ʒ��� �ٷ� message, uid, timestamp �� �־ �޼������� ������ ���� ������.

//����1 -> err
�׷��� childByAutoID�� ���� �޼������� ��Ƽ� DB�� ��������. �̷��ϱ� allkeys�� DB���� �����͸� �ҷ��� ��
�̰� ������� �ҷ������°� �ƴ϶� ������? �� �ҷ������� �ð��� ���� �޼����� ��Ÿ���� �ʰ� ���׹��� ���͹���.

//����2 -> fixed
�׷��� �ƿ� childByAutoID �� �ƴ϶� timestamp�� ���� ������ �̸����� ������� ���߿� key���� sort �ϸ� �ð� ������� ������ �ڵ带 �ۼ���. ������ timestamp���� ��� �þ�� ���̹Ƿ� DB���� ������ ��ĥ ���� ����!!
valueKeys = value.allkeys as! [String] ���� ����� �ְ� valueKeys.sorted() �� ���� ���ش�����
for key in valueKeys �� �� key ������ Commnets[key] (-> ���⼭�� snapshot.value�� �ش�)
�� value���� ã�ƿͼ� comment [message, uid, timestamp] �� �־��ְ� ����Ʈ�� append ������.

�̷��� �ϸ� DB�󿡼� ������ ������ �ð������� �����ؼ� �޾ƿ��� ������ tableView�� �ѷ��� �� �ٷ� ������� �ѷ��ָ��!