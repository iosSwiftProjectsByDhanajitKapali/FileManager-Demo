//
//  ViewController.swift
//  FileManager Demo
//
//  Created by unthinkable-mac-0025 on 10/06/21.
//

import UIKit

class ViewController: UIViewController {

    let fileManager = FileManager.default
    var documentDirectoryURL : URL? = nil
    var newFolderURL : URL? = nil
    var fileURL : URL? = nil
    
    var userDetailsArr = [UserDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
            
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        documentDirectoryURL = url
        
        //print(documentDirectoryURL?.path as Any)
        
        //createFolder()
        //creatFile()
        //deleteFile()
        
        //save/retrieve userDetailsArr into a new .plist in documnets directory
        //saveItems()
        loadItems()
        
    }
    
    func createFolder(){
        newFolderURL = documentDirectoryURL?.appendingPathComponent("new-folder")
        let secondFolderURL = documentDirectoryURL?.appendingPathComponent("second-test").appendingPathComponent("ios-acedmy")
        do{
            try fileManager.createDirectory(at: newFolderURL!, withIntermediateDirectories: true, attributes: [:])
            try fileManager.createDirectory(at: secondFolderURL!, withIntermediateDirectories: true, attributes: [:])
        }catch{
            print(error)
        }
    }
    
    func creatFile()  {
        fileURL = newFolderURL?.appendingPathComponent("logs.txt")
        let fileData = "Some random data to put in the .txt file created".data(using: .utf8)
        fileManager.createFile(atPath: fileURL!.path, contents: fileData, attributes: [FileAttributeKey.creationDate : Date()] )
        
        //getting data back from file
        let data = fileManager.contents(atPath: fileURL!.path)
        
    }
    
    func deleteFile(){
        if fileManager.fileExists(atPath: fileURL!.path){
            print("file found")
            do{
                try fileManager.removeItem(at: fileURL!)
            }catch{
                print(error)
            }
        }
        
    }
    
    func saveItems(){
        
        userDetailsArr.append(UserDetails(firstName: "Dhanajit", lastName: "Kapali"))
        userDetailsArr.append(UserDetails(firstName: "Samuel", lastName: "brooks"))
        userDetailsArr.append(UserDetails(firstName: "Jacob", lastName: "robins"))
        
        
        let dataFilePath = documentDirectoryURL?.appendingPathComponent("UserDetails.plist")
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(userDetailsArr)
            try data.write(to: dataFilePath!)
            
            print("tried saving data at \(dataFilePath!)")
        }catch{
            print("error ecoding the userDetailsArr \(error)")
        }
    }
    
    func loadItems(){
        var temp = [UserDetails]()
        let dataFilePath = documentDirectoryURL?.appendingPathComponent("UserDetails.plist")
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                temp = try decoder.decode([UserDetails].self, from: data)
            }catch{
                print("Error decoding item array \(error)")
            }
        }
        print(temp.count)
        
        
    }


}

struct UserDetails : Codable{
    let firstName : String
    let lastName : String
}

