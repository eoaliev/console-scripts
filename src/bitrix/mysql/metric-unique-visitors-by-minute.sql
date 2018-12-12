SELECT
    CONCAT_WS(
        '-',
        YEAR(`CREATION_DATE`),
        MONTH(`CREATION_DATE`),
        DAYOFMONTH(`CREATION_DATE`),
        HOUR(`CREATION_DATE`),
        MINUTE(`CREATION_DATE`)
    ),
    COUNT(DISTINCT `VISITOR_ID`)
FROM `b_mp_metric`
WHERE
    YEAR(`CREATION_DATE`) = 2018
    AND MONTH(`CREATION_DATE`) IN (10, 11, 12)
    AND (
        `UTM` IS NOT NULL
        OR (
            `REFERRER` IS NOT NULL
            AND `REFERRER` NOT LIKE '%matras-strong.ru%'
        )
    )
GROUP BY
    CONCAT_WS(
        '-',
        YEAR(`CREATION_DATE`),
        MONTH(`CREATION_DATE`),
        DAYOFMONTH(`CREATION_DATE`),
        HOUR(`CREATION_DATE`),
        MINUTE(`CREATION_DATE`)
    )
ORDER BY
    COUNT(DISTINCT `VISITOR_ID`) DESC;
