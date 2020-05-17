# coordinator_layout

## Example
```dart
CoordinatorLayout(
    maxHeight: 200,
    minHeight: kToolbarHeight + MediaQuery.of(context).padding.top,
    headers: [
        SliverCollapsingHeader(
            builder: (context, offset, diff) {
                return AppBar(
                title: Text("Home"),
                bottom: PreferredSize(
                    preferredSize: Size.fromHeight(diff),
                    child: Container(color: Colors.white),
                ),
                );
            },
        ),
    ],
    body: Container(height: null, child: buildBody(context)),
),
```

#### Fit content

```dart
CoordinatorLayout(
    headerMaxHeight: 200,
    headerMinHeight: kToolbarHeight + MediaQuery.of(context).padding.top,
    header:[ 
        Builder(builder: (context) {
            return SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverSafeArea(
                top: false,
                sliver: SliverCollapsingHeader(
                builder: (context, offset, diff) {
                    return AppBar(
                    title: Text("Home"),
                    bottom: PreferredSize(
                        preferredSize: Size.fromHeight(diff),
                        child: Container(color: Colors.white),
                    ),
                    );
                },
                ),
            ),
            );
        }),
    ],
    body: Container(height: null, child: buildBody(context)),
),
```