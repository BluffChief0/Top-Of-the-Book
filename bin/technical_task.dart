import 'dart:io';

void main(List<String> arguments) {
  Map<String, Map<String, List<int>>> orders = {}; // хранилище со всеми заказами

  while (true) {
    String s = stdin.readLineSync() ?? '';
    List<dynamic> inputData = s.split(';');
    String userId = inputData[0];
    String clorderId = inputData[1];
    int action = int.parse(inputData[2]);
    int instrumentId = int.parse(inputData[3]);
    String side = inputData[4];
    int price = int.parse(inputData[5]);
    int amount = int.parse(inputData[6]);
    int amountRest = int.parse(inputData[7]);

    String instrumentKey = "$instrumentId: $side"; // ключ однозначно определяющий иструмент и сторону заявки
    
    int oldBestPrice = side == 'B' ? 0 : 999999999999999999;
    int oldAmount = 0;

    // находим старую лучшую цену и кол-во для instrumentKey    
    if (orders.containsKey(instrumentKey)) {
      if (side == 'B') {
        orders[instrumentKey]!.values.toList().forEach((element) {
          if (element[0] > oldBestPrice) {
            oldBestPrice = element[0];
            oldAmount = element[1];
          } else if (element[0] == oldBestPrice) {
            oldAmount += element[1];
          }
         });
      } else if (side == 'S') {
        orders[instrumentKey]!.values.toList().forEach((element) {
          if (element[0] < oldBestPrice) {
            oldBestPrice = element[0];
            oldAmount = element[1];
          } else if (element[0] == oldBestPrice) {
            oldAmount += element[1];
          }
         });
      }
    }
  
    String orderKey = "$userId: $clorderId"; // ключ однозначно определяющий id заказа

    // обработка нашего хранилища
    switch (action) {
      case 0: {
        if (orders[instrumentKey] == null) {
          orders[instrumentKey] = {};
        }
        orders[instrumentKey]![orderKey] = [price, amount];
        break;
        }
      case 1: {
        orders[instrumentKey]!.remove(orderKey);
        break;
        }
      case 2: {
        if (amountRest == 0) {
          orders[instrumentKey]!.remove(orderKey);
        } else {
          orders[instrumentKey]![orderKey] = [price, amountRest];
        }
        break;
        }
    }

    // смотрим, что выводить после изменения хранилища в зависимости от действия с заявкой и от стороны заявки
    // сторона влияет только оператор сравнения цены и начальную цену
    if (side == 'B') {
      switch (action) {
        case 0: {
          if (oldBestPrice == price) {
            print('$instrumentId;B;$oldBestPrice;${oldAmount + amount}');
          } else if (oldBestPrice < price) {
            print('$instrumentId;B;$price;$amount');
          }
          break;
        }
        case 1: {
          if (amount < oldAmount) {
            print('$instrumentId;B;$oldBestPrice;${oldAmount - amount}');
          } else if (amount == oldAmount) {
            int newBestPrice = 0;
            int newAmount = 0;
            if (orders[instrumentKey] != null) {
              orders[instrumentKey]!.values.toList().forEach((element) {
                if (element[0] > newBestPrice) {
                  newBestPrice = element[0];
                  newAmount = element[1];
                } else if (element[0] == newBestPrice) {
                  newAmount += element[1];
          }
              });
            }
            print('$instrumentId;B;$newBestPrice;$newAmount');
          }
          break;
        }
        case 2: {
          if (amountRest > 0 || amount < oldAmount) {
            print('$instrumentId;B;$oldBestPrice;${oldAmount - amount}');
          } else if (amount == oldAmount) {
            int newBestPrice = 0;
            int newAmount = 0;
            if (orders[instrumentKey] != null) {
              orders[instrumentKey]!.values.toList().forEach((element) {
                if (element[0] > newBestPrice) {
                  newBestPrice = element[0];
                  newAmount = element[1];
                } else if (element[0] == newBestPrice) {
                  newAmount += element[1];
          }
              });
            }
            print('$instrumentId;B;$newBestPrice;$newAmount');
          }
          break;
        }
      }
    } else if (side == 'S') {
      switch (action) {
        case 0: {
          if (oldBestPrice == price) {
            print('$instrumentId;S;$oldBestPrice;${oldAmount + amount}');
          } else if (oldBestPrice > price) {
            print('$instrumentId;S;$price;$amount');
          }
          break;
        }
        case 1: {
          if (amount < oldAmount) {
            print('$instrumentId;S;$oldBestPrice;${oldAmount - amount}');
          } else if (amount == oldAmount) {
            int newBestPrice = 999999999999999999;
            int newAmount = 0;
            if (orders[instrumentKey] != null) {
              orders[instrumentKey]!.values.toList().forEach((element) {
                if (element[0] < newBestPrice) {
                  newBestPrice = element[0];
                  newAmount = element[1];
                } else if (element[0] == newBestPrice) {
                  newAmount += element[1];
          }
              });
            }
            print('$instrumentId;S;$newBestPrice;$newAmount');
          }
          break;
        }
        case 2: {
          if (amountRest > 0 || amount < oldAmount) {
            print('$instrumentId;S;$oldBestPrice;${oldAmount - amount}');
          } else if (amount == oldAmount) {
            int newBestPrice = 999999999999999999;
            int newAmount = 0;
            if (orders[instrumentKey] != null) {
              orders[instrumentKey]!.values.toList().forEach((element) {
                if (element[0] < newBestPrice) {
                  newBestPrice = element[0];
                  newAmount = element[1];
                } else if (element[0] == newBestPrice) {
                  newAmount += element[1];
          }
              });
            }
            print('$instrumentId;S;$newBestPrice;$newAmount');
          }
          break;
        }
      }
    }
  }
}
