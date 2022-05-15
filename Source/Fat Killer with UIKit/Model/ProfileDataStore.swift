//
//  ProfileDataStore.swift
//  Fat Killer with UIKit
//
//  Created by 刘洪宇 on 2021/8/21.
//

import HealthKit

class ProfileDataStore {
    ///获取最新的样本
    class func getMostRecentSample(for sampleType: HKSampleType,
                                   completion: @escaping (HKQuantitySample?, Error?) -> Swift.Void) {
        //查询配置
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast,
                                                              end: Date(),
                                                              options: .strictEndDate)
        //样本排序方法
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
                                              ascending: false)
        let limit = 1       //样本数
        let sampleQuery = HKSampleQuery(sampleType: sampleType,
                                        predicate: mostRecentPredicate,
                                        limit: limit,
                                        sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            //脱离主线程进行查询
            DispatchQueue.main.async {
                guard let samples = samples,
                      let mostRecentSample = samples.first as? HKQuantitySample else {
                        completion(nil, error)
                        return
                }
                completion(mostRecentSample, nil)
            }
        }
        HKHealthStore().execute(sampleQuery)
    }
    
    class func getSingleSample(for sampleType: HKSampleType, startDate: Date, endDate: Date, ascending: Bool, 
                                   completion: @escaping (HKQuantitySample?, Error?) -> Swift.Void) {
      
        //1. Use HKQuery to load the most recent samples.
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: startDate,
                                                              end: endDate,
                                                              options: [])
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
                                              ascending: ascending)
        
        let limit = 1
        
        let sampleQuery = HKSampleQuery(sampleType: sampleType,
                                        predicate: mostRecentPredicate,
                                        limit: limit,
                                        sortDescriptors: [sortDescriptor]) { (query, samples, error) in
        
//        2. Always dispatch to the main thread when complete.
//           If you don’t do this, the app will crash.
            DispatchQueue.main.async {
            
                guard let samples = samples,
                      let mostRecentSample = samples.first as? HKQuantitySample else {
                    
                        completion(nil, error)
                        return
                }
            
                completion(mostRecentSample, nil)
            }
        }
     
        HKHealthStore().execute(sampleQuery)
    }
    
    class func getSeriesSample(for sampleType: HKSampleType, startDate: Date, endDate: Date, ascending: Bool,
                                   completion: @escaping (HKQuantitySample?, Error?) -> Swift.Void) {
      
        //1. Use HKQuery to load the most recent samples.
        let timePredicate = HKQuery.predicateForSamples(withStart: startDate,
                                                        end: endDate,
                                                        options: [])
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
                                              ascending: ascending)
        
        let sampleQuery = HKSampleQuery(sampleType: sampleType,
                                        predicate: timePredicate,
                                        limit: Int(HKObjectQueryNoLimit),
                                        sortDescriptors: [sortDescriptor]) { (query, Samples, error) in

            DispatchQueue.main.async {
            
                guard let samples = Samples,
                      let mostRecentSample = samples.first as? HKQuantitySample else {
                        completion(nil, error)
                        return
                }
                var weightSample: [WeightSample] = []
                
                for i in 0..<samples.count {
                    guard let tempSample = samples[i] as? HKQuantitySample else {
                        completion(nil, error)
                        return
                    }
                    
                    var tempWeight: WeightSample = WeightSample()
                    tempWeight.sampleTime = tempSample.startDate
                    tempWeight.weight = tempSample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
                    
                    weightSample.append(tempWeight)
                }
                
                finalModelData.weights = weightSample
                completion(mostRecentSample, nil)
            }
        }
     
        HKHealthStore().execute(sampleQuery)
    }
    
    class func saveBodyMassIndexSample(BMI: Double, date: Date) {
      //1.  Make sure the body mass type exists
        guard let bodyMassIndexType = HKQuantityType.quantityType(forIdentifier: .bodyMassIndex) else {
            fatalError("Body Mass Index Type is no longer available in HealthKit")
        }
      //2.  Use the Count HKUnit to create a body mass quantity
        let bodyMassQuantity = HKQuantity(unit: HKUnit.count(),
                                          doubleValue: BMI)
        let bodyMassIndexSample = HKQuantitySample(type: bodyMassIndexType,
                                                   quantity: bodyMassQuantity,
                                                   start: date,
                                                   end: date)
        HKHealthStore().save(bodyMassIndexSample) { (success, error) in
          
            if let error = error {
                print("Error Saving BMI Sample: \(error.localizedDescription)")
            } else {
                print("Successfully saved BMI Sample")
            }
        }
    }
    class func saveBodyMassSample(weight: Double, date: Date) {
        guard let bodyMassType = HKQuantityType.quantityType(forIdentifier: .bodyMass) else {
            fatalError("Body Mass Type is no longer available in HealthKit")
        }

        let bodyMassQuantity = HKQuantity(unit: HKUnit.gramUnit(with: .kilo),
                                          doubleValue: weight)
        
        let bodyMassSample = HKQuantitySample(type: bodyMassType,
                                              quantity: bodyMassQuantity,
                                              start: date,
                                              end: date)
        
        HKHealthStore().save(bodyMassSample) { (success, error) in
            if let error = error {
                print("Error Saving weight Sample: \(error.localizedDescription)")
            } else {
                print("Successfully saved weight Sample")
            }
        }
    }
}
