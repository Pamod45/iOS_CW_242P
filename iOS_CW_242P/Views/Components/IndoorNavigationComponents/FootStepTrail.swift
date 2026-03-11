//
//  FootStepTrail.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-03-11.
//
import SwiftUI

struct FootstepTrail: View {
    let points: [CGPoint]
    let progress: CGFloat

    private let footstepSpacing: CGFloat = 22

    var body: some View {
        let totalLength = calculatePathLength(points)
        let visibleLength = totalLength * progress
        let footsteps = generateFootsteps(totalLength: totalLength, visibleLength: visibleLength)

        ForEach(Array(footsteps.enumerated()), id: \.offset) { _, step in
            Image(systemName: "shoeprints.fill")
                .font(.system(size: 10))
                .foregroundColor(.blue.opacity(0.55))
                .rotationEffect(.degrees(step.angle))
                .position(step.position)
        }
    }

    private struct Footstep {
        let position: CGPoint
        let angle: Double
    }

    private func generateFootsteps(totalLength: CGFloat, visibleLength: CGFloat) -> [Footstep] {
        guard totalLength > 0 else { return [] }
        var steps: [Footstep] = []
        var currentDistance: CGFloat = footstepSpacing / 2

        while currentDistance < visibleLength {
            if let (point, angle) = pointAndAngle(at: currentDistance) {
                steps.append(Footstep(position: point, angle: angle))
            }
            currentDistance += footstepSpacing
        }
        return steps
    }

    private func pointAndAngle(at targetDistance: CGFloat) -> (CGPoint, Double)? {
        var accumulatedDistance: CGFloat = 0
        for i in 0..<(points.count - 1) {
            let startPoint = points[i]
            let endPoint = points[i + 1]
            let segmentLength = hypot(endPoint.x - startPoint.x, endPoint.y - startPoint.y)
            
            if accumulatedDistance + segmentLength >= targetDistance {
                let ratio = (targetDistance - accumulatedDistance) / segmentLength
                let point = CGPoint(
                    x: startPoint.x + (endPoint.x - startPoint.x) * ratio,
                    y: startPoint.y + (endPoint.y - startPoint.y) * ratio
                )
                let angle = atan2(endPoint.y - startPoint.y, endPoint.x - startPoint.x) * 180 / .pi + 90
                return (point, Double(angle))
            }
            accumulatedDistance += segmentLength
        }
        return nil
    }

    private func calculatePathLength(_ points: [CGPoint]) -> CGFloat {
        var length: CGFloat = 0
        for i in 0..<(points.count - 1) {
            length += hypot(points[i + 1].x - points[i].x, points[i + 1].y - points[i].y)
        }
        return length
    }
}
