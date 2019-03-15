# Can we achieve a perfect solution for CADOES?

cad <- readRDS("./workshop/cadoes.rds") # dataset with measurements from pelvic bones
dim(cad)
names(cad) # your can use scr() or summary() to have a better look at the data
cadoes <- na.omit(cad[ , -c(1:2)]) # only the numbers (vertebral heights)
str(cad)

# t-SNE 

cadT <- Rtsne(cadoes, dims = 2, verbose = TRUE, max_iter = 500)
# visualizing
vizier::embed_plot(cadT$Y, cad$SEX,
                   title = "t-sne 2D mapping of CADOES")

# UMAP

cadU <- umap(cadoes, scale = TRUE, verbose = TRUE)
vizier::embed_plot(cadU, cad$SEX,
                   title = "UMAP 2D mapping of CADOES (unsupervised)")

# UMAP with a Y-target

cadS <- umap(cadoes, scale = TRUE, verbose = TRUE, y = cad$SEX)
vizier::embed_plot(cadS, cad$SEX,
                   title = "UMAP 2D mapping of CADOES (semi-supervised)")

# But does this always work?

## 75% of the sample size
smp_size <- floor(0.75 * nrow(cad))

## set the seed to make your partition reproducible
set.seed(1992)
train_ind <- sample(seq_len(nrow(cad)), size = smp_size)

train <- cad[train_ind, ]
test <- cad[-train_ind, ]
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

6/nrow(test) # Accuracy close to 91%

# No free lunch theorem...