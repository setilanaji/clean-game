//
//  BaseMapper.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/9.
//

import Foundation

final class BaseMapper {
    static func mapBaseResponseToDomain<T, U>(
        input baseResponse: BaseResponse<T>,
        data: [U]
    ) -> BaseModel<U> {
        return BaseModel<U>(
            count: baseResponse.count ?? 0,
            next: baseResponse.next ?? "",
            previous: baseResponse.previous ?? "",
            result: data
        )
    }
}
