----- query to look up what is still on the job when getting the error:
-----   MsgBox "There are Actuals to Bill on this Job!", vbOKOnly, "Alert!"
SELECT * FROM xvr_PAPRJ_Actuals WHERE ActualsToBill <> 0 AND Project = '04613212agy'
SELECT * FROM xvr_PAPRJ_Actuals WHERE ActualsToBill <> 0 AND Project = '04609412agy'


/*

-------   This is the view xvr_PAPRJ_Actuals
SELECT     project, fsyear_num, SUM('Actuals') AS Actuals, SUM('BTD') AS BTD, ROUND(SUM('Actuals'), 2) - ROUND(SUM('BTD'), 2) AS ActualsToBill
FROM         (SELECT     act.project, act.fsyear_num, CASE WHEN a.acct_group_cd IN ('WA', 'WP', 'CM', 'FE') THEN CASE WHEN month(GetDate()) 
     = '1' THEN act.amount_bf + act.amount_01 WHEN month(GetDate()) 
     = '2' THEN act.amount_bf + act.amount_01 + act.amount_02 WHEN month(GetDate()) 
     = '3' THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 WHEN month(GetDate()) 
     = '4' THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 WHEN month(GetDate()) 
     = '5' THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 + act.amount_05 WHEN month(GetDate()) 
     = '6' THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 + act.amount_05 + act.amount_06 WHEN month(GetDate())
      = '7' THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 + act.amount_05 + act.amount_06 + act.amount_07
      WHEN month(GetDate()) 
     = '8' THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 + act.amount_05 + act.amount_06 + act.amount_07
      + act.amount_08 WHEN month(GetDate()) 
     = '9' THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 + act.amount_05 + act.amount_06 + act.amount_07
      + act.amount_08 + act.amount_09 WHEN month(GetDate()) 
     = '10' THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 + act.amount_05 + act.amount_06 + act.amount_07
      + act.amount_08 + act.amount_09 + act.amount_10 WHEN month(GetDate()) 
     = '11' THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 + act.amount_05 + act.amount_06 + act.amount_07
      + act.amount_08 + act.amount_09 + act.amount_10 + act.amount_11 WHEN month(GetDate()) 
     = '12' THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 + act.amount_05 + act.amount_06 + act.amount_07
      + act.amount_08 + act.amount_09 + act.amount_10 + act.amount_11 + act.amount_12 ELSE 0 END ELSE 0 END AS 'Actuals', 
     CASE WHEN c.control_code = 'BTD' OR
     a.acct_group_cd = 'PB' THEN CASE WHEN month(GetDate()) = '1' THEN act.amount_bf + act.amount_01 WHEN month(GetDate()) 
     = '2' THEN act.amount_bf + act.amount_01 + act.amount_02 WHEN month(GetDate()) 
     = '3' THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 WHEN month(GetDate()) 
     = '4' THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 WHEN month(GetDate()) 
     = '5' THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 + act.amount_05 WHEN month(GetDate()) 
     = '6' THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 + act.amount_05 + act.amount_06 WHEN month(GetDate())
      = '7' THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 + act.amount_05 + act.amount_06 + act.amount_07
      WHEN month(GetDate()) 
     = '8' THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 + act.amount_05 + act.amount_06 + act.amount_07
      + act.amount_08 WHEN month(GetDate()) 
     = '9' THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 + act.amount_05 + act.amount_06 + act.amount_07
      + act.amount_08 + act.amount_09 WHEN month(GetDate()) 
     = '10' THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 + act.amount_05 + act.amount_06 + act.amount_07
      + act.amount_08 + act.amount_09 + act.amount_10 WHEN month(GetDate()) 
     = '11' THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 + act.amount_05 + act.amount_06 + act.amount_07
      + act.amount_08 + act.amount_09 + act.amount_10 + act.amount_11 WHEN month(GetDate()) 
     = '12' THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 + act.amount_05 + act.amount_06 + act.amount_07
      + act.amount_08 + act.amount_09 + act.amount_10 + act.amount_11 + act.amount_12 ELSE 0 END ELSE 0 END AS 'BTD'
                       FROM          dbo.PJACTROL AS act LEFT OUTER JOIN
     dbo.PJACCT AS a ON act.acct = a.acct LEFT OUTER JOIN
     dbo.PJCONTRL AS c ON act.acct = c.control_data
                       WHERE      (a.acct_group_cd IN ('WA', 'WP', 'CM', 'PB', 'FE')) OR
     (c.control_code = 'BTD')) AS a
GROUP BY project, fsyear_num


*/
