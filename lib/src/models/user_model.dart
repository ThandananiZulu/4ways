
class User {
  final String name;
  final String imageUrl;
final int userID;

  const User({
    required this.name,
    required this.imageUrl, 
    required this.userID,
  });
}
const user = User(
userID: 0,
  name: 'John Doe',
  imageUrl: 'https://images.unsplash.com/photo-1578133671540-edad0b3d689e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1351&q=80',
);

