package com.example.testflutter

import android.annotation.SuppressLint
import io.flutter.embedding.android.FlutterActivity

import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.media.AudioFormat
import android.media.AudioRecord
import android.media.MediaRecorder

var audioLevel: AudioLevel? = null
class MainActivity : FlutterActivity() {
    private val CHANNEL = "samples.flutter.dev/audioLevel"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
                call, result ->
            when (call.method) {
                "initializeAudioLevel" -> {
                    initializeAudioLevel()
                    result.success(true)
                }
                "stopAudioLevel" -> {
                    stopAudioLevel()
                    result.success(true)
                }
                "getAudioLevel" -> {
                    val audioLevel = getAudioLevel()
                    result.success(audioLevel)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun initializeAudioLevel() {
        if (audioLevel == null){
            audioLevel = AudioLevel()
        }
        audioLevel!!.start()
    }

    private fun stopAudioLevel() {
        if (audioLevel != null){
            audioLevel!!.stop()
        }
    }

    private fun getAudioLevel(): Double {
        if (audioLevel != null){
            return audioLevel!!.getAmplitude()
        }
        return 0.0
    }

}


class AudioLevel {

    private var ar: AudioRecord? = null
    private var minSize: Int = 0

    @SuppressLint("MissingPermission")
    fun start() {
        minSize = AudioRecord.getMinBufferSize(
            8000,
            AudioFormat.CHANNEL_IN_MONO,
            AudioFormat.ENCODING_PCM_16BIT
        )
        ar = AudioRecord(
            MediaRecorder.AudioSource.MIC,
            8000,
            AudioFormat.CHANNEL_IN_MONO,
            AudioFormat.ENCODING_PCM_16BIT,
            minSize
        )
        ar!!.startRecording()
    }

    fun stop() {
        if (ar != null) {
            ar!!.stop()
        }
    }

    fun getAmplitude(): Double {
        val buffer = ShortArray(minSize)
        ar!!.read(buffer, 0, minSize)
        return convert(buffer.maxOrNull()!!.toDouble(), (0..33_000), (0..1))
    }

    private fun convert(number: Double, original: IntRange, target: IntRange): Double {
        val ratio = number / (original.last - original.first)
        return (ratio * (target.last - target.first))
    }

}