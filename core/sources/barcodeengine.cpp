#include "barcodeengine.h"
#include <algorithm>
#include <qdebug.h>
#include <qimage.h>
#include <qlogging.h>
#include <qmediadevices.h>
#include <qvideoframe.h>
#include <qvideoframeformat.h>
#include <qvideosink.h>

BarcodeEngine::BarcodeEngine(QObject *parent)
    : QObject{parent}
    ,videoSink(new QVideoSink(this))

{
    //the costractor
    barcode = "";

}

/**
 * @brief BarcodeEngine::processVideoFrames
 * @param frames
 * this methode is ersponsible for processing the the videos frames
 */
void BarcodeEngine::processVideoFrames(const QVideoFrame &frames)
{
    //
    QVideoFrame video_frame = frames;
    frameCounter++;
    if(frameCounter % (frameToSkip + 1) != 0) {
        return;
    }
    //chacking if the frames are valide
    if (frames.isValid()) {
        if(video_frame.map(QVideoFrame::ReadOnly)) {
            //convet the frma to gray scale
        }

    } else {
        qDebug() << "Frames not Valide";
    }
}
/**
 * @brief BarcodeEngine::setVideoSink
 * @param sink
 * this methode receives video frames from the qmlside
 */
void BarcodeEngine::setVideoSink(QVideoSink *sink)
{
    if(sink) {
        videoSink = sink;
        connect(videoSink, &QVideoSink::videoFrameChanged, this, &BarcodeEngine::processVideoFrames);
    }
}
/**
 * @brief BarcodeEngine::processImage
 * @param id
 * @param preview
 *
 */
void BarcodeEngine::processImage(QImage preview)
{
    auto startTime = std::chrono::high_resolution_clock::now();

    // Step 1: Calculate crop rectangle
    const qreal parentWidth = preview.width();
    const qreal parentHeight = preview.height();
    const qreal barCodeWidth = parentWidth * 0.9;
    const qreal barcodeHeight = 142;

    QRect cropRect;
    int cropWidth = (barCodeWidth / parentWidth * preview.width());
    int cropHeight = (barcodeHeight / parentHeight * preview.height());
    cropRect.setWidth(cropWidth);
    cropRect.setHeight(cropHeight);
    cropRect.moveCenter(QPoint(preview.width() / 2, preview.height() / 2));

    qDebug() << "Crop rectangle:" << cropRect;

    // Step 2: Crop the image
    preview = preview.copy(cropRect);

    qDebug() << "Processing cropped image - Height:" << preview.height() << "Width:" << preview.width();

    // Step 3: Resize the image (optional, for performance)
    preview = preview.scaled(640, 480, Qt::KeepAspectRatio);

    // Step 4: Convert image to grayscale
    if (preview.format() != QImage::Format_Grayscale8) {
        preview = preview.convertToFormat(QImage::Format_Grayscale8);
    }

    // Step 5: Apply thresholding (optional)
   // preview = preview.convertToFormat(QImage::Format_Mono);
    // Step 6: Wrap QImage data into ZXing::ImageView
    ZXing::ImageView imageView(
        preview.bits(),
        preview.width(),
        preview.height(),
        ZXing::ImageFormat::Lum // Grayscale format
        );

    // Step 7: Set decoding hints
    ZXing::ReaderOptions hints;
    hints.setTryHarder(true); // Disable TryHarder for faster decoding
    hints.setFormats(ZXing::BarcodeFormat::EAN13 | ZXing::BarcodeFormat::EAN8 | ZXing::BarcodeFormat::UPCA);

    // Step 7: Decode the barcode
    ZXing::Result result = ZXing::ReadBarcode(imageView, hints);

    // Step 8: Handle the result
    if (result.isValid()) {
        qDebug() << "Decoded content:" << QString::fromStdString(result.text());
        qDebug() << "Format:" << QString::fromStdString(ZXing::ToString(result.format()));
        setBarcode(QString::fromStdString(result.text()));
    } else {
        qDebug() << "No barcode detected.";
    }

    auto endTime = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(endTime - startTime).count();
    qDebug() << "Processing time:" << duration << "ms";
}
/**
 * @brief BarcodeEngine::getBarcode
 * @return the barcode
 */
QString BarcodeEngine::getBarcode() const
{
    return barcode;
}
/**
 * @brief BarcodeEngine::setBarcode
 * @param newBarcode
 * set the barcode after being processed
 */
void BarcodeEngine::setBarcode(const QString &newBarcode)
{
    if (barcode == newBarcode) {
        emit barcodeChanged(); //emiting a signal when barcode alreday have a value = newBarcode
        return;
    }

    barcode = newBarcode;
    emit barcodeChanged();
}
/**
 * @brief BarcodeEngine::adjustBrightnessAndContrast
 * @param img
 * @return a shappeded image for easy procssing by zxing
 */
QImage BarcodeEngine::adjustBrightnessAndContrast(const QImage &img)
{
    QImage gray = img.convertToFormat(QImage::Format_Grayscale8);
    uchar* data = gray.bits();
    int size = gray.width() * gray.height();

    int minVal = 255, maxVal = 0;
    for (int i = 0; i < size; i++) {
        minVal = std::min(minVal, static_cast<int>(data[i]));
        maxVal = std::max(maxVal, static_cast<int>(data[i]));
    }

    double alpha = 255.0 / (maxVal - minVal);
    int beta = -minVal * alpha;

    for (int i = 0; i < size; i++) {
        int newValue = static_cast<int>(data[i] * alpha + beta);
        data[i] = qBound(0, newValue, 255);
    }
    return gray;
}
/**
 * @brief BarcodeEngine::sharpenImage
 * @param img
 * @return shappened image for easy processing by zxing
 */
QImage BarcodeEngine::sharpenImage(const QImage &img)
{
    // Ensure grayscale format
    QImage gray = img.convertToFormat(QImage::Format_Grayscale8);

    QImage sharpened(gray.size(), QImage::Format_Grayscale8);
    const uchar *src = gray.bits();
    uchar *dst = sharpened.bits();
    int width = gray.width();
    int height = gray.height();
    int bytesPerLine = gray.bytesPerLine();

    // Apply Laplacian filter
    for (int y = 1; y < height - 1; ++y) {
        for (int x = 1; x < width - 1; ++x) {
            int center = src[y * bytesPerLine + x];
            int left = src[y * bytesPerLine + x - 1];
            int right = src[y * bytesPerLine + x + 1];
            int up = src[(y - 1) * bytesPerLine + x];
            int down = src[(y + 1) * bytesPerLine + x];

            // Laplacian sharpening formula
            int value = 5 * center - left - right - up - down;
            dst[y * bytesPerLine + x] = qBound(0, value, 255);
        }
    }
    return sharpened;
}
/**
 * @brief BarcodeEngine::convertFrameToQImage
 * @param frame
 * @return The frame as Qimage
 */
QImage BarcodeEngine::convertFrameToQImage(const QVideoFrame &frame)
{
    QVideoFrame f(frame);  // shallow copy, safe since we only read
    if (!f.map(QVideoFrame::ReadOnly))
        return QImage();

    QVideoFrameFormat fmt = f.surfaceFormat();
    int w = fmt.frameWidth();
    int h = fmt.frameHeight();
    QVideoFrameFormat::PixelFormat pixelFormat = fmt.pixelFormat();

    cv::Mat rgb(h, w, CV_8UC3);

    if (pixelFormat == QVideoFrameFormat::Format_NV12) {
        // Plane 0: Y (h x w)
        // Plane 1: UV interleaved (h/2 x w)
        cv::Mat y(h, w, CV_8UC1, f.bits(0), f.bytesPerLine(0));
        cv::Mat uv(h / 2, w, CV_8UC2, f.bits(1), f.bytesPerLine(1));  // UV as UYVY-like but actually UVUV...
        std::vector<cv::Mat> planes = {y, uv};
        cv::cvtColorTwoPlane(y, uv, rgb, cv::COLOR_YUV2RGB_NV12);
    }
    else if (pixelFormat == QVideoFrameFormat::Format_YUV420P) {
        // Plane 0: Y
        // Plane 1: U
        // Plane 2: V
        cv::Mat y(h, w, CV_8UC1, f.bits(0), f.bytesPerLine(0));
        cv::Mat u(h / 2, w / 2, CV_8UC1, f.bits(1), f.bytesPerLine(1));
        cv::Mat v(h / 2, w / 2, CV_8UC1, f.bits(2), f.bytesPerLine(2));
        std::vector<cv::Mat> planes = {y, u, v};
        cv::cvtColor(planes, rgb, cv::COLOR_YUV2RGB_IYUV);  // or cv::COLOR_YUV2RGB_I420
    }
    else if (pixelFormat == QVideoFrameFormat::Format_BGRA8888) {
        cv::Mat bgra(h, w, CV_8UC4, f.bits(0), f.bytesPerLine(0));
        cv::cvtColor(bgra, rgb, cv::COLOR_BGRA2RGB);
    }
    else {
        f.unmap();
        return QImage();  // unsupported format
    }

    f.unmap();

    // Convert cv::Mat (RGB) to QImage without copying data (zero-copy where possible)
    return QImage(rgb.data, rgb.cols, rgb.rows, rgb.step, QImage::Format_RGB888).copy();
}
/**
 * @brief BarcodeEngine::matToQImage
 * @param mat
 * @return an image from cv::mat
 */
QImage BarcodeEngine::matToQImage(const cv::Mat &mat)
{
    switch (mat.type()) {
    case CV_8UC3: {
        QImage img(mat.data, mat.cols, mat.rows, mat.step, QImage::Format_RGB888);
        return img.rgbSwapped(); // BGR -> RGB
    }
    case CV_8UC4: {
        return QImage(mat.data, mat.cols, mat.rows, mat.step, QImage::Format_ARGB32);
    }
    case CV_8UC1: {
        return QImage(mat.data, mat.cols, mat.rows, mat.step, QImage::Format_Grayscale8);
    }
    default:
        qWarning() << "Unsupported cv::Mat format for conversion:" << mat.type();
        return QImage();
    }
}
/**
 * @brief BarcodeEngine::qImageToMat
 * @param image
 * @return cv::mat from QImage
 */
cv::Mat BarcodeEngine::qImageToMat(const QImage &image)
{
    switch (image.format()) {
    case QImage::Format_RGB888: {
        cv::Mat mat(image.height(), image.width(), CV_8UC3,
                    const_cast<uchar*>(image.bits()), image.bytesPerLine());
        cv::Mat matBGR;
        cv::cvtColor(mat, matBGR, cv::COLOR_RGB2BGR);
        return matBGR;
    }
    case QImage::Format_ARGB32:
    case QImage::Format_ARGB32_Premultiplied:
    case QImage::Format_RGB32: {
        cv::Mat mat(image.height(), image.width(), CV_8UC4,
                    const_cast<uchar*>(image.bits()), image.bytesPerLine());
        cv::Mat matBGR;
        cv::cvtColor(mat, matBGR, cv::COLOR_BGRA2BGR); // Drop alpha
        return matBGR;
    }
    case QImage::Format_Grayscale8: {
        cv::Mat mat(image.height(), image.width(), CV_8UC1,
                    const_cast<uchar*>(image.bits()), image.bytesPerLine());
        return mat.clone();
    }
    default:
        qWarning() << "Unsupported QImage format for conversion:" << image.format();
        return cv::Mat();
    }
}


