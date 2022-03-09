class Post {
  final String imageFile;
  final String postTitle;
  final String postSubTitle;
  final String postDescription;

  const Post(
      {required this.postTitle,
      required this.postSubTitle,
      required this.postDescription,
      required this.imageFile});
}

const THREADS = [
  Post(
      postTitle: "Jado",
      postSubTitle: "Employees",
      postDescription:
          "Ugize gutya uryamanye n'umukobwa w'imyaka 17, umuteye inda, yirirwa hirya no hino ashaka icumbi, inzara yenda kumwicana n'abana",
      imageFile: "assets/avatars/Rectangle 13.png"),
  Post(
      postTitle: "Pandas",
      postSubTitle: "Employees",
      postDescription:
          "Impanga, nyuma uti abana si abanjye kuko ni umusinzi & n'indaya! None se Kuba abana atari abawe, bikuraho ko mwaryamanye wamusindishije,ku myaka 17",
      imageFile: "assets/avatars/Rectangle 14.png"),
  Post(
      postTitle: "Dog",
      postSubTitle: "Employees",
      postDescription:
          "Ariko ubundi bagiye bareka kwangiza abana bakajya ku bo bangana cg kugura indaya niba imibiri iba yabarembeje baba iki?",
      imageFile: "assets/avatars/Rectangle 15.png"),
  Post(
      postTitle: "Goat123",
      postSubTitle: "Drivers",
      postDescription:
          "Njye mbona hageze ko aba bantu bafatirwa ibindi bihano ntazi kuko ubumuntu no gushyira mu gaciro byo ntabyo tubategerejeho",
      imageFile: "assets/avatars/Rectangle 16.png"),
  Post(
      postTitle: "WaterMo",
      postSubTitle: "Drivers",
      postDescription:
          "Ariko umenya ntabakobwa bakibaho bigurisha imibiri yabo ! Kuki bajya mumpinja Koko! Bigomba guhinduka ntibakitwaze Icyo baricyo NGO bangize abana bejo hazaza!",
      imageFile: "assets/avatars/Rectangle 17.png"),
  Post(
      postTitle: "UBT123",
      postSubTitle: "Employees",
      postDescription:
          "Birababaje abantu bakora ibintu nkabiriya Leta nibafatire ibyrmezo kuko nibenshi nibyo ubona abantu birirwa batabaza ngo Leta ibagashe base bigaramiye.",
      imageFile: "assets/avatars/Rectangle 25-1.png"),
  Post(
      postTitle: "motion123",
      postSubTitle: "Drivers",
      postDescription:
          "Ni agahinda! Bibaye koko byarabaye ko amuha ibiyobyabwenge, akamusambanya  akanamugira uko nabonye byaba ari agahomamunwa",
      imageFile: "assets/avatars/Rectangle 25.png"),
];
