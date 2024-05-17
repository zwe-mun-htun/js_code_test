part of '../views.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  late CameraManager _cameraManager;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _cameraManager = CameraManager(
        context: context,
        cbRefreshUi: refreshUI,
        cbIsMounted: isMounted,
        cbNavigation: navigation);
    _cameraManager.initState();
  }

  void navigation(dynamic order) {
  
    Navigator.pushReplacementNamed(context, Routes.uploadDetection, arguments: order);
  }

  void refreshUI() {
    setState(() {});
  }

  bool isMounted() {
    return mounted;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraManager.stopVideo();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraManager.controller == null ||
        !_cameraManager.controller!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _cameraManager.controller!.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _cameraManager.toggleCamera(0);
    }
  }

  //Camera Preview
  List<Widget> createCameraPreview() {
    if (_cameraManager.controller != null &&
        _cameraManager.previewSize != null) {
      double width = _cameraManager.previewSize!.width;
      double height = _cameraManager.previewSize!.height;
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        if (MediaQuery.of(context).size.width <
            MediaQuery.of(context).size.height) {
          width = _cameraManager.previewSize!.height;
          height = _cameraManager.previewSize!.width;
        }
      }

      return [
        SizedBox(
            width: width, height: height, child: _cameraManager.getPreview()),
        Positioned(
          top: 0.0,
          right: 0.0,
          bottom: 0,
          left: 0.0,
          child: createOverlay(
            _cameraManager.documentResults,
          ),
        ),
      ];
    } else {
      return [const CircularProgressIndicator()];
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(canPop: true, child: _getCameraPageScaffold);
  }

  //Camera Page Scaffold
  Widget get _getCameraPageScaffold => Scaffold(
        appBar: _getAppBar,
        body: Stack(
          children: <Widget>[
            if (_cameraManager.controller != null &&
                _cameraManager.previewSize != null)
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                bottom: 0,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Stack(
                    children: createCameraPreview(),
                  ),
                ),
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _getCaptureButton,
            )
          ],
        ),
      );

  //AppBar
  AppBar get _getAppBar => AppBar(
        backgroundColor: AppColors.kPrimaryColor,
        title: Text(
          StringConst.kMaterialAppTitle,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.myUploads);
            },
            icon: const Icon(Icons.view_list_outlined),
          ),
        ],
      );

  //Capture Button
  Widget get _getCaptureButton => InkWell(
        onTap: () {
          _cameraManager.isReadyToGo = true;
        },
        child: Container(
          width: Sizes.width60,
          height: Sizes.height60,
          margin: const EdgeInsets.only(bottom: Sizes.margin20),
          decoration: BoxDecoration(
              color: AppColors.kPrimaryColor,
              borderRadius: BorderRadius.circular(Sizes.radius30)),
          child: const Icon(
            Icons.camera_enhance,
            color: AppColors.kBlackColor,
          ),
        ),
      );
}
