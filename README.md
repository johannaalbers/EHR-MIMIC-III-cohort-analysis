# Exposure to microorganisms and primary diagnosis in MIMIC-III

A SQL exposure-outcome analysis on the MIMIC-III v1.4 critical care database. For every diagnosis and organism pair that clears a minimum sample size, the query returns testing rates, positivity rates and an odds ratio, computed entirely inside the database.

**Headline result:** the odds ratios recover known clinical causation without being told about it. Septicemia caused by *E. coli* returns an odds ratio near 52 for *E. coli* exposure, while coronary atherosclerosis sits between 0.3 and 0.5 for essentially every organism. The method separates infectious from non-infectious diagnoses on the strength of association alone.

---

## What the query does

A single SQL statement builds the cohort and computes the statistic. No data is pulled into R for processing.

1. Take the primary diagnosis (`SEQ_NUM = 1`) for every admission and join it to the ICD-9 description table.
2. Keep only organisms appearing in at least 200 distinct admissions across the whole database.
3. Count, per diagnosis and organism pair, the admissions with at least one positive culture, and keep pairs reaching 50 positive admissions.
4. Count admissions with that diagnosis that were tested at all, positive or negative, to form the denominator.
5. Compute the odds ratio of exposure given the diagnosis against exposure without it.

The two count thresholds exist because odds ratios computed on a handful of admissions swing wildly. They are a stability filter, not a significance test.

---

## Results

**Testing intensity follows clinical suspicion.** Infectious primary diagnoses such as unspecified septicemia are tested in 99 to 100 percent of admissions. Non-infectious diagnoses such as coronary atherosclerosis are tested in 60 to 80 percent. Cultures are ordered when infection is suspected, and more selectively otherwise, which is what one would expect from appropriate practice.

**Positivity separates the two groups sharply.** Septicemia due to *E. coli* returns a positivity rate around 76 percent for *E. coli*. Coronary atherosclerosis sits at 2 to 5 percent for most organisms, consistent with incidental colonisation rather than causation.

**Odds ratios recover the known aetiologies.** Pairs with a genuine causal link produce large ratios, the *E. coli* septicemia pair reaching roughly 52. Non-infectious diagnoses produce ratios below 1, between 0.3 and 0.5, indicating no association. Ratios near 1 indicate organisms with no relationship to the diagnosis.

The value of this is less the individual numbers than the check they provide: a method that reproduces established microbiology from routine hospital records is a method that can be trusted on questions where the answer is not already known.

---

## Study design

This is a retrospective observational analysis, conceptually equivalent to a case-control design. Exposure and outcome are both drawn from existing clinical records and their association is quantified with odds ratios. There is no intervention, no randomisation, and no basis for causal inference from the ratios alone.

### Limitations

- Only the primary diagnosis is used, so comorbidities are ignored. A septic patient admitted primarily for another condition is counted under that condition.
- A negative culture is treated as absence of any organism, which assumes one test detects all organism types equally well. It does not, so exposure is undercounted.
- Admissions are treated as independent. Patients with several admissions are counted more than once, which understates the true uncertainty.
- Testing is not random. Clinicians order cultures when they suspect infection, so the tested population differs systematically from the untested one. Every odds ratio here is conditional on having been tested.

---

## Data access and governance

MIMIC-III v1.4 requires credentialed access through PhysioNet and is governed by a Data Use Agreement.

- No patient-level data is contained in this repository.
- All notebook outputs are aggregate counts and ratios at the diagnosis and organism level.
- Database credentials are read from a local `creds.txt` that git excludes. `creds.txt.example` shows the format. No username, password or host name is committed.

---

## Running it

1. Obtain credentialed MIMIC-III access through PhysioNet and connect to the host institution's VPN.
2. Copy `creds.txt.example` to `creds.txt` and fill in your own values.
3. Open `EHR_MIMIC-III.ipynb` in an R kernel and run the cells in order.

R packages: `dplyr`, `tidyr`, `tibble`, `lubridate`, `readr`, `stringr`, `data.table`, `odbc`, `RMariaDB`.

---

## My contribution

Coursework for the MSc Health Data Science at Universitat Rovira i Virgili, revised afterwards. The SQL query, the interpretation and the limitations are my own work. The database and its access arrangements were provided by the course.
