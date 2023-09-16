//
//  OriginalButtonStyle.swift
//  weiboDemo
//
//  Created by LinDaobin on 2023/8/22.
//

import SwiftUI

struct OriginalButtonStyle: ButtonStyle
{
    func makeBody(configuration: Configuration) -> some View {
        return configuration.label 
    }
}
