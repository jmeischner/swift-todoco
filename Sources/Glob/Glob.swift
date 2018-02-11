import Foundation

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

    for pat in pattern {
        print(pat)
    }

    return [String]()

    // return glob(pattern: [NSRegularExpression], enummerator: FileManager.DirectoryEnumerator)

    // var result = [String]()

    // if let enumerator = optEnumerator {
    //     while let path = enumerator.nextObject() {
    //         if let file = path as? String {
    //             let match = glob(pattern, matches: file)

    //             switch match {
    //             case .directory:
    //                 enumerator.skipDescendants()
    //             case .file:
    //                 break
    //             case .none:
    //                 result.append(file)
    //             }
    //         }
    //     }
    // }

    // return result
}