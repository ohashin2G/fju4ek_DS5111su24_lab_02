# Database Design and Build - Part 1

## Design Questions Part 1

1)	(3 PTS) What tables should you build?
	•	courses
	•	terms
	•	instructors
	•	courses_offered
	•	learning_outcome
	•	assigned_instructors

2)	(2 PTS) For each table, what field(s) will you use for primary key? 
	•	terms – term_id
	•	courses – course_id
	•	instructors – instructor_id
	•	course_offered _id 
	•	learning_outcome_id
	•	assigned_instructors_id

3)	(2 PTS) For each table, what foreign keys will you use?
	•	course_offered – term_id
	•	course_offered – course_id
	•	learning_outcome – course_id
	•	assigned_instructors – term_id
	•	assigned_instructors – course_id
	•	assigned_instructors – instructor_id

4)	(2 PTS) Learning outcomes, courses, and instructors need a flag to indicate if they are currently active or not. How will your database support this feature? In particular: 
a.	If a course will be taught again, it will be flagged as active. If the course won’t be taught again, it will be flagged as inactive.
	•	ds6003	Practice and Application of Data Science Part 2
	•	ds6012	Big Data Ethics Part 2

b.	It is important to track if an instructor is a current employee or not.
	•	Jeremy Bolton is not a current employee
	•	Luis Felipe Rosado Murillo is not a current employee

c.	Learning outcomes for a course can change. You’ll want to track if a learning outcome is currently active or not.

5)	(1 PT) Is there anything to normalize in the database, and if so, how will you normalize it? Recall the desire to eliminate redundancy.
	•	Removed redundancy from `instructors`
	•	First normal form (1NF)
		o	Created primary keys for each entity 
		o	Identified foreign keys
		o	For `assigned_instructor` table, the `course_name` column contained non-atomic values.  The attribute was divided into `mnemonic` and `course_name`. 
	•	Second normal form (2NF)
		o	In the assigned_instructors attribute, all the non-prime attributes need to depend on all of the attributes within the primary key.  In other words, `mnemonic` is functionally dependent on `terms` if the value of `terms` implies a specific value for `mnemonic`.  
	•	Third normal form (3NF)
		o	`instructors` depends on `mnemonic`.  Removed `mnemonic` from the `course_offered` attribute.

6)	(1 PT) Are there indexes that you should build? Explain your reasoning.
	•	Created `_id’s` as indexes.  By making indexes, it creates a simple reference.  For example, `mnemonic` is not consistent.  It has a mix of numbers and letters or long strings.  Making a unique identifier for each unique entry is DB-friendly.

7)	(2 PTS) Are there constraints to enforce? Explain your answer and strategy.
For example, these actions should not be allowed:
- Entering learning objectives for a course not offered by the School of Data Science
- Assigning an invalid instructor to a course
	•	Limit to accept only defined course IDs that the School of Data Science offers.  Enforce a query that gives an error to an invalid value. 
	•	Limit to accept only active instructors.  Enforce a query to reject inactive instructors.
	•	Limit to accept a correct assigned instructor matches with a combination of `term` and `course_id`.  The entry and `assigned_instructors` must be unique.  
	•	Each cell should have a single value.   

8)	(5 PTS) Draw and submit a Relational Model for your project. For an example, see Beginning Database Design Solutions page 115 Figure 5-28.
	•	![Entity Relationship Diagram](DS5111_LO_diagaram.png)

9)	(2 PTS) Suppose you were asked if your database could also support the UVA SDS Residential MSDS Program. Explain any issues that might arise, changes to the database structure (schema), and new data that might be needed. Note you won’t actually need to support this use case for the project.
	•	The original scope was only for the UVA SDS Online MSDS Program.  The database is scalable by adding the residential instructors, terms, courses, and outcomes if the new data is available.  

