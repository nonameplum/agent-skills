# Optics in Swift (Lenses & Prisms) — and how KeyPaths fit

Immutable state is fantastic for correctness and testing, but nested updates can become verbose.
Optics offer a small abstraction to:
- **focus** on a part of a structure
- **read** it
- **update** it immutably

Swift has **KeyPaths**, which cover the “read” half very well.

- `KeyPath<Whole, Part>` is basically: `(Whole) -> Part`
- `WritableKeyPath<Whole, Part>` can mutate a *var* in place
- A **Lens** generalizes immutable updates: set/modify without mutation

This document covers:
1) a minimal Lens powered by KeyPath
2) composing lenses for nested updates
3) a minimal Prism for enums
4) when optics are worth it

---

## 1) The immutable update problem

```swift
struct Profile { let name: String }
struct User { let id: String; let profile: Profile }
struct AppState { let user: User }
```

Updating `name` immutably means rebuilding each layer:

```swift
let newProfile = Profile(name: "New")
let newUser = User(id: state.user.id, profile: newProfile)
let newState = AppState(user: newUser)
```

This is correct, but noisy at scale.

---

## 2) A tiny Lens type

A lens provides:
- `get` to read the focused part
- `set` to produce a new whole with an updated part

```swift
struct Lens<Whole, Part> {
    let get: (Whole) -> Part
    let set: (Part, Whole) -> Whole

    func modify(_ f: (Part) -> Part) -> (Whole) -> Whole {
        { whole in
            let part = self.get(whole)
            return self.set(f(part), whole)
        }
    }
}
```

### Building a Lens from a KeyPath

KeyPath is a perfect getter:

```swift
extension Lens {
    static func fromKeyPath(
        _ keyPath: KeyPath<Whole, Part>,
        set: @escaping (Part, Whole) -> Whole
    ) -> Lens<Whole, Part> {
        .init(get: { $0[keyPath: keyPath] }, set: set)
    }
}
```

---

## 3) Compose lenses (nested focus)

Lens composition lets you create a lens to a deep field.

```swift
extension Lens {
    func then<Subpart>(_ other: Lens<Part, Subpart>) -> Lens<Whole, Subpart> {
        Lens<Whole, Subpart>(
            get: { whole in other.get(self.get(whole)) },
            set: { subpart, whole in
                let part = self.get(whole)
                let newPart = other.set(subpart, part)
                return self.set(newPart, whole)
            }
        )
    }
}
```

### Example: composing with KeyPath-based getters

```swift
struct Profile: Equatable { let name: String }
struct User: Equatable { let id: String; let profile: Profile }
struct AppState: Equatable { let user: User }

let userL = Lens<AppState, User>.fromKeyPath(\AppState.user) { newUser, state in
    AppState(user: newUser)
}

let profileL = Lens<User, Profile>.fromKeyPath(\User.profile) { newProfile, user in
    User(id: user.id, profile: newProfile)
}

let nameL = Lens<Profile, String>.fromKeyPath(\Profile.name) { newName, profile in
    Profile(name: newName)
}

let appUserName = userL.then(profileL).then(nameL)
```

Now update is one line:

```swift
let updated = appUserName.set("Alice", state)
let uppercased = appUserName.modify { $0.uppercased() }(state)
```

---

## 4) Prism for enums (sum type focus)

A prism focuses on one enum case.
- extraction may fail (`Part?`)
- injection always works (`Part -> Whole`)

```swift
struct Prism<Whole, Part> {
    let tryGet: (Whole) -> Part?
    let inject: (Part) -> Whole
}
```

Example:

```swift
enum Screen: Equatable {
    case home
    case details(id: String)
}

let detailsPrism = Prism<Screen, String>(
    tryGet: { screen in
        if case .details(let id) = screen { return id }
        return nil
    },
    inject: { .details(id: $0) }
)
```

---

## 5) When optics are worth it

Use optics when:
- your reducer state is deep and you update it often
- you keep writing “rebuild the parent” boilerplate
- you want reusable transformations like `modify { ... }`

Avoid optics when:
- your state is shallow
- updates are rare
- the team is not comfortable with the abstraction

A good compromise:
- use KeyPaths for **readability**
- introduce a tiny Lens only when immutability boilerplate becomes painful
