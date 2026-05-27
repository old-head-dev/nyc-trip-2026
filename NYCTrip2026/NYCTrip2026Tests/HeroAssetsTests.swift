import Testing
import UIKit

@Suite("Hero asset catalog")
struct HeroAssetsTests {
    @Test("All 15 hero image sets load from the asset catalog", arguments: [
        "icon", "breakfast", "central_park_spring", "dinner", "fifth_ave_sign",
        "hotel_building", "ice_cream_cone", "jellycat", "lunch", "nyc_shopping",
        "sedan_car", "subway_train", "times_square", "train_station", "uber_car"
    ])
    func heroLoads(_ name: String) {
        #expect(UIImage(named: name) != nil, "Image set '\(name)' is missing or misnamed in Assets.xcassets")
    }
}
