class Friendsitems {
  String friendName;
  int friendQuantity;
  Friendsitems({this.friendName, this.friendQuantity});
}

class MenuItemClass {
  int itemid;
  bool newitem;
  String itemImage;
  String itemTitle;
  String itemDetails;
  int itemCost;
  int itemQuantity;
  List<Friendsitems> friends;
  MenuItemClass(
      {this.itemImage,
      this.itemCost,
      this.itemDetails,
      this.itemQuantity,
      this.itemTitle,
      this.itemid,
      this.friends,
      this.newitem});
}
