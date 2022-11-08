/// Register View Interface
/// Created by Mercen on 2022/11/06.

import SwiftUI
import Collections
import WrappingHStack

// MARK: - Register View
struct RegisterView: View {
    
    /// State Variables
    @State private var registered: Bool = false
    @State private var selectedAllergy: [String] = [String]()
    
    /// Static Variables
    private let allergyList: OrderedDictionary = ["난류": ["달걀", "계란", "메추리알"],
                                                  "육류": ["소고기", "쇠고기", "돼지고기"],
                                                  "닭고기": [],
                                                  "생선류": ["고등어", "연어", "전어", "멸치", "명태", "참치", "삼치", "꽁치", "생선"],
                                                  "갑각류": ["새우", "게", "가재"],
                                                  "연체동물류": ["오징어", "조개", "가리비", "홍합", "굴"],
                                                  "유제품": ["우유", "양유"],
                                                  "견과류": ["땅콩", "호두", "잣", "마카다미아", "헤이즐넛", "캐슈넛", "아몬드", "피스타치오"],
                                                  "대두": ["콩"],
                                                  "과일": ["복숭아", "사과", "자두", "키위"],
                                                  "토마토": [],
                                                  "밀": [],
                                                  "메밀": [],
                                                  "아황산류": []]
    
    /// Local Variables
    private var viewList: [String] {
        var result = [String]()
        for key in allergyList.keys {
            result += [key] + allergyList[key]!
        }
        return result
    }
    
    private var relatedAllergy: [String] {
        var result = [String]()
        for allergy in selectedAllergy {
            result += allergyList[allergy]!
        }
        return result
    }
    
    /// Local Functions
    private func chooseColor(_ value: String) -> Color {
        if selectedAllergy.contains(value) {
            return .accentColor
        } else if relatedAllergy.contains(value) {
            return .lightColor
        } else {
            return .gray
        }
    }
    
    var body: some View {
        
        ZStack {
            
            // MARK: - Allergy Selection
            ScrollView {
                WrappingHStack(viewList) { value in
                    Button(action: {
                        var majorAllergy = String()
                        for key in allergyList.keys {
                            if allergyList[key]!.contains(value) || key == value {
                                majorAllergy = key
                            }
                        }
                        withAnimation(.default) {
                            if selectedAllergy.contains(majorAllergy) {
                                selectedAllergy = selectedAllergy.filter {
                                    $0 != majorAllergy
                                }
                            } else {
                                selectedAllergy.append(majorAllergy)
                            }
                        }
                    }) {
                        Text(value)
                            .foregroundColor(Color(.systemBackground))
                            .padding([.leading, .trailing], 10)
                            .frame(height: 30)
                            .background(chooseColor(value))
                            .clipShape(Capsule())
                    }
                    .padding(.bottom, 7)
                }
                .padding(.top, 150)
            }
            
            // MARK: - ScrollView Fader
            .mask(
                VStack(spacing: 0) {
                    ForEach(0..<2) { idx in
                        LinearGradient(gradient:
                                        Gradient(
                                            colors: idx == 0 ? [.clear, .black]
                                            : [.black, .clear]),
                                       startPoint: .top,
                                       endPoint: .bottom
                        )
                        .frame(height: 50)
                        if idx == 0 {
                            Rectangle().fill(Color.black)
                        }
                    }
                }
                    .padding(.top, 100)
                    .padding(.bottom, 40)
            )
            
            VStack(alignment: .leading, spacing: 5) {
                // MARK: - Title
                Text("알레르미 시작하기")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                
                // MARK: - Subtitle
                Text("보유하고 계신 알레르기를 선택해주세요.")
                
                Spacer()
                
                // MARK: - Complete Button
                Button(action: {
                    withAnimation(.default) {
                        registered.toggle()
                    }
                }) {
                    Text("완료하기")
                        .foregroundColor(Color(.systemBackground))
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
            }
        }
        .padding(30)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
