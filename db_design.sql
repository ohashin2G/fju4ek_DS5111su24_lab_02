{
 "cells": [
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "# Database Design and Build - Part 2"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 1,
   "metadata": {},
   "outputs": [],
   "source": [
    "#%pip install numpy\n",
    "#%pip install panda\n",
    "import numpy as np\n",
    "import pandas as pd\n",
    "\n"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "## Use Case Questions\n",
    "1) (1 PT) Which courses are currently included (active) in the program? Include the course mnemonic and course name for each."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "SELECT\n",
    "mnemonic,\n",
    "course_name\n",
    "FROM courses_erd\n",
    "WHERE course_active = 'TRUE';\n"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "2) (1 PT) Which courses were included in the program, but are no longer active? Include the course mnemonic and course name for each."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "SELECT\n",
    "mnemonic,\n",
    "course_name\n",
    "FROM courses_erd\n",
    "WHERE course_active = 'FALSE';\n"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "3) (1 PT) Which instructors are not current employees?"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "SELECT\n",
    "instructor_name\n",
    "FROM instructors_erd\n",
    "WHERE employee_status = 'Inactive';\n"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "4) (1 PT) For each course (active and inactive), how many learning outcomes are there?"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "SELECT\n",
    "c.course_name,\n",
    "COUNT(o.learning_outcome)\n",
    "FROM courses_erd c, learning_outcome_erd o\n",
    "WHERE c.course_id = o.course_id\n",
    "GROUP BY c.course_name\n"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "5) (2 PTS) Are there any courses with no learning outcomes? If so, provide their mnemonics and names."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "SELECT\n",
    "c.course_name,\n",
    "FROM courses_erd c\n",
    "WHERE c.course_id NOT IN (SELECT course_id FROM learning_outcome_erd);\n"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "6) (2 PTS) Which courses include SQL as a learning outcome? Include the learning outcome descriptions, course mnemonics, and course names in your solution."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "SELECT\n",
    "c.course_name,\n",
    "o.learning_outcome,\n",
    "c.mnemonic\n",
    "FROM courses_erd c, learning_outcome_erd o\n",
    "WHERE c.course_id = o.course_id\n",
    "AND o.learning_outcome LIKE '%SQL%';\n"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "7) (1 PT) Who taught course ds5100 in Summer 2021?"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "SELECT\n",
    "a.term_id,\n",
    "c.mnemonic,\n",
    "i.instructor_name\n",
    "FROM assigned_instructors_erd a, instructors_erd i, courses_erd c\n",
    "WHERE a.instructor_id = i.instructor_id\n",
    "AND a.course_id = c.course_id\n",
    "AND a.term_id = '2021su'\n",
    "AND c.mnemonic = 'ds5100' ;\n"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "8) (1 PT) Which instructors taught in Fall 2021? Order their names alphabetically, making sure the names are unique.\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "SELECT\n",
    "a.term_id,\n",
    "i.instructor_name\n",
    "FROM assigned_instructors_erd a, instructors_erd i, courses_erd c\n",
    "WHERE a.instructor_id = i.instructor_id\n",
    "AND a.course_id = c.course_id\n",
    "AND a.term_id = '2021fa'\n",
    "GROUP BY (a.term_id, i.instructor_name)\n",
    "ORDER BY i.instructor_name;\n"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "9) (1 PT) How many courses did each instructor teach in each term? Order your results by term and then instructor.\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "SELECT\n",
    "a.term_id,\n",
    "i.instructor_name,\n",
    "COUNT(a.course_id),\n",
    "FROM assigned_instructors_erd a, instructors_erd i\n",
    "WHERE a.instructor_id = i.instructor_id\n",
    "GROUP BY (a.term_id, i.instructor_name)\n",
    "ORDER BY (a.term_id, i.instructor_name)\n"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "10a) (2 PTS) Which courses had more than one instructor for the same term? Provide the mnemonic and term for each. Note this occurs in courses with multiple sections."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "SELECT\n",
    "c.mnemonic,\n",
    "a.term_id\n",
    "FROM assigned_instructors_erd a, courses_erd c, instructors_erd i\n",
    "WHERE a.course_id = c.course_id\n",
    "GROUP BY (c.mnemonic, a.term_id)\n",
    "HAVING COUNT(DISTINCT a.instructor_id) > 1\n",
    "ORDER BY a.term_id, c.mnemonic\n"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "10b) (1 PT) For courses with multiple sections, provide the term, course mnemonic, and instructor name for each. Hint: You can use your result from 10a in a subquery or WITH clause."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "WITH courses_multiple_sections AS (\n",
    "    SELECT\n",
    "    c.mnemonic,\n",
    "    a.term_id\n",
    "    FROM assigned_instructors_erd a, courses_erd c, instructors_erd i\n",
    "    WHERE a.course_id = c.course_id\n",
    "    GROUP BY (c.mnemonic, a.term_id)\n",
    "    HAVING COUNT(DISTINCT a.instructor_id) > 1\n",
    "    ORDER BY a.term_id, c.mnemonic\n",
    ")\n",
    "SELECT  \n",
    "m.term_id,\n",
    "m.mnemonic,\n",
    "i.instructor_name\n",
    "FROM courses_multiple_sections m, assigned_instructors_erd a, instructors_erd i, courses_erd c\n",
    "WHERE c.course_id = a.course_id\n",
    "AND m.term_id = a.term_id\n",
    "AND a.instructor_id = i.instructor_id\n",
    "GROUP BY (m.mnemonic, m.term_id, i.instructor_name)\n",
    "HAVING COUNT(DISTINCT c.course_id) > 1\n",
    "ORDER BY m.term_id, m.mnemonic, i.instructor_name ;\n"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": ".venv",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.11.5"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 2
}
