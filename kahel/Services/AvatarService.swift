import Foundation
import UIKit
import SVGKit

class AvatarService {
    
    static let hairOptions = [
        "short01", "short02", "short03", "short04", "short05", "short06", "short07", "short08", "short09", "short10",
        "short11", "short12", "short13", "short14", "short15", "short16",
        "long01", "long02", "long03", "long04", "long05", "long06", "long07", "long08", "long09", "long10", "long11",
        "long12", "long13", "long14", "long15", "long16", "long17", "long18", "long19"
    ]
    
    static let skinOptions = [
        "variant01", "variant02", "variant03", "variant04",
        "variant05", "variant06", "variant07"
    ]
    
    static func getAvatarUrl(
        seed: String,
        hair: String? = nil,
        skinColor: String? = nil,
        hpPercent: Int = 100
    ) -> String {
        // In the original Flutter app:
        // final isCritical = hpPercent <= 25;
        // final isHurt = hpPercent <= 50;
        // final mouth = isCritical ? 'variant09' : (isHurt ? 'variant08' : 'variant02');
        // final eyes = isCritical ? 'variant10' : (isHurt ? 'variant11' : 'variant12');
        
        let isCritical = hpPercent <= 25
        let isHurt = hpPercent <= 50
        
        let mouth = isCritical ? "variant09" : (isHurt ? "variant08" : "variant02")
        let eyes = isCritical ? "variant10" : (isHurt ? "variant11" : "variant12")
        
        var urlComps = URLComponents(string: "https://api.dicebear.com/7.x/adventurer/svg")!
        
        var qItems = [
            URLQueryItem(name: "seed", value: seed),
            URLQueryItem(name: "mouth", value: mouth),
            URLQueryItem(name: "eyes", value: eyes),
            URLQueryItem(name: "backgroundColor", value: "transparent")
        ]
        
        if let h = hair, !h.isEmpty {
            qItems.append(URLQueryItem(name: "hair", value: h))
        }
        
        if let s = skinColor, !s.isEmpty {
            qItems.append(URLQueryItem(name: "skinColor", value: s))
        }
        
        urlComps.queryItems = qItems
        
        return urlComps.url?.absoluteString ?? ""
    }
    
    static func loadAvatarSVG(url: String) async throws -> UIImage {
        guard let validUrl = URL(string: url) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: validUrl)
        
        // Use SVGKit to parse the SVG data into a UIImage
        guard let svgImage = SVGKImage(data: data), let uiImage = svgImage.uiImage else {
            throw NSError(domain: "AvatarService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse SVG"])
        }
        
        return uiImage
    }
}
