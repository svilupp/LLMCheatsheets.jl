# MLJ Cheatsheet

## Package Name: MLJ.jl

## URL
[MLJ Repository](https://github.com/JuliaAI/MLJ.jl)

## Purpose
MLJ is a comprehensive Machine Learning toolbox for Julia that integrates various models and functionalities for machine learning tasks such as data preprocessing, model selection, hyperparameter tuning, and model evaluation.

## Installation
### Prerequisites
Ensure you have Julia installed. MLJ works with Julia 1.5 and above.

### Setting Up Environment
```julia
using Pkg
Pkg.activate("my_MLJ_env", shared=true)
Pkg.add("MLJ")
```

To run tests:
```julia
Pkg.test("MLJ")
```

## Usage Overview
### Import MLJ
```julia
using MLJ
```

## Main Features and Functions
### Core Components
- **MLJBase.jl**: Primary interface for machine workflows.
    - Data partitioning: `partition`
    - Dataset unpacking: `unpack`
    - Model evaluation: `evaluate`/`evaluate!`
    - Utility functions: `scitype`, `schema`

- **StatisticalMeasures.jl**: Performance metrics and evaluation tools.

- **MLJModels.jl**: Loading and managing models.
    - Load models: `using @load`

- **MLJTuning.jl**: Hyperparameter optimization.
    - Wrapper example: `TunedModel`

- **MLJIteration.jl**: Iterative modeling control.
    - Example: `IteratedModel` wrapper

- **MLJEnsembles.jl**: Ensemble modeling.
    - Example: `EnsembleModel` wrapper

### Key Components Example Usage

### Loading and Preprocessing Data
```julia
using MLJ
@load_iris |> pretty

# Example: Loading and previewing iris dataset
iris = load_iris()
select(rows(iris, 1:3)) |> pretty
schema(iris)
```
### Splitting Data
```julia
y, X = unpack(iris, ==(:target); rng=123)
```

### Training a Model
```julia
using MLJ
model = @load DecisionTreeClassifier
machine = machine(model, X, y)
fit!(machine)
```

### Evaluating a Model
```julia
evaluate!(machine, resampling=CV(nfolds=6), measure=accuracy)
```

### Pipeline Creation
```julia
using MLJ
pipe = Standardizer() |> OneHotEncoder() |> @load DecisionTreeClassifier
mach = machine(pipe, X, y)
fit!(mach)
```

### Hyperparameter Tuning
```julia
using MLJ
model = @load DecisionTreeClassifier
r = range(model, :max_depth, lower=1, upper=15)
self_tuning_model = TunedModel(model=model, resampling=Holdout(), range=r, measure=auc)
mach = machine(self_tuning_model, X, y)
fit!(mach)
```

## Detailed Examples

### Example: Print MLJ Version
```julia
using Pkg

const PROJECT_FILE = normpath(joinpath(dirname(@__FILE__), "..", "Project.toml"))
const MLJ_VERSION = VersionNumber(Pkg.TOML.parse(read(PROJECT_FILE, String))["tools"]["MLJ"]["version"])
println("Current MLJ version: ", MLJ_VERSION)
```

### Types and Implementations
#### Defining Custom Types
```julia
struct SupervisedScitype{input_scitype, target_scitype, prediction_type} end

# Usage Example in Model
model = SomeSupervisedModel()
scitype_info = scitype(model, DefaultConvention())
println(scitype_info.input_scitype)
println(scitype_info.target_scitype)
println(scitype_info.prediction_type)
```

### Model Composition
#### Linear Pipelines
```julia
using MLJ
pipe = (X -> coerce(X, :age=>Continuous)) |> ContinuousEncoder() |> @load KNNRegressor(K=2)
```

#### Model Stacking
```julia
using MLJ
Stack(model1, model2, ..)
```

### Saving and Loading Models
```julia
MLJBase.save("model_file.jlso", mach)       # Save
mach = machine("model_file.jlso")           # Load
restore!(mach)                              # Post-process
```

## Tips and Best Practices
- Always check and align the scientific types (scitypes) of your data using `schema` and `coerce`.
- Utilize `@load` for importing models and `@iload` for interactive loading.
- Evaluate models with cross-validation using `CV` as the resampling strategy.
- Employ `TunedModel` and `Grid`, `RandomSearch` for hyperparameter optimization.
- Use `IteratedModel` for iterative models and `EnsembleModel` for building ensemble models.

## Additional Resources
- **Official Documentation**: [MLJ Documentation](https://JuliaAI.github.io/MLJ.jl/dev/)
- **Tutorials and Walkthroughs**: [Data Science in Julia Tutorials](https://JuliaAI.github.io/DataScienceTutorials.jl/)
- **Community Support**: [Julia Discourse Machine Learning category](https://discourse.julialang.org/c/domain/machine-learning)

By following this cheatsheet, you should now be well-equipped to start using the MLJ framework for your machine learning projects in Julia! Enjoy coding!