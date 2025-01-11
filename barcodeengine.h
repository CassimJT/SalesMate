#ifndef BARCODEENGINE_H
#define BARCODEENGINE_H

#include <QObject>
#include <QtMultimedia>
#include <QMediaCaptureSession>
#include <QVideoSink>
#include <QVideoFrame>
#include <QImage>
#include <QPermission>
#include <QImage>
#include <ZXingCpp.h>
#include <ImageView.h>
#include <Result.h>
#include <ReadBarcode.h>
#include <DecodeHints.h>

class BarcodeEngine : public QObject
{
    Q_PROPERTY(QString barcode READ getBarcode WRITE setBarcode NOTIFY barcodeChanged FINAL)
    Q_OBJECT
public:
    explicit BarcodeEngine(QObject *parent = nullptr);

public slots:
    void processVideoFrames(const QVideoFrame &frame);
    void setVideoSink(QVideoSink *sink);
    void processImage(QImage preview);
    QString getBarcode() const;
    void setBarcode(const QString &newBarcode);
    QImage adjustBrightnessAndContrast(const QImage& img);
    QImage sharpenImage(const QImage& img);

signals:
    void barcodeDetected(const QString &barcodeText);
    void barcodeChanged();

private:
    QVideoSink *videoSink = nullptr;
    int frameCounter = 0;
    int frameToSkip = 3;
    QString barcode;
};

#endif // BARCODEENGINE_H
