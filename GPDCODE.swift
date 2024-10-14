import SwiftUI

struct WalkingFigure: View {
    @State private var offsetX: CGFloat = 200
    @State private var armSwing: CGFloat = 0
    @State private var legSwing: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height) * 0.1
            
            ZStack {
                Circle() // Body
                    .fill(Color.green)
                    .frame(width: size * 0.4, height: size * 0.4)
                
                VStack(spacing: 0) {
                    Rectangle() // Torso
                        .fill(Color.green)
                        .frame(width: size * 0.1, height: size * 0.4)
                    
                    HStack(spacing: size * 0.2) {
                        Rectangle() // Left Leg
                            .fill(Color.green)
                            .frame(width: size * 0.1, height: size * 0.3)
                            .rotationEffect(.degrees(Double(legSwing)))
                        
                        Rectangle() // Right Leg
                            .fill(Color.green)
                            .frame(width: size * 0.1, height: size * 0.3)
                            .rotationEffect(.degrees(Double(-legSwing)))
                    }
                }
                
                HStack(spacing: size * 0.4) {
                    Rectangle() // Left Arm
                        .fill(Color.green)
                        .frame(width: size * 0.1, height: size * 0.3)
                        .rotationEffect(.degrees(Double(armSwing)))
                    
                    Rectangle() // Right Arm
                        .fill(Color.green)
                        .frame(width: size * 0.1, height: size * 0.3)
                        .rotationEffect(.degrees(Double(-armSwing)))
                }
                .offset(y: -size * 0.2)
            }
            .offset(x: offsetX, y: geometry.size.height * 0.4)
            .onAppear {
                withAnimation(Animation.linear(duration: 20).repeatForever(autoreverses: false)) {
                    offsetX = -200
                }
                withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                    armSwing = 20
                    legSwing = 20
                }
            }
        }
    }
}

struct AnimatedBackground: View {
    var body: some View {
        ZStack {
            secondcolor.opacity(1)
            ForEach(0..<10) { _ in
                WalkingFigure()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct LoadingScreen: View {
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack {
                Text("GlucoRoot")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(maincolor)
                
                Text("Tailored care for every individual")
                    .font(.subheadline)
                    .foregroundColor(maincolor)
                
                ZStack {
                    Circle()
                        .stroke(maincolor.opacity(0.3), lineWidth: 4)
                        .frame(width: 50, height: 50)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(maincolor, lineWidth: 4)
                        .frame(width: 50, height: 50)
                        .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                        .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: isLoading)
                }
                .padding(.top, 20)
            }
        }
        .onAppear {
            isLoading = true
        }
    }
}

struct LoadingScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoadingScreen()
    }
}
