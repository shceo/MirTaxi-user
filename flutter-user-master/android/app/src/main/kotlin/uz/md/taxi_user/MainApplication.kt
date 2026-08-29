package uz.md.taxi_user

import android.app.Application
import android.content.pm.PackageManager
import com.yandex.mapkit.MapKitFactory

class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        // Ключ берём из meta-data манифеста: туда его подставляет Gradle из
        // android/local.properties (yandex.mapsApiKey). Раньше он был захардкожен
        // здесь и дублировался ещё в двух местах.
        val appInfo = packageManager.getApplicationInfo(packageName, PackageManager.GET_META_DATA)
        val apiKey = appInfo.metaData?.getString("com.yandex.maps.apikey")
        if (!apiKey.isNullOrBlank()) {
            MapKitFactory.setApiKey(apiKey)
        }
    }
}
