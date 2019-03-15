# Can we achieve a perfect solution for CADOES?

cad <- readRDS("./workshop/cadoes.rds") # dataset with measurements from pelvic bones

# Exercise 1: What are the dimensions of cad?

# Exercise 2: Explore the general structure of the data

# Exercise 3: Remove the categorical variables.


# Exercise 4: Calculate a t-SNE and visualize it

cadT <- Rtsne(?, dims = ?, verbose = ?, max_iter = 500)
# visualizing
# DO A PLOT OF cadT here

# Exercise 5: Calculate a UMAP and visualize it

cadU <- umap(?, scale = ?, verbose = ?)
vizier::embed_plot(?, ?, title = ?)

# Exercise 6: Calculate a supervised umap and visualize it

cadS <- umap()
vizier::embed_plot(cadS, ?, title = "UMAP 2D mapping of CADOES (semi-supervised)")

# But does this always work?

## 75% of the sample size
smp_size <- floor(0.75 * nrow(cad))

## set the seed to make your partition reproducible
set.seed(1992)
train_ind <- sample(seq_len(nrow(cad)), size = smp_size)

# Exercise 7: Separate your dataset in "train" and a "test" set

set.seed(1992)
cadTRAIN <- umap(train[,3:40], scale = TRUE, verbose = TRUE, y = train$SEX, ret_model = TRUE)
vizier::embed_plot(cadTRAIN$embedding, train$SEX,
                   title = "UMAP 2D mapping of CADOES (semi-supervised)")

# Embedding New Data

# To embed new data, use the umap_transform function.
# Pass the new data and the trained UMAP model.
# There’s no difference between using a standard UMAP model:
set.seed(1992)
cadTEST <- umap_transform(test[,3:40], cadTRAIN)
vizier::embed_plot(cadTEST, test$SEX,
                   title = "UMAP 2D mapping of CADOES (semi-supervised)")

# Exercise 8: Estimate error

# No free lunch theorem...