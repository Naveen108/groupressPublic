import 'package:groupres/DataModels/list_item_class.dart';
import 'package:groupres/DataModels/menu_item_class.dart';
import 'package:groupres/DataModels/user_model.dart';
import 'package:groupres/DataModels/create_group_class.dart';
import 'package:groupres/DataModels/invite_new_friend_class.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:groupres/DataModels/query.dart';
import 'dart:async';

class GroupRestModel extends Model {
  //Menuscreeen Items
  List<MenuItemClass> menuListCollection = <MenuItemClass>[];
  //mycart total bill
  int yourOrderCharges = 0;
  //mycart item list
  List<MenuItemClass> myCartList = <MenuItemClass>[];
  //groupcart item list
  List<ListItemClass> groupListCollection = <ListItemClass>[];
  //group cart list
  List<MenuItemClass> groupCartList = <MenuItemClass>[];
  //friends list
  List<ListItemClass> friendListCollection = <ListItemClass>[];
  //group cart total bill
  int groupOrderCharges = 0;

  String cartTable = '';
  //bool function to check table to query
  void checkcart(bool check) {
    if (check == true) {
      cartTable = 'newitem_carts';
    } else {
      cartTable = 'menuitem_cart';
    }
  }

  //MenuLists function to generate menulistCollection from fetched menu item from DB
  //fine
  Future<dynamic> menuLists(List<List<dynamic>> fetchedList) async {
    menuListCollection = <MenuItemClass>[];
    for (final row in fetchedList) {
      MenuItemClass item = new MenuItemClass();
      item.newitem = false;
      item.itemid = row[3];
      item.itemTitle = row[0];
      item.itemDetails = row[1];
      item.itemCost = row[2];
      item.itemImage = row[4];
      item.itemQuantity = 0;

      myCartList.forEach((anItem) {
        if (anItem.itemTitle == item.itemTitle) {
          item.itemQuantity = anItem.itemQuantity;
          print(
              'i am updaing the menu list here of itemid= ${item.itemid}and itemtitle = ${item.itemTitle} with quantity = ${item.itemQuantity}');
        }
      });

      menuListCollection.add(item);
    }
  }

  //fetch function for menuitems from DB
  //fine
  Future<dynamic> fetchMenuItems() async {
    print('in ftech now');
    String myQuery = """
    Select * 
    FROM menuitem 
    ORDER BY item_id ASC
    """;
    try {
      //print('data recrevied from query in fetch -->> + $data');
      return fetchMyCartItems().then((data) async {
        return await queryMenu(myQuery).then((data) async {
          return await menuLists(data).then((data) {
            notifyListeners();
            return data;
          });
        });
      });
    } catch (e) {
      print('got error in fetch');
      print(e);
      return false;
    }
  }

  //increase quantity function for MenuScreen
  //queries check if quantity is 0 initially -does insertion for first time
  // if already there then does update
  //fine
  increaseQuantityM(MenuItemClass cartItem) async {
    checkcart(cartItem.newitem);
    int newQuantity;
    print('Called in +Qm $cartItem');
    String myQuery = """
    SELECT item_quantity
    FROM $cartTable
    WHERE cart_id  = '${UserModel.cartId}'
    AND 
    item_id = '${cartItem.itemid}'
     """;
    String myQuery2 = """
    INSERT INTO $cartTable
    (cart_id , item_id , item_quantity)
    Values
    ('${UserModel.cartId}','${cartItem.itemid}',1);
    """;
    try {
      return await queryMenu(myQuery).then((data) async {
        print('data received in qupm after qg${data}');
        if (data.length == 0) {
          print('i received from queryG -->> ${data}');
          return await queryUser(myQuery2).then((data) async {
            if (data == true) {
              print(
                  'data recevied from insert query cart at menuincrease $data');
              return true;
            } else {
              print(
                  'data recevied from first select query for cart at groupcart $data');
              return false;
            }
          });
        } else {
          newQuantity = data[0][0];
          newQuantity = newQuantity + 1;
          String myQuery1 = """
          UPDATE $cartTable
          SET item_quantity = $newQuantity
          WHERE cart_id  = '${UserModel.cartId}'
          AND 
          item_id = '${cartItem.itemid}'
          """;
          print(
              'i am in else of queryG with newdata $newQuantity and prev data $data');

          return await queryUser(myQuery1).then((data) async {
            if (data == true) {
              print('data recevied from update query at groupcart $data');
              return true;
            } else {
              return false;
            }
          });
        }
      });
    } catch (e) {
      print(e);
      print(' ERROR IN GroupCartModel while increasing a itemquanity');
      print(e);
      return false;
    }
  }

  //increase quantity function for MycartScreen
  // if already there then does update
  //fine
  increaseQuantity(MenuItemClass cartItem) async {
    checkcart(cartItem.newitem);
    int newQuantity = cartItem.itemQuantity + 1;
    print(cartItem);
    //cartItem.itemQuantity = newQuantity;
    String myQuery = """
    UPDATE $cartTable
    SET item_quantity = $newQuantity
    WHERE cart_id  = '${UserModel.cartId}'
    AND 
    item_id = '${cartItem.itemid}'
    """;
    try {
      return await queryUser(myQuery).then((data) async {
        if (data == true) {
          print(data);
          return true;
        } else {
          return false;
        }
      });
    } catch (e) {
      print(e);
      print(
          'I HAVE COUGHT ERROR IN MyCartModel while increasing a itemquanity');
      print(e);
      return false;
    }
  }

  //decrease quantity function for MycartScreen,
  // if already there then does update.checks for limit of 0 .
  //fine
  decreaseQuantity(MenuItemClass cartItem) async {
    checkcart(cartItem.newitem);
    print('--------called decreaseQ here');
    int newQuantity;
    print(cartItem);

    //if item has been deacresed need to check user's quantity

    String myQuery0 = """
          SELECT item_quantity
          FROM $cartTable
          WHERE cart_id  = '${UserModel.cartId}'
          AND 
          item_id = '${cartItem.itemid}'
          """;

    await queryMenu(myQuery0).then((data) async {
      if (data.length != 0) {
        print('called menu query as true $data');
        cartItem.itemQuantity = data[0][0];
      }

      if (cartItem.itemQuantity > 0) {
        newQuantity = cartItem.itemQuantity - 1;

        cartItem.itemQuantity = newQuantity;
        String myQuery;
        if (newQuantity != 0) {
          myQuery = """
          UPDATE $cartTable
          SET item_quantity = $newQuantity
          WHERE cart_id  = '${UserModel.cartId}'
          AND 
          item_id = '${cartItem.itemid}'
          """;
        } else {
          myQuery = """
        DELETE FROM $cartTable
        WHERE '${cartItem.itemid}' = item_id 
        AND cart_id = '${UserModel.cartId}'
        """;
        }

        try {
          return await queryUser(myQuery).then((data) async {
            if (data == true) {
              print(data);
              return true;
            } else {
              return false;
            }
          });
        } catch (e) {
          print(e);
          print('ERROR IN MyCartModel while increasing a itemquanity');
          print(e);
          return false;
        }
      } else {
        return false;
      }
    });
  }

  //function for generating the mycartlists for the mycartscreen after fetching from DB
  //fine
  Future<dynamic> myCartLists(
      List<List<dynamic>> fetchedList, bool check) async {
    if (check == false) {
      yourOrderCharges = 0;
      myCartList = <MenuItemClass>[];
    }
    for (final row in fetchedList) {
      if (row[3] != 0) {
        MenuItemClass item = new MenuItemClass();
        item.itemid = row[0];
        item.newitem = check;
        item.itemQuantity = row[3];
        item.itemTitle = row[1];
        item.itemCost = row[2];
        myCartList.add(item);
        yourOrderCharges =
            yourOrderCharges + (item.itemCost) * (item.itemQuantity);
      }
    }
    print('here is myCartList  the list ==$myCartList');
    return true;
  }

  //function for fetching all the my cart item from Db of a user
  //fine
  Future<dynamic> fetchMyCartItems() async {
    String myQuery = """
    SELECT M.item_id,M.item_title,M.item_cost ,C.item_quantity ,C.cart_id 
    FROM menuitem M
    INNER JOIN menuitem_cart C ON C.cart_id = '${UserModel.cartId}' AND M.item_id = C.item_id
    ORDER BY M.item_id ASC 
    """;
    try {
      return await queryMenu(myQuery).then((data) async {
        print('for user:- ${UserModel.userPhoneNumber} recieved myCart $data');
        return await myCartLists(data, false).then((data) {
          fetchMyNewCartItems();
          notifyListeners();
          return true;
        });
      });
    } catch (e) {
      print('I HAVE COUGHT ERROR IN MyCartModel while fetching my cart');
      print(e);
      return false;
    }
  }

  Future<dynamic> fetchMyNewCartItems() async {
    String myQuery = """
    SELECT M.item_id,M.item_title,M.item_cost ,C.item_quantity ,C.cart_id 
    FROM newitem M
    INNER JOIN newitem_carts C ON C.cart_id = '${UserModel.cartId}' AND M.item_id = C.item_id 
     ORDER BY M.item_id ASC 
    """;
    try {
      return await queryMenu(myQuery).then((data) async {
        print('for user:- ${UserModel.userPhoneNumber} recieved myCart $data');
        return await myCartLists(data, true).then((data) {
          notifyListeners();
          return true;
        });
      });
    } catch (e) {
      print('I HAVE COUGHT ERROR IN MyCartModel while fetching my cart');
      print(e);
      return false;
    }
  }

  //function for generating group lists(in groups a user is ) for the whole group ,after fetching from DB
  //fine
  Future<dynamic> groupLists(List<List<dynamic>> fetchedList) async {
    groupListCollection = <ListItemClass>[];
    for (final row in fetchedList) {
      ListItemClass item = new ListItemClass();
      item.listItemName = row[0];
      item.members = 0;
      item.group_id = row[1];
      item.cart_id = row[2];
      print('group_id ${row[1]} cart_id ${row[2]}');
      await fetchFriendListLength(row[1]).then((data) {
        item.members = data;
      });
      groupListCollection.add(item);
    }
    print('grouplist items after fetch  is => $groupListCollection');
    return true;
  }

  //fetch function for the grouplist from DB
  //fine
  Future<dynamic> fetchGroupItems() async {
    print(UserModel.userPhoneNumber);
    String myQuery = """
    SELECT M.group_name ,M.group_id,C.cart_id
    FROM groups M 
    INNER JOIN groupusers C 
    ON C.group_id = M.group_id 
    WHERE C.user_phone = '${UserModel.userPhoneNumber}'
    """;

    try {
      return await queryMenu(myQuery).then((data) async {
        print('for user:- ${UserModel.userPhoneNumber} recieved groups $data');
        return await groupLists(data).then((data) {
          print('fetch was called for groups-->$data');
          notifyListeners();
        });
      });
    } catch (e) {
      print(e);
      return false;
    }
  }

//function for the new group create by a user
//fine
  Future<dynamic> createGroup(CreateNewGroup newGroup) async {
    print('create  group called');
    String groupName = newGroup.groupName;
    int groupid;
    String myQuery1 =
        "select group_id from groups where group_name='$groupName' AND superuser = '${UserModel.userPhoneNumber}'";
    String myQuery2 =
        "INSERT INTO  groups(group_name,superuser) VALUES ('$groupName','${UserModel.userPhoneNumber}') ";

    try {
      return await queryMenu(myQuery1).then((data) async {
        if (data.length == 0) {
          return await queryUser(myQuery2).then((data) {
            if (data == true) {
              return queryMenu(myQuery1).then((data) async {
                if (data.length != 0) {
                  print(data[0][0]);
                  groupid = data[0][0];
                  String myQuery3 =
                      "INSERT INTO  groupusers(user_phone,group_id) VALUES ('${UserModel.userPhoneNumber}','$groupid') ";

                  return await queryUser(myQuery3).then((data) {
                    if (data == true) {
                      fetchGroupItems();
                      return true;
                    }
                  });
                }
              });
            } else {
              print('Found a group with id $data already');
              return false;
            }
          });
        }
      });
    } catch (e) {
      print(e);
      print('I HAVE COUGHT ERROR IN UerModel while creating group');
      print(e);
      return false;
    }
  }

  Future<dynamic> deleteGroup(CreateNewGroup newGroup) async {
    //this query should
    //delete the userlist
    //delete the cart item list from both carts
    //relations are used here
    print('delete  group called');
    int group_id = newGroup.group_id;
    String myQuery =
        "DELETE FROM  groups WHERE group_id = '$group_id' AND superuser ='${UserModel.userPhoneNumber}'";
    try {
      return await queryUser(myQuery).then((data) async {
        if (data == true) {
          print(data);
          if (UserModel.groupId == group_id) {
            UserModel.currentGroup = 'GR';
            UserModel.groupId = 0;
          }
          return await fetchGroupItems().then((data) {
            notifyListeners();
          });
        } else {
          return false;
        }
      });
    } catch (e) {
      print(e);
      print('I HAVE COUGHT ERROR IN UerModel while creating group');
      print(e);
      return false;
    }
  }

  // generates the total buy bill of the group item and quantitywise
  //includes the user's buys also here
  Future<dynamic> groupCartLists(
      List<List<dynamic>> fetchedList, bool check, bool guest) async {
    //check is tell is it newcart ->true or menucart =->false
    //guest is telling it isguest cart or not
    if (check == false && guest == false) {
      groupOrderCharges = 0;
      groupCartList = <MenuItemClass>[];
    }
    if (UserModel.currentGroup != 'GR') {
      for (final row in fetchedList) {
        if (row[3] != 0) {
          MenuItemClass item = new MenuItemClass();
          int flag = 0;
          item.itemid = row[0];
          item.newitem = check;
          item.itemQuantity = row[3];
          item.itemTitle = row[1];
          item.itemCost = row[2];
          item.friends = <Friendsitems>[];
          Friendsitems frienditem = new Friendsitems();
          frienditem.friendName = row[6];
          frienditem.friendQuantity = row[3];
          item.friends.add(frienditem);
          print('friends list adding ${item.friends} with ${row[6]}');

          groupCartList.forEach((anItem) {
            //for checking user's count and add them in it
            if (anItem.itemid == item.itemid &&
                anItem.newitem == check &&
                item.newitem == check) {
              Friendsitems myitem = new Friendsitems();
              myitem.friendName = row[6];
              myitem.friendQuantity = row[3];
              anItem.friends.add(myitem);
              anItem.itemQuantity = anItem.itemQuantity + item.itemQuantity;
              flag = 1;
            }
          });
          if (flag == 0) {
            print('${item.friends}finally');
            groupCartList.add(item);
          }
          groupOrderCharges =
              groupOrderCharges + (item.itemCost) * (item.itemQuantity);
        }
      }
    }
    print('here is groupCartList  the list ==$groupCartList');
    return true;
  }

  //fetch function for the groupcart list of the group only called when cart is selected
  Future<dynamic> fetchGroupCartItems() async {
    String myQuery = """ 
    SELECT M.item_id,M.item_title,M.item_cost ,C.item_quantity ,C.cart_id ,T.user_phone,U.user_name
    FROM menuitem M
    INNER JOIN groupusers G ON G.group_id = '${UserModel.groupId}'
    INNER JOIN menuitem_cart C ON C.cart_id = G.cart_id AND M.item_id = C.item_id
    INNER JOIN groupusers T ON G.cart_id = T.cart_id
    INNER JOIN users U ON T.user_phone = U.user_phone
     ORDER BY M.item_id ASC 
    """;
    try {
      return await queryMenu(myQuery).then((data) async {
        print('for user:- ${UserModel.userPhoneNumber} recieved myCart $data');
        return await groupCartLists(data, false, false).then((data) {
          //this will fetch alluser whoare registered there carts
          fetchGroupNewCartItems().then((data) async {
            //need to fetch guest carts also
            await fetchGuestGroupCartItems().then((data) {
              print('fetch was called for groupCartLists-->$data');
              notifyListeners();
            });
          });
        });
      });
    } catch (e) {
      print('I HAVE COUGHT ERROR IN GroupCartModel while fetching my cart');
      print(e);
      return false;
    }
  }

  //fetch function for the groupcart list of the group only called when cart is selected
  Future<dynamic> fetchGuestGroupCartItems() async {
    String myQuery = """ 
    SELECT M.item_id,M.item_title,M.item_cost ,C.item_quantity ,C.cart_id ,T.user_phone,U.guest_name
    FROM menuitem M
    INNER JOIN groupusers G ON G.group_id = '${UserModel.groupId}'
    INNER JOIN menuitem_cart C ON C.cart_id = G.cart_id AND M.item_id = C.item_id
    INNER JOIN groupusers T ON G.cart_id = T.cart_id
    INNER JOIN guests U ON T.user_phone = U.guest_phone
     ORDER BY M.item_id ASC 
    """;
    try {
      return await queryMenu(myQuery).then((data) async {
        print('for user:- ${UserModel.userPhoneNumber} recieved myCart $data');
        return await groupCartLists(data, false, true).then((data) {
          fetchGroupGuestNewCartItems().then((data) {
            print('fetch was called for groupCartLists-->$data');
            notifyListeners();
          });
        });
      });
    } catch (e) {
      print('I HAVE COUGHT ERROR IN GroupCartModel while fetching my cart');
      print(e);
      return false;
    }
  }

  Future<dynamic> fetchGroupGuestNewCartItems() async {
    String myQuery = """ 
    SELECT M.item_id,M.item_title,M.item_cost ,C.item_quantity ,C.cart_id ,T.user_phone,U.guest_name
    FROM newitem M
    INNER JOIN groupusers G ON G.group_id = '${UserModel.groupId}'
    INNER JOIN newitem_carts C ON C.cart_id = G.cart_id AND M.item_id = C.item_id
    INNER JOIN groupusers T ON G.cart_id = T.cart_id
    INNER JOIN guests U ON T.user_phone = U.guest_phone
     ORDER BY M.item_id ASC 
    """;
    try {
      return await queryMenu(myQuery).then((data) async {
        print('for user:- ${UserModel.userPhoneNumber} recieved myCart $data');
        return await groupCartLists(data, true, true).then((data) {
          print('fetch was called for groupCartLists-->$data');
          notifyListeners();
        });
      });
    } catch (e) {
      print('I HAVE COUGHT ERROR IN GroupCartModel while fetching my cart');
      print(e);
      return false;
    }
  }

  Future<dynamic> fetchGroupNewCartItems() async {
    String myQuery = """ 
    SELECT M.item_id,M.item_title,M.item_cost ,C.item_quantity ,C.cart_id ,T.user_phone,U.user_name
    FROM newitem M
    INNER JOIN groupusers G ON G.group_id = '${UserModel.groupId}'
    INNER JOIN newitem_carts C ON C.cart_id = G.cart_id AND M.item_id = C.item_id
    INNER JOIN groupusers T ON G.cart_id = T.cart_id
    INNER JOIN users U ON T.user_phone = U.user_phone
     ORDER BY M.item_id ASC 
    """;
    try {
      return await queryMenu(myQuery).then((data) async {
        print('for user:- ${UserModel.userPhoneNumber} recieved myCart $data');
        return await groupCartLists(data, true, false).then((data) {
          print('fetch was called for groupCartLists-->$data');
          notifyListeners();
        });
      });
    } catch (e) {
      print('I HAVE COUGHT ERROR IN GroupCartModel while fetching my cart');
      print(e);
      return false;
    }
  }

//function for generatin the friends lists when the friend screen is called
  Future<dynamic> friendList(
      List<List<dynamic>> fetchedList, bool check) async {
    if (check == true) {
      friendListCollection = <ListItemClass>[];
    }
    for (final row in fetchedList) {
      ListItemClass item = new ListItemClass();
      item.listItemName = row[0];
      item.phone = row[1].toString();
      print(row[0]);
      friendListCollection.add(item);
    }
    print('here is friends  the list ==$friendListCollection');
    return true;
  }

//fetch function for the friend lists number of members for making it visible in grouplist
// of selected group ,fetchs only when the friendscreen is called
  Future<int> fetchFriendListLength(int groupid) async {
    String myQuery =
        "SELECT * from groupusers where '$groupid'=group_id"; //use ->$currentGroup
    try {
      return await queryMenu(myQuery).then((data) async {
        print(
            'for user:- ${UserModel.userPhoneNumber} recieved fetchFriendListLength $data');
        return data.length;
      });
    } catch (e) {
      print('ERROR IN FriendModel while fetching a friends of group');
      print(e);
      return 0;
    }
  }

//fetch function for the friend lists of the selected group
// of selected group ,fetchs only when the friendscreen is called
//fetch guest also
  Future<dynamic> fetchFriendItems(int groupid) async {
    String myQuery = """
    SELECT M.user_name , M.user_phone 
    FROM users M 
    INNER JOIN groupusers C 
    ON C.group_id = '$groupid' 
    WHERE 
    M.user_phone = C.user_phone
    """;
    try {
      return await queryMenu(myQuery).then((data) async {
        print('for user:- ${UserModel.userPhoneNumber} recieved groups $data');
        return await friendList(data, true).then((data) {
          fetchGuestFriendItems(groupid);
          print('fetch was called for friend-->$data');
          notifyListeners();
        });
      });
    } catch (e) {
      print(' ERROR IN FriendModel while fetching a friends of group');
      print(e);
      return false;
    }
  }

  Future<dynamic> fetchGuestFriendItems(int groupid) async {
    String myQuery = """
    SELECT M.guest_name , M.guest_phone 
    FROM guests M 
    INNER JOIN groupusers C 
    ON C.group_id = '$groupid'
    WHERE C.user_phone = M.guest_phone
    """;
    try {
      return await queryMenu(myQuery).then((data) async {
        print(
            'for user:- ${UserModel.userPhoneNumber} recieved guestgroups $data');
        return await friendList(data, false).then((data) {
          print('fetch was called for friend-->$data');
          notifyListeners();
        });
      });
    } catch (e) {
      print(
          'I HAVE COUGHT ERROR IN FriendModel while fetching a friends of group');
      print(e);
      return false;
    }
  }

//function to handle a new invite friend request in friendscreen , user pust number and request add the user in list of DB.
  Future<dynamic> inviteFriend(InviteNewFriend newFriend) async {
    //for invite friend just add the phone number in the groupuser list
    print('Invite friend called');
    int groupId = newFriend.groupId;
    String friendNumber = newFriend.friendNumber;

    //Conatct Name should be fetched from User's Phone
    //To be implemeted

    //check if invited  user already there in the list
    String myQuery1 = """
    SELECT user_phone
    FROM groupusers
    WHERE user_phone = '${friendNumber}'
    AND 
    group_id = '${UserModel.groupId}'
    """;
    // if invited  user not there in the list add him
    String myQuery2 = """
    INSERT INTO groupusers
    (user_phone,group_id)
    VALUES
    ('${friendNumber}', '${UserModel.groupId}')  
    """;
    //check  if invited  user is there in users
    String myQuery3 = """
    SELECT user_phone
    FROM users
    WHERE user_phone = '${friendNumber}'
    """;
    //if invited  user is not there in users add  to guests
    String myQuery4 = """
    INSERT INTO guests
    (guest_phone,guest_name)
    VALUES
    ('${friendNumber}','Guest')  
    """;

    try {
      await queryMenu(myQuery1).then((data) async {
        print('query 1 in invite friend is $data ');
        if (data.length == 0) {
          return await queryUser(myQuery2).then((data) async {
            //hence add the usre in the list groupusers
            print('query 2 in invite friend is $data ');
            return await queryMenu(myQuery3).then((data) {
              if (data.length == 0) {
                //invited user is a guest table candidate
                return queryUser(myQuery4).then((data) {
                  print('Guest added $data');
                  print('in invit friend second query $data');
                  fetchFriendItems(groupId);
                  return true;
                });
              } else {
                //user is there in the users table
                print('in invit friend second query $data');
                fetchFriendItems(groupId);
                return true;
              }
            });
          });
        } else {
          return false;
        }
      });
    } catch (e) {
      print(e);
      print('ERROR  while inviting a friend in group');
      print(e);
      return false;
    }
  }

  //for inserting new item in the list
  //fine
  Future<dynamic> insertNewItem(MenuItemClass cartItem) async {
    //five query to be done

    //Frist query to check inserting item alrady there in newitem tabel
    int newItemId;
    int newquantity;

    String myQuery1 = """
    SELECT item_id
    FROM newitem
    WHERE item_title = '${cartItem.itemTitle} '
    AND 
    item_cost = '${cartItem.itemCost}'
    """;
    //second if the item need to be inserted
    String myQuery2 = """
    INSERT INTO newitem
    (item_title,item_cost)
    VALUES
    ('${cartItem.itemTitle} ','${cartItem.itemCost}')
    """;

    print('Called in +InsertNewItem $cartItem');
    try {
      await queryMenu(myQuery1).then((data) async {
        print('query 1  ->data $data and datalength ${data.length}}');
        if (data.length == 0) {
          //need insert in newitem
          await queryUser(myQuery2).then((data) async {
            if (data == true) {
              await queryMenu(myQuery1).then((data) async {
                print(
                    'query 1 2 call ->data $data and datalength ${data.length}}');
                if (data.length != 0) {
                  newItemId = data[0][0];
                  print('SET ->data $data and datalength ${data[0][0]}}');
                }
              });
            }
          });
        } else {
          //got the item id here
          newItemId = data[0][0];
        }
      });
      //part 2 of the insertion here
      //third Query to check my user needs insert or update
      String myQuery3 = """
      SELECT item_quantity
      FROM newitem_carts
      WHERE item_id = '${newItemId}'
      AND 
      cart_id = '${UserModel.cartId}'
      """;
      //forth Query to  my user needs insert
      String myQuery4 = """
      INSERT INTO newitem_carts
      (item_id,cart_id,item_quantity)
      VALUES
      ('${newItemId} ','${UserModel.cartId}','${cartItem.itemQuantity}')
      """;

      return await queryMenu(myQuery3).then((data) async {
        print('query 3  ->data $data and datalength ${data.length}}');
        if (data.length == 0) {
          //means need insert else update
          return await queryUser(myQuery4).then((data) async {
            print('query 4  ->data $data');
            if (data == true) {
              fetchGroupCartItems();
              fetchMyCartItems();
              return true;
            }
          });
        } else {
          //hence need update
          print('SET ->data $data and datalength ${data[0][0]}}');
          newquantity = data[0][0] + cartItem.itemQuantity;
          //fifth Query to check my user needs update
          String myQuery5 = """
          UPDATE newitem_carts
          SET item_quantity =  $newquantity
          WHERE 
          cart_id = '${UserModel.cartId}'
          AND
          item_id = '${newItemId}'
          """;
          return await queryUser(myQuery5).then((data) async {
            print('query 5  ->data $data added $newItemId');
            if (data == true) {
              fetchGroupCartItems();
              fetchMyCartItems();
              return true;
            }
          });
        }
      });
    } catch (e) {
      print(e);
      print(' ERROR IN GroupCartModel while increasing a itemquanity');
      print(e);
      return false;
    }
  }
}
