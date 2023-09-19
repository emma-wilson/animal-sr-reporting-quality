# EVALUATING THE REPORTING QUALITY OF NDC ANIMAL SYSTEMATIC REVIEWS ============

# Code written by Emma Wilson
# Tested in R Version 4.2.1

# Initial code written with test data. Will be updated.

# Load Libraries ---------------------------------------------------------------

library(dplyr)   # Version 1.1.2
library(tidyr)   # Version 1.3.0
library(ggplot2) # Version 3.4.2

# Read in Data -----------------------------------------------------------------

# NOTE: This is test data used to help write code for data visualisations.
# Basically I'm bad at making graphs so I hate leaving it to the end.

#Create example unique ID
uid <- c(1,2,3,4,5,6) 

# Create example reporting item scores
item1 <- c("Yes", "Yes", "No", "Yes", "Yes", "No")
item2 <- c("Yes", "No", "No", "Yes", "Yes", "No") 
item3 <- c("Yes", "No", "Not applicable", "Yes", "Yes", "No") 

# Create a dataframe
dat <- data.frame(uid, item1, item2, item3)

# Transform Data ---------------------------------------------------------------

# Pivot from wide to long format and count the number of studies with each score
dat_long <- dat %>%
  # Pivot
  pivot_longer(!uid, names_to = "item", values_to = "score") %>%
  # Group
  group_by(item, score) %>%
  # Count number of studies
  count()

# Make score a factor and set order of levels
dat_long$score <- factor(dat_long$score, 
                         levels = c("Not applicable", "No", "Yes"))

# Set Labels for Graphs --------------------------------------------------------

# Labels are the PRISMA-Pre reporting criteria text
# \n can be used within the text to create a new line

# Set example labels
mylabels <- c("Question 3\nMore text", "Question 2 loooooooooooooooooooooooooooooooooooooong text", "Question 1")

# Create Graph -----------------------------------------------------------------

# Create a horizontal stacked bar plot.

# Select data
p_title <- ggplot(dat_long, aes(x = item, y = n, label = n)) +
  # Stacked based on score (yes, no, etc.)
  # Set column width
  # Set border colour (black)
  geom_col(aes(fill = score), width = 0.5, color = "black") +
  # Set bar as horizontal
  coord_flip() +
  # Set stacked bar colours and reverse the legend order
  # This is for cosmetic reasons because creating a horizontal graph
  # changes the order data are presented
  scale_fill_manual(values = c("grey", "white", "black"), 
                    guide = guide_legend(reverse = T)) +
  # Set the background theme and make all text size 20
  theme_linedraw(base_size = 14) +
  # Chane position of legend and remove legend title
  theme(legend.position = "bottom", legend.title = element_blank()) +
  # Set X scale (actually appears in Y axis position because it's flipped) 
  # using defined labels
  scale_x_discrete(labels = mylabels) +
  # Set Y and X lab (again, reversed position!)
  ylab("Number of publications") +
  xlab(element_blank()) +
  # Set title
  ggtitle("Reporting in title")
  
# Save Graphs ------------------------------------------------------------------

# Ensure the width is long enough for all graphics and text
# 280mm chosen to fit onto landscape A4 page

ggsave("figures/visualisation_title.png", plot = p_title, width = 280, units = "mm")
