class Uuid {
  // ignore: avoid_init_to_null
  Uuid({required this.uid, required this.deviceId, this.contacts = null});
  String uid;
  String deviceId;
  List<ContactDevices>? contacts;
  late int nearbyDeviceCount;
  List<ContactDevices>? parseString (){
    if(contacts == null) contacts = [];
    this.nearbyDeviceCount = int.parse(this.uid.substring(0,2), radix: 16);
      if(this.nearbyDeviceCount == 1){
        print("Nearby Count 1");
        var nearbyTime = int.parse(this.uid.substring(2,4), radix: 16);
        var nearbyGroupId = int.parse(this.uid.substring(4,8),radix: 16);
        var nearbySerialid = int.parse(this.uid.substring(8,12),radix: 16);
        contacts!.add(ContactDevices(deviceID: nearbySerialid, groupId: nearbyGroupId, nearbyTime: nearbyTime));

      } else  if (this.nearbyDeviceCount == 2) {
        print("Nearby Count 2");
        var nearbyTime = int.parse(this.uid.substring(2,4), radix: 16);
        var nearbyGroupId = int.parse(this.uid.substring(4,8),radix: 16);
        var nearbySerialid = int.parse(this.uid.substring(8,12),radix: 16);
        contacts!.add(ContactDevices(deviceID: nearbySerialid, groupId: nearbyGroupId, nearbyTime: nearbyTime));

        nearbyTime = int.parse(this.uid.substring(12,14), radix: 16);
        nearbyGroupId = int.parse(this.uid.substring(14,18),radix: 16);
        nearbySerialid = int.parse(this.uid.substring(18,22),radix: 16);
        contacts!.add(ContactDevices(deviceID: nearbySerialid, groupId: nearbyGroupId, nearbyTime: nearbyTime));

      } else  if (this.nearbyDeviceCount == 3) {
        print("Nearby Count 3");
        var nearbyTime = int.parse(this.uid.substring(2,4), radix: 16);
        var nearbyGroupId = int.parse(this.uid.substring(4,8),radix: 16);
        var nearbySerialid = int.parse(this.uid.substring(8,12),radix: 16);
        contacts!.add(ContactDevices(deviceID: nearbySerialid, groupId: nearbyGroupId, nearbyTime: nearbyTime));

        nearbyTime = int.parse(this.uid.substring(12,14), radix: 16);
        nearbyGroupId = int.parse(this.uid.substring(14,18),radix: 16);
        nearbySerialid = int.parse(this.uid.substring(18,22),radix: 16);
        contacts!.add(ContactDevices(deviceID: nearbySerialid, groupId: nearbyGroupId, nearbyTime: nearbyTime));

        nearbyTime = int.parse(this.uid.substring(22,24), radix: 16);
        nearbyGroupId = int.parse(this.uid.substring(24,28),radix: 16);
        nearbySerialid = int.parse(this.uid.substring(28,32),radix: 16);
        contacts!.add(ContactDevices(deviceID: nearbySerialid, groupId: nearbyGroupId, nearbyTime: nearbyTime));       
      }

      return contacts;
    }
    
}

class ContactDevices {
  ContactDevices({required this.nearbyTime,  required this.groupId, required this.deviceID});
  int nearbyTime;
  int groupId;
  int deviceID;
}
