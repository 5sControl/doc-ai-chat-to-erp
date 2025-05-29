#chmod +x run_ios.sh
#!/bin/bash
flutter clean
flutter pub get
flutter build ios --release && open ios/Runner.xcworkspace

#flutter build io s --release && open ios/Runner.xcworkspace
