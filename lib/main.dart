import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:health_connect/health_connect.dart';
import 'package:jni/internal_helpers_for_jnigen.dart';
import 'package:jni/jni.dart';

void main() {
  Jni.initDLApi();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //   final context = Context.fromRef(Jni.getCachedApplicationContext());
    //   final sdkStatus = HealthConnectClient.sdkStatus1(context);
    //   if (sdkStatus != HealthConnectClient.SDK_AVAILABLE) {
    //     return const MaterialApp(home: NoHealthConnect());
    //   }
    //   final client = HealthConnectClient.getOrCreate1(context);
    return MaterialApp(
      title: 'Step Counter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(
        title: 'Step Counter!',
        //   client: client,
      ),
    );
  }
}

class NoHealthConnect extends StatelessWidget {
  const NoHealthConnect({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Please install/update your health connect!'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;
//  final HealthConnectClient client;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class IhealthCallback extends iHealthDevicesCallback {
  static final _new0 = jniLookup<NativeFunction<JniResult Function()>>(
          "iHealthDevicesCallback__new0")
      .asFunction<JniResult Function()>();
  // Constructor that calls the factory constructor of the superclass.
  IhealthCallback() : super.fromRef(_new0().object);

  @override
  void onScanDevice(
    JString string,
    JString string1,
    int i,
  ) {
    print("onScanDevice");
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final int _counter = 0;

  void _getSteps() async {
    final context = Context.fromRef(Jni.getCachedApplicationContext());

    print("HealthConnectClient.sdkStatus $context");
    JObject jObject = JObject.fromRef(Jni.getCachedApplicationContext());

    iHealthDevicesManager
        .getInstance()
        .init(jObject, Log1.VERBOSE, Log1.VERBOSE);

    print(
        "iHealthDevicesManager.getInstance().sdkAuthWithLicense(context, \"\");");

    iHealthDevicesManager().registerClientCallback(IhealthCallback());

    //   iHealthDevicesCallback.implement($iHealthDevicesCallbackImpl(...))

    iHealthDevicesManager().startDiscovery(DiscoveryTypeEnum.HS2S);

    // ByteArray byteArray = ByteArray.fromRef(Jni.getCachedApplicationContext());

    // JArray jArray = JArray.filled(length, fill)

    //   iHealthDevicesManager().sdkAuthWithLicense(context, "");
    // final aggregateRequest = AggregateRequest(
    //   {StepsRecord.COUNT_TOTAL}.toJSet(AggregateMetric.type(JLong.type)),
    //   TimeRangeFilter.after(
    //     Instant.ofEpochMilli(yesterday.millisecondsSinceEpoch),
    //   ),
    //   JSet.hash(JObject.type), // Empty set
    // );
    // final result = await widget.client.aggregate(aggregateRequest);
    // if (result.isNull) return;
    // final stepCount = result.get0(StepsRecord.COUNT_TOTAL);
    // if (stepCount.isNull) return;
    // setState(() {
    //   _counter = stepCount.longValue();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'The total steps you have taken in the last day is: ',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getSteps,
        tooltip: 'Increment',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
