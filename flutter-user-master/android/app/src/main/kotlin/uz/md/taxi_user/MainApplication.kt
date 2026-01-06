package uz.md.taxi_user

import android.app.Application
import com.yandex.mapkit.MapKitFactory

class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        MapKitFactory.setApiKey("d91bb4f0-deaa-4b35-8764-1e08e6b8a38b")
    }
}
