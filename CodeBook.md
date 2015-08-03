Codebook

Output 1: mean_std_data.txt

The run_analysis.R script reads training and test data and assigns column labels using the features.txt file. The script then adds outcome values (y_train.txt, y_test.txt) and subject identifier information (subject_train.txt, subject_test.txt) to the features for both the training and test datasets separately. The union of the training and test datasets in then created.

Only the measurements of a mean or standard deviation are preserved (along with the added outcomes and subject data). An additional column with more descriptive activity labels is then added to the data frame based on the activity_labels.txt data.

The mean_std_data.txt file is then generated.

Output 2: avg_actv_subj_data.txt

The avg_actv_subj_data.txt is then generated with the average of each variable for each activity and each subject.
