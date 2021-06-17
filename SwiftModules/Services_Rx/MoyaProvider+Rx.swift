import Foundation
import RxSwift
#if !COCOAPODS
import Moya
#endif

extension MoyaProvider: ReactiveCompatible {}

public extension Reactive where Base: MoyaProviderType {

    /// Designated request-making method.
    ///
    /// - Parameters:
    ///   - token: Entity, which provides specifications necessary for a `MoyaProvider`.
    ///   - callbackQueue: Callback queue. If nil - queue from provider initializer will be used.
    /// - Returns: Single response object.
    func request(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Single<Response> {
        return Single.create { [weak base] single in
            let cancellableToken = base?.request(token, callbackQueue: callbackQueue, progress: nil) { result in
                switch result {
                case let .success(response):
                    single(.success(response))
                case let .failure(error):
                    single(.failure(error))
                }
            }

            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }

    /// Designated request-making method with progress.
    func requestWithProgress(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Observable<ProgressResponse> {
        let progressBlock: (AnyObserver) -> (ProgressResponse) -> Void = { observer in
            return { progress in
                observer.onNext(progress)
            }
        }

        let response: Observable<ProgressResponse> = Observable.create { [weak base] observer in
            let cancellableToken = base?.request(token, callbackQueue: callbackQueue, progress: progressBlock(observer)) { result in
                switch result {
                case .success:
                    observer.onCompleted()
                case let .failure(error):
                    observer.onError(error)
                }
            }

            return Disposables.create {
                cancellableToken?.cancel()
            }
        }

        // Accumulate all progress and combine them when the result comes
        return response.scan(ProgressResponse()) { last, progress in
            let progressObject = progress.progressObject ?? last.progressObject
            let response = progress.response ?? last.response
            return ProgressResponse(progress: progressObject, response: response)
        }
    }
}

public extension Reactive where Base: MoyaProviderType {
    
    /// rx 请求 返回 Observable
    func cc_request(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Observable<Response> {
        return Observable.create { [weak base] observer in
            let cancellableToken = base?.request(token, callbackQueue: callbackQueue, progress: nil) { result in
                switch result {
                case let .success(response):
                    observer.onNext(response)
                case let .failure(error):
                    observer.onError(error)
                }
            }

            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }
    
    /// 缓存请求 返回 Observable
    func cacheRequest(_ token: Base.Target,
                      cacheType: CacheKeyType = .default,
                      callbackQueue: DispatchQueue? = nil) -> Observable<Response> {
        return Observable.create { [weak base] observer in
            let cancellableToken = base?.cacheRequest(token, cacheType: cacheType, callbackQueue: callbackQueue, progress: nil, completion: { (result) in
                switch result {
                case let .success(response):
                    observer.onNext(response)
                case let .failure(error):
                    observer.onError(error)
                }
            })

            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }
}

