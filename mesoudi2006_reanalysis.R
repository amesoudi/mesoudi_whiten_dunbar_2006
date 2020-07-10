# re-analyse data from Mesoudi, Whiten & Dunbar (2006), transmission chain experiments showing transmission advantage for social info over non-social individual and non-social physical info, using multilevel models instead of mixed ANOVAs

library(ggplot2)
library(readr)
library(nlme)


# experiment 1---------------------------------

# change path below to file location. Generation is numeric, while chain, participant, gender and material are factors
gossip_exp1 <- read_csv("mesoudi2006_exp1_data.csv", col_types = cols(chain = col_factor(levels = c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10")), gender = col_factor(levels = c("m", "f")), material = col_factor(levels = c("gossip", "social", "individual", "physical")), participant = col_character()))
gossip_exp1$participant <- factor(gossip_exp1$participant)

# figures------------------

# colorblind pallette
cbPalette <- c("#D55E00", "#E69F00", "#56B4E9", "#009E73", "#999999", "#CC79A7")

# plot total propositions recalled (Fig 1)
ggplot(gossip_exp1, aes(x=generation, y=total_recall, colour = material)) + stat_summary(fun = mean, geom = "line", size = 1.5, aes(group = material, colour = material)) + stat_summary(fun = mean, geom = "point", size = 3, aes(shape = material)) + stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.2, size = 1) + theme_classic(base_size = 16) + labs(x = "generation", y = "total propositions recalled") + scale_colour_manual(values=cbPalette)

# plot correct recalled propositions (Fig 2)
ggplot(gossip_exp1, aes(generation, correct_recall, colour = material)) + stat_summary(fun = mean, geom = "line", size = 1.5, aes(group = material, colour = material)) + stat_summary(fun = mean, geom = "point", size = 3, aes(shape = material)) + stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.2, size = 1) + theme_classic(base_size = 16) + labs(x = "generation", y = "correctly recalled propositions") + scale_colour_manual(values=cbPalette)


# participants nested within chains (generation as numeric - see below for categorical) ------------

# total recall: same as in paper. Gossip higher than both ind and physical. No effect of gender, strong effect of generation
summary(lme(total_recall ~ gender + material + generation, data = gossip_exp1, random = ~1|chain / participant, method = "ML"))

# correct recall: again, gossip is higher than individual and physical, as in the original. Unlike the original, gender is just significiant at p<0.05.
summary(lme(correct_recall ~ gender + material + generation, data = gossip_exp1, random = ~1|chain / participant, method = "ML"))

# recode generation as categorical
gossip_exp1$generation.cat <- factor(gossip_exp1$generation)
levels(gossip_exp1$generation.cat) <- c("F1", "F2", "F3", "F4")

# categorical generation is virtually identical to numeric generation for material and gender, but also shows magnitude of diff between each generation
summary(lme(total_recall ~ gender + material + generation.cat, data = gossip_exp1, random = ~1|chain / participant, method = "ML"))
summary(lme(correct_recall ~ gender + material + generation.cat, data = gossip_exp1, random = ~1|chain / participant, method = "ML"))


# experiment 2---------------------------------

# Generation is numeric, while chain, participant, gender and material are factors
gossip_exp2 <- read_csv("mesoudi2006_exp2_data.csv", col_types = cols(chain = col_factor(levels = c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10")), gender = col_factor(levels = c("m", "f")), material = col_factor(levels = c("gossip", "social", "individual", "physical")), participant = col_character()))
gossip_exp2$participant <- factor(gossip_exp2$participant)

# figures------------------

# colorblind pallette
cbPalette <- c("#D55E00", "#E69F00", "#56B4E9", "#009E73", "#999999", "#CC79A7")

# plot total propositions recalled (Fig 3)
ggplot(gossip_exp2, aes(generation, total_recall, colour = material)) + stat_summary(fun = mean, geom = "line", size = 1.5, aes(group = material, colour = material)) + stat_summary(fun = mean, geom = "point", size = 3, aes(shape = material)) + stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.2, size = 1) + theme_classic(base_size = 16) + labs(x = "generation", y = "total propositions recalled") + scale_colour_manual(values=cbPalette)

# plot correct recalled propositions (Fig 4)
ggplot(gossip_exp2, aes(generation, correct_recall, colour = material)) + stat_summary(fun = mean, geom = "line", size = 1.5, aes(group = material, colour = material)) + stat_summary(fun = mean, geom = "point", size = 3, aes(shape = material)) + stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.2, size = 1) + theme_classic(base_size = 16) + labs(x = "generation", y = "correctly recalled propositions") + scale_colour_manual(values=cbPalette)


# participants nested within chains (generation as numeric - see below for categorical) ------------

# total recall: same as in paper. Gossip no different to social, both are higher than ind and physical. No effect of gender, strong effect of generation
summary(lme(total_recall ~ gender + material + generation, data = gossip_exp2, random = ~1|chain / participant, method = "ML"))

# correct recall: As before, no effect of gender and strong effect of generation. But here gossip is higher than social, unlike the original analysis. Gossip and social both higher than ind and physical, as in the original.
summary(lme(correct_recall ~ gender + material + generation, data = gossip_exp2, random = ~1|chain / participant, method = "ML"))

# recode generation as categorical
gossip_exp2$generation.cat <- factor(gossip_exp2$generation)
levels(gossip_exp2$generation.cat) <- c("F1", "F2", "F3", "F4")

# categorical generation is virtually identical to numeric generation for material and gender, but also shows magnitude of diff between each generation
summary(lme(total_recall ~ gender + material + generation.cat, data = gossip_exp2, random = ~1|chain / participant, method = "ML"))
summary(lme(correct_recall ~ gender + material + generation.cat, data = gossip_exp2, random = ~1|chain / participant, method = "ML"))

# model comparison approach -------------------

# nullmodel
m0<-(lme(correct_recall ~ 1, data = gossip_exp2, random = ~1|chain / participant, method = "ML"))
summary(m0)

# model 1: gender, material and generation as fixed effects
m1<-(lme(correct_recall ~ gender + material + generation, data = gossip_exp2, random = ~1|chain / participant, method = "ML"))
summary(m1)

#model comparison between null model (m0) and model 1
anova(m0,m1)

# model 2, material and generation as fixed effects
m2<-(lme(correct_recall ~ material + generation, data = gossip_exp2, random = ~1|chain / participant, method = "ML"))
summary(m2)

# model comparison between model 1 and model 2
anova(m1,m2)

# model 3: material, generation and the interaction between material and generation as fixed effects
m3<-(lme(correct_recall ~ material + generation + material*generation, data = gossip_exp2, random = ~1|chain / participant, method = "ML"))

#model comparison between model 2 and model 3
anova(m2,m3)

# model 4: generation as unique fixed effect
m4<-(lme(correct_recall ~ generation, data = gossip_exp2, random = ~1|chain / participant, method = "ML"))
#model comparison between m2 and m4
anova(m4,m2)

anova(m0,m1,m2,m3,m4)
# Results show that model 2 has better fit than the null model and the only-generation model but similar fit to the interaction model and the model without gender. 