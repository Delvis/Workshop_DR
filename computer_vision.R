#### Computer vision with digits!

library(readr)
library(Rtsne)
library(uwot)

# MNIST dataset

# This dataset contains handwritten grayscale digits from 0 to 9.
# Each image is encoded by a 28*28 matrix with gray intensity from 0 to 255.

train <- read_csv("./digit_train.csv")
test <- read_csv("./digit_test.csv")
train$label <- as.factor(train$label)

# shrinking the size for the time limit
numTrain <- 10000
set.seed(1)
rows <- sample(1:nrow(train), numTrain)
train <- train[rows,]

# OK! Remember how to do a PCA? 
digitsPC <- princomp(train[,-1])$scores[,1:2]

# plot the PCA
vizier::embed_plot(digitsPC, train$label, text = train$label,
                   title = "PCA 2D mapping of MNIST digits")

# Let's reflect...

# What about the state of the art... t-SNE
set.seed(1992) # for reproducibility
digitsTSNE <- Rtsne(train[,-1], dims = 2, perplexity = 30, verbose = TRUE, max_iter = 500)
# visualizing
vizier::embed_plot(digitsTSNE$Y, train$label, text = train$label,
                   title = "t-sne 2D mapping of MNIST digits")

# Let's reflect...

# Can you calculate the umap and plot it?

digitsUMAP <- umap(train[,-1], scale = TRUE, verbose = TRUE)
vizier::embed_plot(digitsUMAP, train$label, text = train$label,
                   title = "UMAP 2D mapping of MNIST digits (unsupervised)")

# but UMAP allows us to "cheat" and do semisupervised analysis

dUMAP <- umap(train[,-1], scale = TRUE, verbose = TRUE, y = train$label, spread = 16)
vizier::embed_plot(dUMAP, train$label, text = train$label,
                   title = "UMAP 2D mapping of MNIST digits (semi-supervised)")

# going back to CADOES