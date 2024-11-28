import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

import '../comms/credentials.dart';
import '../utils/utils.dart';

class SocketApi {
  static SocketApi? _instance;
  Socket? live_socket;

  static SocketApi getInstance() {
    bool recreate = _instance == null;

    if (recreate) {
      printLog("################\nRecreate new Socket conn\n#################");
      _instance = new SocketApi();
      _instance!.live_socket = io(
          chatwesbsockURL,
          OptionBuilder()
              .setTransports(['websocket']) // for Flutter or Dart VM
              .enableForceNew()
              //.disableAutoConnect() // disable auto-connection
              .setTimeout(10000)
              .build());
    }

    return _instance!;
  }

  void Disconnect() {
    printLog("We done. Disconnect");
    try {
      if (live_socket!.connected) {
        live_socket!.disconnect();
      } else
        printLog("Was not connected");
      live_socket!.clearListeners();
      live_socket!.destroy();
      _instance == null;
    } catch (E) {
      printLog("Error Disonnecting $E");
    }
  }

  void Connect(String chatid, Function recieveddata) async {
    printLog("Connect to Live socket on url $chatwesbsockURL for  Id $chatid");
    live_socket!.connect();
    printLog("Tag events");

    live_socket!.onConnect((data) {
      printLog("Chat Socket now connected");
      live_socket!.emit("client", {"fuel_request_id": chatid});

      live_socket!.on("dispense", (data) {
        printLog("CLASS Got chat Data $data. PUSSHHHH");
        recieveddata(data);
      });
    });
    live_socket!.onDisconnect((_) => print('\nLive Chat disconnect'));
    live_socket!.onConnectError((_) => print('\nLive Chat connect error $_'));
    live_socket!.onError((_) => print('\nLive Chat  error $_'));
  }

  Socket? socket() {
    return live_socket!;
  }

  Future<bool> UpdateLocation(driverId, fpId, latitude, longitude, isAvailable,
      truckCapacity, truckPrice, truckLicencePlate) async {
    printLog("Update My location}}");

    if (live_socket!.connected) {
      live_socket!.emit('loc', {
        "driverId": driverId,
        "fpId": fpId,
        "latitude": latitude,
        "longitude": longitude,
        "isAvailable": isAvailable,
        "truckCapacity": truckCapacity,
        "truckPrice": truckPrice,
        "truckLicencePlate": truckLicencePlate
      });
      return true;
    } else {
      return false;
    }
  }
}
