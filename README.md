# DynamicActionSheet

![Platform](https://img.shields.io/badge/platform-iOS-blue.svg?style=flat) ![Compatible](https://img.shields.io/badge/swift4-compatible-4BC51D.svg?style=flat) ![License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)

**DynamicActionSheet** is a library to quickly create any custom action sheet controller.

# Usage

```swift
// Instantiate custom action sheet controller
let list = DynamicActionSheet()
//Set up delegate and datasource
list.delegate = self
list.datasource = self
//You can use a custom button (this is optional)
list.showButton = true
// present actionSheet like any other view controller
self.present(list, animated: true)
```

# Delegate & Datasource
```swift
extension ViewController: ListViewDataSource, ListViewDelegate {
    func numberOfRows(for tableView: UITableView) -> Int {
        return 10
    }

    func dynamicSheet(_ actionCell: ActionTableViewCell, forItemAt index: Int) {
        actionCell.titleLabel.text = "Cell \(index)"
    }

    func didSelectMultipleIndexes(indexes: [Int]) {
        print("\(indexes.count) values selected")
    }

    var listTitle: String? {
        return "Title"
    }

    var buttonTitle: String? {
        return "All Items"
    }

    func dynamicSheet(didSelectRowAt index: Int) {
        print("row \(index) selected")
    }
}
```

### Development
The library is under construction
Want to contribute? Great! Feel free to submit pull requests


License
----

MIT License

Copyright (c) 2018 Andres Rojas

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


**Free Software, Hell Yeah!**


   
