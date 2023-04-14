//
//  DataManager.swift
//  GradingCalculator
//
//  Created by Samuel A. Benicewicz on 4/3/23.
//

import Foundation
import CoreData
import SwiftUI

class DataManager: ObservableObject {
    
    static let sharedManager = DataManager()
    let container = NSPersistentContainer(name: "EZGradeCalcModel")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error {
                print("CoreData failed to load: \(error.localizedDescription)")
            }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func delete(_ object: NSManagedObject) {
        objectWillChange.send()
        container.viewContext.delete(object)
        save()
    }
    
    func addGrade(name: String, grade: Double, weight: Double, course: Course ) {
        let viewContext = Grade(context: container.viewContext)
        viewContext.id = UUID()
        viewContext.name = name
        viewContext.grade = grade
        viewContext.weight = weight
        viewContext.date = Date()
        viewContext.order -= 1
        course.addToGrades(viewContext)
        save()
    }
    
    func editGrade(name:String, grade: Double, editGrade: Grade, weight: Double, courseBelongTo: Course, currentGrade: Grade) {
        let viewContext = Grade(context: container.viewContext)
        viewContext.id = UUID()
        viewContext.name = name
        viewContext.grade = grade
        viewContext.weight = weight
        viewContext.date = Date()
    }
    
    func addGPA(name: String, grade: Double, credits: Int) {
        let viewContext = GPA(context: container.viewContext)
        viewContext.id = UUID()
        viewContext.name = name
        viewContext.grade = grade
        viewContext.credits = Int16(credits)
        viewContext.date = Date()
        save()
    }
    
    func addCourse(name: String, semester: String, year: Int16) {
        let viewContext = Course(context: container.viewContext)
        viewContext.id = UUID()
        viewContext.name = name
        viewContext.year = year
        viewContext.date = Date()
        viewContext.semester = semester
        save()
    }
    
    func delete(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
        let batchRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchRequest.resultType = .resultTypeObjectIDs
        if let delete = try? container.viewContext.execute(batchRequest) as? NSBatchDeleteResult {
            let changes = [NSDeletedObjectIDsKey: delete.result as? [NSManagedObject] ?? []]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
        }
    }
    
    func deleteAllGrades() {
        let request2: NSFetchRequest<NSFetchRequestResult> = Grade.fetchRequest()
        delete(request2)
    }
    
    func deleteAllCourses() {
        let reques1: NSFetchRequest<NSFetchRequestResult> = Course.fetchRequest()
        delete(reques1)
    }
    
    func deleteAll() {
        let reques1: NSFetchRequest<NSFetchRequestResult> = Course.fetchRequest()
        delete(reques1)
        let request2: NSFetchRequest<NSFetchRequestResult> = Grade.fetchRequest()
        delete(request2)
    }
    
    func deleteGradesInaCourse(courses: FetchedResults<Course>, grade: Grade) {
        for course in courses {
            for grade in course.gradeArray {
                if grade.id == grade.id {
                    delete(grade)
                }
            }
        }
    }
    
    func onDeleteGrades(at offset: IndexSet, grades: [Grade]) {
        for index in offset {
            let grade = grades[index]
            delete(grade)
        }
    }
    
    func onDelete<T:NSManagedObject>(at offset: IndexSet, courses: FetchedResults<T>) {
        for index in offset {
             let cours = courses[index]
             delete(cours)
        }
    }
    
    func move(fromSource: IndexSet, todestination: Int, course: Course) {
        var resvised: [Grade] = course.gradeArray.map{$0}
        resvised.move(fromOffsets: fromSource, toOffset: todestination)
        for reveseIndex in stride(from: resvised.count - 1, to: 0, by: -1) {
            resvised[reveseIndex].order = Int64(reveseIndex)
        }
        save()
    }
    
    func moveItem(at sets: IndexSet, destination: Int, grades: FetchedResults<Grade>) {
        let itemToMove = sets.first!
        if itemToMove < destination {
            var startIndex = itemToMove + 1
            let endIndex = destination - 1
            var startOrder = grades[itemToMove].order
            while startIndex <= endIndex {
                grades[startIndex].order = startOrder
                startOrder += 1
                startIndex += 1
            }
            grades[itemToMove].order = startOrder
        }else if  destination < itemToMove {
            var startIndex = destination
            let endIndex = itemToMove - 1
            var startOrder = grades[itemToMove].order + 1
            let newOrder = grades[destination].order
            while startIndex <= endIndex {
                grades[startIndex].order = startOrder
                startOrder += 1
                startIndex += 1
            }
            grades[itemToMove].order = newOrder
        }
    }
    
    func moveItem(at sets: IndexSet, destination: Int, courses: FetchedResults<Course>) {
        let itemToMove = sets.first!
        if itemToMove < destination {
            var startIndex = itemToMove + 1
            let endIndex = destination - 1
            var startOrder = courses[itemToMove].order
            while startIndex <= endIndex {
                courses[startIndex].order = startOrder
                startOrder += 1
                startIndex += 1
            }
            courses[itemToMove].order = startOrder
        }else if  destination < itemToMove {
            var startIndex = destination
            let endIndex = itemToMove - 1
            var startOrder = courses[itemToMove].order + 1
            let newOrder = courses[destination].order
            while startIndex <= endIndex {
                courses[startIndex].order = startOrder
                startOrder += 1
                startIndex += 1
            }
            courses[itemToMove].order = newOrder
        }
        save()
    }

    func save() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            }catch {
                print(error.localizedDescription)
            }
        }
    }
}
