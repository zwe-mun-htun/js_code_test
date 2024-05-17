part of '../views.dart';

class CreateDetectionPage extends StatefulWidget {
  const CreateDetectionPage({super.key, required this.documentData});

  final DocumentData documentData;

  @override
  State<CreateDetectionPage> createState() => _CreateDetectionPageState();
}

class _CreateDetectionPageState extends State<CreateDetectionPage> {
  ui.Image? normalizedUiImage;

  NormalizedImage? normalizedImage;
  TextEditingController _nameController = TextEditingController();

  //Init Document results and scan results
  @override
  void initState() {
    super.initState();
    if (widget.documentData.documentResults != null) {
      initDocumentState();
    } else {
      normalizedUiImage = widget.documentData.image!;
    }
  }

  Future<int> initDocumentState() async {
    await docScanner.setParameters(Template.color);
    await normalizeBuffer(widget.documentData.image!,
        widget.documentData.documentResults![0].points);
    return 0;
  }

  //Custom Image Creation with detectionResults
  Widget createCustomImage(BuildContext context, ui.Image image,
      List<DocumentResult> detectionResults) {
    return FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
            width: image.width.toDouble(),
            height: image.height.toDouble(),
            child: CustomPaint(
              painter: OverlayPainter(image, detectionResults),
            )));
  }

  //Detection Result
  Widget _getCreateDetectionWidget() {
    if (normalizedUiImage == null) {
      return const CircularProgressIndicator();
    } else {
      var pageContent = SizedBox(
        width: ResponsiveWidget.isSmallScreen(context)
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(children: [
          createCustomImage(context, normalizedUiImage!, []),
        ]),
      );
      return pageContent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _getCreateDetectionScaffold;
  }

  //Create Detection
  Scaffold get _getCreateDetectionScaffold => Scaffold(
        appBar: _getAppBar,
        backgroundColor: AppColors.kWhiteColor,
        body: BlocConsumer<CreateDetectionCubit, CreateDetectionState>(
          listener: (context, state) {
            if (state.isDone) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Successfully created."),
              ));
              Navigator.pushReplacementNamed(context, Routes.home);
            }
          },
          builder: (_, state) {
            return Stack(
              children: [
                ResponsiveWidget.isSmallScreen(context)
                    ? Column(
                        children: _getItems,
                      )
                    : Row(
                        children: _getItems,
                      ),
                if (state.isLoading)
                  Container(
                    color: Colors.black12,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          },
        ),
      );

  List<Widget> get _getItems => [_getCreateDetectionWidget(), _getSubmitFields];

  //App Bar
  AppBar get _getAppBar => AppBar(
        backgroundColor: AppColors.kPrimaryColor,
        title: Text(
          StringConst.kCreateDetectionTitle,
          style: const TextStyle(color: Colors.white),
        ),
        leading: InkWell(
            onTap: () => backtoScanner(),
            child: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.kWhiteColor,
            )),
      );

  //Normalize Scanner file
  Future<void> normalizeFile(String file, dynamic points) async {
    normalizedImage = await docScanner.normalizeFile(file, points);
    if (normalizedImage != null) {
      decodeImageFromPixels(normalizedImage!.data, normalizedImage!.width,
          normalizedImage!.height, PixelFormat.rgba8888, (ui.Image img) {
        normalizedUiImage = img;
        setState(() {});
      });
    }
  }

  //Scanner Image Buffer
  Future<void> normalizeBuffer(ui.Image sourceImage, dynamic points) async {
    ByteData? byteData =
        await sourceImage.toByteData(format: ui.ImageByteFormat.rawRgba);

    Uint8List bytes = byteData!.buffer.asUint8List();
    int width = sourceImage.width;
    int height = sourceImage.height;
    int stride = byteData.lengthInBytes ~/ sourceImage.height;
    int format = ImagePixelFormat.IPF_ARGB_8888.index;

    normalizedImage = await docScanner.normalizeBuffer(
        bytes, width, height, stride, format, points);
    if (normalizedImage != null) {
      decodeImageFromPixels(normalizedImage!.data, normalizedImage!.width,
          normalizedImage!.height, PixelFormat.rgba8888, (ui.Image img) {
        normalizedUiImage = img;
        setState(() {});
      });
    }
  }

  //Back to Scanner Page
  void backtoScanner() {
    Navigator.pushReplacementNamed(context, Routes.home);
  }

  Widget get _getSubmitFields => Container(
        width: ResponsiveWidget.isSmallScreen(context)
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.width * 0.5,
        padding: const EdgeInsets.all(Sizes.padding20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Please enter your name.'),
            TextField(
              key: const Key('Name'),
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: Sizes.padding20),
              child: ElevatedButton(
                onPressed: () => _checkValidations(),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(AppColors.kPrimaryColor)),
                child: const Text('Submit',
                    style: TextStyle(
                        color: AppColors.kBlackColor, fontSize: Sizes.size16)),
              ),
            )
          ],
        ),
      );

  _checkValidations() async {
    if (_nameController.text.isNotEmpty) {
      Uint8List imageString =
          await convertImagetoPngUnit8List(normalizedUiImage!);

      // ignore: use_build_context_synchronously
      context
          .read<CreateDetectionCubit>()
          .createDetection(_nameController.text.toString(), imageString);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter a name."),
      ));
    }
  }
}
