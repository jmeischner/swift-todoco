import Foundation
import Regex

/*
# Todo:
## Negierter exclude bzw. add Element müssen betrachtet werden
Problem ist, dass die spezifischeren Element nicht mehr auftauchen,
da sie mit skip descendants ignoriert werden:
Idee: Erst alle negierten bzw. add-Elemente (ist das gleiche)
durchsuchen und in den result array hinzufügen und dann den ignore
Teil durchgehen --> Vorsicht: Doppelte Elemente entfernen

## Wildcards
Wie werden wildcards ersetzt, bzw. gehandelt?

## Filenames
Problem: paths.contains kann zu unspezifisch sein,
eigentlich könnte es einfach startsWith oder sowas sein,
Problem sind aber einzelne Dateien, diese können an jeder
Stelle im Pfad auftreten und müssen mit Contains abgehandelt
werden
*/

public func glob(root: String, paths: [String]) -> [String] {

    let optEnumerator = FileManager.default.enumerator(atPath: root)
    let pattern = prepare(pattern: paths)

    return glob(pattern: pattern, enumerator: optEnumerator)
}

func glob(pattern: [NSRegularExpression], enumerator: FileManager.DirectoryEnumerator?) -> [String] {
    var result = [String]()

    if let enumer = enumerator {
        while let path = enumer.nextObject() {
            if let file = path as? String {
                var matches = false
                for index in 0..<pattern.count {
                    if pattern[index].numberOfMatches(in: file, range: NSMakeRange(0, file.count)) > 0 {
                        matches = true
                    }
                }

                if !matches {
                    result.append(file)
                }
            }
        }
    }
    return result
}
