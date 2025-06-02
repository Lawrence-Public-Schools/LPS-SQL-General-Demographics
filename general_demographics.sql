WITH plan_504_cte AS (
    SELECT
        CASE sped.SEC504PLANSTATUS
            WHEN '00' THEN 'Not in a 504 plan during the school year (00)'
            WHEN '01' THEN 'Was in a 504 plan during the school year (01)'
            WHEN '02' THEN 'Was on a 504 plan earlier this school year, but is not currently on a 504 plan (02)'
            ELSE 'Other/Unknown (' || NVL(sped.SEC504PLANSTATUS, 'NULL') || ')'
        END AS plan_504_status_label,
        COUNT(*) AS plan_504_count,
        ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS plan_504_percent
    FROM students stu
    LEFT JOIN PS.S_MA_STU_SPED_X sped ON stu.dcid = sped.STUDENTSDCID
    WHERE stu.enroll_status = 0
    GROUP BY
        CASE sped.SEC504PLANSTATUS
            WHEN '00' THEN 'Not in a 504 plan during the school year (00)'
            WHEN '01' THEN 'Was in a 504 plan during the school year (01)'
            WHEN '02' THEN 'Was on a 504 plan earlier this school year, but is not currently on a 504 plan (02)'
            ELSE 'Other/Unknown (' || NVL(sped.SEC504PLANSTATUS, 'NULL') || ')'
        END
    UNION ALL
    SELECT
        'Total',
        COUNT(*),
        100.0
    FROM students stu
    LEFT JOIN PS.S_MA_STU_SPED_X sped ON stu.dcid = sped.STUDENTSDCID
    WHERE stu.enroll_status = 0
),
english_learner_cte AS (
    SELECT
        CASE
            WHEN LOWER(ext.EL) IN ('frmr', 'former') THEN 'Former'
            WHEN LOWER(ext.EL) = 'no' THEN 'No'
            WHEN LOWER(ext.EL) = 'no-p' THEN 'No-P'
            WHEN LOWER(ext.EL) = 'ref' THEN 'Referral'
            WHEN LOWER(ext.EL) = 'yes' THEN 'Yes'
            WHEN LOWER(ext.EL) = 'yes-p' THEN 'Yes-P'
            ELSE 'Unknown'
        END AS english_learner_code,
        COUNT(*) AS el_count,
        ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS el_percent
    FROM students stu
    LEFT JOIN U_DEF_EXT_STUDENTS ext ON stu.dcid = ext.STUDENTSDCID
    WHERE stu.enroll_status = 0
    GROUP BY
        CASE
            WHEN LOWER(ext.EL) IN ('frmr', 'former') THEN 'Former'
            WHEN LOWER(ext.EL) = 'no' THEN 'No'
            WHEN LOWER(ext.EL) = 'no-p' THEN 'No-P'
            WHEN LOWER(ext.EL) = 'ref' THEN 'Referral'
            WHEN LOWER(ext.EL) = 'yes' THEN 'Yes'
            WHEN LOWER(ext.EL) = 'yes-p' THEN 'Yes-P'
            ELSE 'Unknown'
        END
    UNION ALL
    SELECT
        'Total',
        COUNT(*),
        100.0
    FROM students stu
    LEFT JOIN U_DEF_EXT_STUDENTS ext ON stu.dcid = ext.STUDENTSDCID
    WHERE stu.enroll_status = 0
),
sped_cte AS (
    SELECT
        CASE
            WHEN LOWER(ext.SPED) = 'yes' THEN 'Yes'
            WHEN LOWER(ext.SPED) = 'no' THEN 'No'
            WHEN LOWER(ext.SPED) = 'ref' THEN 'Referral'
            ELSE 'Unknown'
        END AS sped_code,
        COUNT(*) AS sped_count,
        ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS sped_percent
    FROM students stu
    LEFT JOIN U_DEF_EXT_STUDENTS ext ON stu.dcid = ext.STUDENTSDCID
    WHERE stu.enroll_status = 0
    GROUP BY
        CASE
            WHEN LOWER(ext.SPED) = 'yes' THEN 'Yes'
            WHEN LOWER(ext.SPED) = 'no' THEN 'No'
            WHEN LOWER(ext.SPED) = 'ref' THEN 'Referral'
            ELSE 'Unknown'
        END
    UNION ALL
    SELECT
        'Total',
        COUNT(*),
        100.0
    FROM students stu
    LEFT JOIN U_DEF_EXT_STUDENTS ext ON stu.dcid = ext.STUDENTSDCID
    WHERE stu.enroll_status = 0
)
, gender_cte AS (
    SELECT
        CASE
            WHEN LOWER(stu.gender) = 'm' THEN 'Male'
            WHEN LOWER(stu.gender) = 'f' THEN 'Female'
            ELSE 'Unknown'
        END AS gender_label,
        COUNT(*) AS gender_count,
        ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS gender_percent
    FROM students stu
    WHERE stu.enroll_status = 0
    GROUP BY
        CASE
            WHEN LOWER(stu.gender) = 'm' THEN 'Male'
            WHEN LOWER(stu.gender) = 'f' THEN 'Female'
            ELSE 'Unknown'
        END
    UNION ALL
    SELECT
        'Total',
        COUNT(*),
        100.0
    FROM students stu
    WHERE stu.enroll_status = 0
)
, ethnicity_cte AS (
    SELECT
        CASE stu.ethnicity
            WHEN '01' THEN 'African'
            WHEN '02' THEN 'American'
            WHEN '03' THEN 'American Indian'
            WHEN '04' THEN 'Arabic'
            WHEN '05' THEN 'Argentinian'
            WHEN '06' THEN 'Armenian'
            WHEN '07' THEN 'Trinidadian'
            WHEN '08' THEN 'Bolivian'
            WHEN '09' THEN 'Brazilian'
            WHEN '10' THEN 'Burmese'
            WHEN '11' THEN 'Cambodian'
            WHEN '12' THEN 'Canadian'
            WHEN '13' THEN 'Cape Verdean'
            WHEN '14' THEN 'Chilean'
            WHEN '15' THEN 'Chinese'
            WHEN '16' THEN 'Columbian'
            WHEN '17' THEN 'Costa Rican'
            WHEN '18' THEN 'Cuban'
            WHEN '19' THEN 'Czechoslovakian'
            WHEN '20' THEN 'Dominican'
            WHEN '21' THEN 'Dutch'
            WHEN '22' THEN 'Ecuadorian'
            WHEN '23' THEN 'Egyptian'
            WHEN '24' THEN 'El Salvadorian'
            WHEN '25' THEN 'English'
            WHEN '26' THEN 'Estonian'
            WHEN '27' THEN 'French'
            WHEN '28' THEN 'German'
            WHEN '29' THEN 'Greek'
            WHEN '30' THEN 'Guatemalan'
            WHEN '31' THEN 'Haitian'
            WHEN '32' THEN 'Hindi (Indian)'
            WHEN '33' THEN 'Hondurian'
            WHEN '34' THEN 'Hungarian'
            WHEN '35' THEN 'Iranian'
            WHEN '36' THEN 'Iraqi'
            WHEN '37' THEN 'Irish'
            WHEN '38' THEN 'Israeli'
            WHEN '39' THEN 'Italian'
            WHEN '40' THEN 'Jamaican'
            WHEN '41' THEN 'Japanese'
            WHEN '42' THEN 'Jordanian'
            WHEN '43' THEN 'Korean'
            WHEN '44' THEN 'Loatian'
            WHEN '45' THEN 'Latvian'
            WHEN '46' THEN 'Lebanese'
            WHEN '47' THEN 'Lithuanian'
            WHEN '48' THEN 'Mexican'
            WHEN '49' THEN 'Nicaraguan'
            WHEN '50' THEN 'Pakistani'
            WHEN '51' THEN 'Panamanian'
            WHEN '52' THEN 'Paraguayan'
            WHEN '53' THEN 'Peruvian'
            WHEN '54' THEN 'Phillipino'
            WHEN '55' THEN 'Polish'
            WHEN '56' THEN 'Portuguese'
            WHEN '57' THEN 'Puerto Rican'
            WHEN '58' THEN 'Roumanian'
            WHEN '59' THEN 'Russian'
            WHEN '60' THEN 'Scottish'
            WHEN '61' THEN 'Spanish (Spain)'
            WHEN '62' THEN 'Syrian'
            WHEN '63' THEN 'Taiwainese'
            WHEN '64' THEN 'Thai'
            WHEN '65' THEN 'Turkish'
            WHEN '66' THEN 'Uruguayan'
            WHEN '67' THEN 'Venezuelan'
            WHEN '68' THEN 'Vietnamese'
            ELSE 'Unknown'
        END AS ethnicity_label,
        COUNT(*) AS ethnicity_count,
        ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS ethnicity_percent
    FROM students stu
    WHERE stu.enroll_status = 0
    GROUP BY
        CASE stu.ethnicity
            WHEN '01' THEN 'African'
            WHEN '02' THEN 'American'
            WHEN '03' THEN 'American Indian'
            WHEN '04' THEN 'Arabic'
            WHEN '05' THEN 'Argentinian'
            WHEN '06' THEN 'Armenian'
            WHEN '07' THEN 'Trinidadian'
            WHEN '08' THEN 'Bolivian'
            WHEN '09' THEN 'Brazilian'
            WHEN '10' THEN 'Burmese'
            WHEN '11' THEN 'Cambodian'
            WHEN '12' THEN 'Canadian'
            WHEN '13' THEN 'Cape Verdean'
            WHEN '14' THEN 'Chilean'
            WHEN '15' THEN 'Chinese'
            WHEN '16' THEN 'Columbian'
            WHEN '17' THEN 'Costa Rican'
            WHEN '18' THEN 'Cuban'
            WHEN '19' THEN 'Czechoslovakian'
            WHEN '20' THEN 'Dominican'
            WHEN '21' THEN 'Dutch'
            WHEN '22' THEN 'Ecuadorian'
            WHEN '23' THEN 'Egyptian'
            WHEN '24' THEN 'El Salvadorian'
            WHEN '25' THEN 'English'
            WHEN '26' THEN 'Estonian'
            WHEN '27' THEN 'French'
            WHEN '28' THEN 'German'
            WHEN '29' THEN 'Greek'
            WHEN '30' THEN 'Guatemalan'
            WHEN '31' THEN 'Haitian'
            WHEN '32' THEN 'Hindi (Indian)'
            WHEN '33' THEN 'Hondurian'
            WHEN '34' THEN 'Hungarian'
            WHEN '35' THEN 'Iranian'
            WHEN '36' THEN 'Iraqi'
            WHEN '37' THEN 'Irish'
            WHEN '38' THEN 'Israeli'
            WHEN '39' THEN 'Italian'
            WHEN '40' THEN 'Jamaican'
            WHEN '41' THEN 'Japanese'
            WHEN '42' THEN 'Jordanian'
            WHEN '43' THEN 'Korean'
            WHEN '44' THEN 'Loatian'
            WHEN '45' THEN 'Latvian'
            WHEN '46' THEN 'Lebanese'
            WHEN '47' THEN 'Lithuanian'
            WHEN '48' THEN 'Mexican'
            WHEN '49' THEN 'Nicaraguan'
            WHEN '50' THEN 'Pakistani'
            WHEN '51' THEN 'Panamanian'
            WHEN '52' THEN 'Paraguayan'
            WHEN '53' THEN 'Peruvian'
            WHEN '54' THEN 'Phillipino'
            WHEN '55' THEN 'Polish'
            WHEN '56' THEN 'Portuguese'
            WHEN '57' THEN 'Puerto Rican'
            WHEN '58' THEN 'Roumanian'
            WHEN '59' THEN 'Russian'
            WHEN '60' THEN 'Scottish'
            WHEN '61' THEN 'Spanish (Spain)'
            WHEN '62' THEN 'Syrian'
            WHEN '63' THEN 'Taiwainese'
            WHEN '64' THEN 'Thai'
            WHEN '65' THEN 'Turkish'
            WHEN '66' THEN 'Uruguayan'
            WHEN '67' THEN 'Venezuelan'
            WHEN '68' THEN 'Vietnamese'
            ELSE 'Unknown'
        END
    UNION ALL
    SELECT
        'Total',
        COUNT(*),
        100.0
    FROM students stu
    WHERE stu.enroll_status = 0
)
, numbered_504 AS (
    SELECT plan_504_status_label, plan_504_count, plan_504_percent,
           ROW_NUMBER() OVER (ORDER BY plan_504_status_label) AS rn
    FROM plan_504_cte
)
, numbered_el AS (
    SELECT english_learner_code, el_count, el_percent,
           ROW_NUMBER() OVER (ORDER BY english_learner_code) AS rn
    FROM english_learner_cte
)
, numbered_sped AS (
    SELECT sped_code, sped_count, sped_percent,
           ROW_NUMBER() OVER (ORDER BY CASE WHEN sped_code = 'Total' THEN 0 ELSE 1 END, sped_code) AS rn
    FROM sped_cte
)
, numbered_gender AS (
    SELECT gender_label, gender_count, gender_percent,
           ROW_NUMBER() OVER (ORDER BY CASE WHEN gender_label = 'Total' THEN 0 ELSE 1 END, gender_label) AS rn
    FROM gender_cte
)
, numbered_ethnicity AS (
    SELECT ethnicity_label, ethnicity_count, ethnicity_percent,
           ROW_NUMBER() OVER (ORDER BY CASE WHEN ethnicity_label = 'Total' THEN 0 ELSE 1 END, ethnicity_label) AS rn
    FROM ethnicity_cte
)
SELECT
    g.gender_label,
    g.gender_count,
    g.gender_percent,
    s.sped_code,
    s.sped_count,
    s.sped_percent,
    p.plan_504_status_label,
    p.plan_504_count,
    p.plan_504_percent,
    e.english_learner_code,
    e.el_count,
    e.el_percent,
    eth.ethnicity_label,
    eth.ethnicity_count,
    eth.ethnicity_percent
FROM (
    SELECT plan_504_status_label, plan_504_count, plan_504_percent, ROW_NUMBER() OVER (ORDER BY CASE WHEN plan_504_status_label = 'Total' THEN 0 ELSE 1 END, plan_504_status_label) AS rn
    FROM plan_504_cte
) p
FULL OUTER JOIN (
    SELECT english_learner_code, el_count, el_percent, ROW_NUMBER() OVER (ORDER BY CASE WHEN english_learner_code = 'Total' THEN 0 ELSE 1 END, english_learner_code) AS rn
    FROM english_learner_cte
) e ON p.rn = e.rn
FULL OUTER JOIN (
    SELECT sped_code, sped_count, sped_percent, ROW_NUMBER() OVER (ORDER BY CASE WHEN sped_code = 'Total' THEN 0 ELSE 1 END, sped_code) AS rn
    FROM sped_cte
) s ON p.rn = s.rn OR e.rn = s.rn
FULL OUTER JOIN (
    SELECT gender_label, gender_count, gender_percent, ROW_NUMBER() OVER (ORDER BY CASE WHEN gender_label = 'Total' THEN 0 ELSE 1 END, gender_label) AS rn
    FROM gender_cte
) g ON p.rn = g.rn OR e.rn = g.rn OR s.rn = g.rn
FULL OUTER JOIN (
    SELECT ethnicity_label, ethnicity_count, ethnicity_percent, ROW_NUMBER() OVER (ORDER BY CASE WHEN ethnicity_label = 'Total' THEN 0 ELSE 1 END, ethnicity_label) AS rn
    FROM ethnicity_cte
) eth ON p.rn = eth.rn OR e.rn = eth.rn OR s.rn = eth.rn OR g.rn = eth.rn
ORDER BY COALESCE(p.rn, e.rn, s.rn, g.rn, eth.rn);

<th>Gender</th>
<th>Gender Count</th>
<th>Gender Percent</th>
<th>SPED Code</th>
<th>SPED Count</th>
<th>SPED Percent</th>
<th>SPED 504 Code</th>
<th>SPED 504 Count</th>
<th>SPED 504 Percent</th>
<th>English Learner Code</th>
<th>English Learner Count</th>
<th>English Learner Percent</th>
<th>Ethnicity</th>
<th>Ethnicity Count</th>
<th>Ethnicity Percent</th>