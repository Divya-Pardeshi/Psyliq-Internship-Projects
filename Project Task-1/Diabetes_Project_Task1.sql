-- Diabetes Prediction -- PSYLIQ Internship Task 1
-- 1. Retrieve the patient_id and ages of all patients.
SELECT Patient_id,
IFNULL(TIMESTAMPDIFF(YEAR,STR_TO_DATE(`D.O.B`, '%d-%m-%Y'), CURDATE()),0) AS Age
FROM diabetes.diabetes_prediction;

-- 2. Select all female patients who are older than 30.
SELECT * FROM diabetes.diabetes_prediction
WHERE gender = 'Female' AND TIMESTAMPDIFF(YEAR,STR_TO_DATE(`D.O.B`,'%d-%m-%Y'),CURDATE())>30;

-- 3. Calculate the average BMI of patients.
SELECT ROUND(AVG(bmi),2) AS average_bmi
FROM diabetes.diabetes_prediction;

-- 4. List patients in descending order of blood glucose levels.
SELECT Patient_id, blood_glucose_level
FROM diabetes.diabetes_prediction
ORDER BY blood_glucose_level DESC;

-- 5. Find patients who have hypertension and diabetes.
SELECT Patient_id 
FROM diabetes.diabetes_prediction
WHERE hypertension = 1 AND diabetes = 1;

-- 6. Determine the number of patients with heart disease.
SELECT COUNT(*) AS total_heart_patients
FROM diabetes.diabetes_prediction
WHERE heart_disease =1;

-- 7. Group patients by smoking history and count how many smokers and non-smokers there are.
SELECT smoking_history, COUNT(Patient_id) AS count_of_patient
FROM diabetes.diabetes_prediction
GROUP BY smoking_history;

-- 8. Retrieve the Patient_id of patients who have a BMI greater than the average BMI.
SELECT Patient_id, bmi
FROM diabetes.diabetes_prediction
WHERE bmi>(SELECT AVG(bmi) FROM diabetes.diabetes_prediction);

-- 9. Find the patient with the highest HbA1c level and the patient with the lowest HbA1clevel
SELECT Patient_id, hbA1c_level
FROM diabetes.diabetes_prediction
WHERE hbA1c_level = (SELECT MAX(hbA1c_level) FROM diabetes.diabetes_prediction)
UNION
SELECT Patient_id, hbA1c_level
FROM diabetes.diabetes_prediction
WHERE hbA1c_level = (SELECT MIN(hbA1c_level) FROM diabetes.diabetes_prediction);

-- 10.Calculate the age of patients in years (assuming the current date as of now).
ALTER TABLE diabetes.diabetes_prediction
ADD COLUMN Age INT;

UPDATE diabetes.diabetes_prediction
SET Age = TIMESTAMPDIFF(YEAR,STR_TO_DATE(`D.O.B`, '%d-%m-%Y'), CURDATE());
SELECT Patient_id, Age FROM diabetes.diabetes_prediction;

-- 11. Rank patients by blood glucose level within each gender group.
SELECT Patient_id, gender, blood_glucose_level, 
RANK() OVER(PARTITION BY gender ORDER BY blood_glucose_level) AS patient_rank
FROM diabetes.diabetes_prediction;

-- 12. Update the smoking history of patients who are older than 40 to "Ex-smoker."
UPDATE diabetes.diabetes_prediction
SET smoking_history = 'Ex-smoker'
WHERE Age > 40;
SELECT * FROM diabetes.diabetes_prediction WHERE Age>40;

-- 13. Insert a new patient into the database with sample data.
INSERT INTO diabetes.diabetes_prediction
VALUES ('Dummy Name','PT1000000', 'Female', '1994-09-20', 0, 0, 'never', 24.5, 5.5,80,0,25);

SELECT * FROM diabetes.diabetes_prediction
WHERE EmployeeName ='Dummy Name';

-- 14. Delete all patients with heart disease from the database.
DELETE FROM diabetes.diabetes_prediction
WHERE heart_disease = 1;
SELECT * FROM diabetes.diabetes_prediction WHERE heart_disease = 1;

-- 15. Find patients who have hypertension but not diabetes using the EXCEPT operator.
SELECT * FROM diabetes.diabetes_prediction
WHERE hypertension=1 
EXCEPT
SELECT * FROM diabetes.diabetes_prediction
WHERE diabetes=1 ;

-- 16. Define a unique constraint on the "patient_id" column to ensure its values are unique.
# Modify Column Type:
ALTER TABLE diabetes.diabetes_prediction
MODIFY COLUMN Patient_id VARCHAR(255);
# Add Unique Constraint:
ALTER TABLE diabetes.diabetes_prediction
ADD CONSTRAINT unique_patient_id
UNIQUE (Patient_id);

-- 17. Create a view that displays the Patient_ids, ages, and BMI of patients.
CREATE VIEW patient_info AS
SELECT Patient_id, age, bmi
FROM diabetes.diabetes_prediction;


