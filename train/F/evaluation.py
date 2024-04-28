# Import necessary libraries and modules
from sklearn.metrics import auc
import numpy as np
from sklearn.metrics import precision_recall_curve
import sklearn.metrics as metrics

# Load test data and predictions from .dat files
y = np.loadtxt('test_gs.dat')
pred = np.loadtxt('output.dat')

# Calculate False Positive Rate (FPR), True Positive Rate (TPR), and thresholds
fpr, tpr, thresholds = metrics.roc_curve(y, pred, pos_label=1)

# Calculate the Area Under the Curve (AUC) for ROC curve
the_auc = metrics.auc(fpr, tpr)

# Open 'auc.txt' file in write mode
F = open('auc.txt', 'w')

# Write the calculated AUC to 'auc.txt' file
F.write('%.4f\n' % the_auc)

# Close the 'auc.txt' file
F.close()

# Calculate precision, recall, and thresholds
precision, recall, thresholds = precision_recall_curve(y, pred)

# Calculate the Area Under the Precision-Recall Curve (AUPRC)
the_auprc = auc(recall, precision, reorder=False)

# Open 'auprc.txt' file in write mode
F = open('auprc.txt', 'w')

# Write the calculated AUPRC to 'auprc.txt' file
F.write('%.4f\n' % the_auprc)

# Close the 'auprc.txt' file
F.close()
