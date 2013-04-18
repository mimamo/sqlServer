-- VW_IndirectAllocation
SELECT     dbo.vw_Period_ClientProd_Hours.CustId, dbo.vw_Period_ClientProd_Hours.Name, dbo.vw_Period_ClientProd_Hours.code_ID, 
                      dbo.vw_Period_ClientProd_Hours.descr, dbo.vw_Period_ClientProd_Hours.fiscalno, dbo.IndirectAllocation.Amount, 
                      dbo.vw_Period_ClientProd_Hours.ProductHours, 
                      dbo.vw_Period_ClientProd_Hours.ProductHours / dbo.vw_PeriodDirect.DirectHours * dbo.IndirectAllocation.Amount AS Allocation, 
                      dbo.IndirectAllocation.Type, dbo.vw_PeriodDirect.DirectHours
FROM         dbo.IndirectAllocation CROSS JOIN
                      dbo.vw_Period_ClientProd_Hours CROSS JOIN
                      dbo.vw_PeriodDirect
WHERE     (dbo.vw_Period_ClientProd_Hours.CustId <> '1PGGEN') AND (dbo.IndirectAllocation.Group1 = 'Allocate')


-- VW_RentAllocation
SELECT     dbo.vw_Period_ClientProd_Hours.CustId, dbo.vw_Period_ClientProd_Hours.Name, dbo.vw_Period_ClientProd_Hours.code_ID, 
                      dbo.vw_Period_ClientProd_Hours.descr, dbo.vw_Period_ClientProd_Hours.fiscalno, dbo.IndirectAllocation.Amount, 
                      dbo.vw_Period_ClientProd_Hours.ProductHours, 
                      dbo.vw_Period_ClientProd_Hours.ProductHours / dbo.vw_RentHours_Allocate.RentHours * dbo.IndirectAllocation.Amount AS Allocation, 
                      dbo.IndirectAllocation.Type, dbo.vw_RentHours_Allocate.RentHours
FROM         dbo.IndirectAllocation CROSS JOIN
                      dbo.vw_Period_ClientProd_Hours CROSS JOIN
                      dbo.vw_RentHours_Allocate
WHERE     (dbo.vw_Period_ClientProd_Hours.code_ID NOT IN ('WMFB', 'WMBL', 'WMBF', 'WKST', 'WFR', 'WEB', 'TOG', 'TIGM', 'SRN', 'SLK', 'SJSP', 'SJS', 
                      'SFO', 'SAN', 'PTNR', 'PTL', 'PPO', 'PLG', 'PHX', 'PGG', 'PBO', 'PAG', 'OOO', 'OCM', 'OAKP', 'OAK', 'NYK', 'NBN', 'MYF', 'MOF', 'MLI', 'MKI', 'MIV', 'MIE', 
                      'MFT', 'MFB', 'MDAM', 'MAN', 'LPD', 'LMB', 'LLA', 'LCD', 'KNA', 'KHA', 'IMS', 'FRT', 'FCB', 'EUN', 'EKN', 'DVR', 'DLS', 'DIG', 'DAR', 'CVP', 'CRST', 'CRP', 
                      'COPR', 'CMV', 'CIZ', 'CIE', 'CIC', 'CHG', 'CGS', 'CCOM', 'BWE', 'BMG', 'BLS', 'BHC', 'BFH', 'BCMA', 'ALL', '3RD')) AND 
                      (dbo.vw_Period_ClientProd_Hours.CustId <> '1PGGEN') AND (dbo.IndirectAllocation.Group1 = N'Allocate')


-- VW_RentHours_Allocate
SELECT     SUM(TTLHrs) AS RentHours, Type
FROM         dbo.Period_PL
WHERE     (NOT (code_ID IN ('WMFB', 'WMBL', 'WMBF', 'WKST', 'WFR', 'WEB', 'TOG', 'TIGM', 'SRN', 'SLK', 'SJSP', 'SJS', 'SFO', 'SAN', 'PTNR', 'PTL', 'PPO', 
                      'PLG', 'PHX', 'PGG', 'PBO', 'PAG', 'OOO', 'OCM', 'OAKP', 'OAK', 'NYK', 'NBN', 'MYF', 'MOF', 'MLI', 'MKI', 'MIV', 'MIE', 'MFT', 'MFB', 'MDAM', 'MAN', 
                      'LPD', 'LMB', 'LLA', 'LCD', 'KNA', 'KHA', 'IMS', 'FRT', 'FCB', 'EUN', 'EKN', 'DVR', 'DLS', 'DIG', 'DAR', 'CVP', 'CRST', 'CRP', 'COPR', 'CMV', 'CIZ', 'CIE', 
                      'CIC', 'CHG', 'CGS', 'CCOM', 'BWE', 'BMG', 'BLS', 'BHC', 'BFH', 'BCMA', 'ALL', '3RD'))) AND (Type = N'Direct') AND (CustId <> '1PGGEN')
GROUP BY Type

-- vw_Rent_ClientProd_Hours_all
SELECT     CustId, Name, code_ID, descr, ProductHours, fiscalno
FROM         (SELECT     CustId, Name, code_ID, descr, SUM(TTLHrs) AS ProductHours, fiscalno
                       FROM          dbo.Period_PL
                       WHERE      (Type = N'Direct') AND (code_ID IN ('CPPR', 'CPSE', 'MCNO', 'NBGL', 'NBNE', 'NBPR', 'MCTR', 'MGL', 'MLRS', 'MNE', 'MPR', 'MSE', 
                                              'MSWR', 'MPCR', 'MPGL', 'MPNE', 'MPPR', 'MPSE', 'CCTR', 'CGL', 'CLRS', 'CNER', 'CPR', 'CSER', 'CLPC', 'CPGL', 'CPNE')) AND 
                                              (SubAccount <> '1000')
                       GROUP BY CustId, Name, code_ID, descr, fiscalno
                       HAVING      (SUM(TTLHrs) <> 0) AND (CustId <> '1PGGEN')
                       UNION
                       SELECT     CustId, Name, code_ID, descr, SUM(TTLHrs) AS ProductHours, fiscalno
                       FROM         dbo.Period_PL AS Period_PL_1
                       WHERE     (Type = N'Direct') AND (code_ID NOT IN ('CPPR', 'CPSE', 'MCNO', 'NBGL', 'NBNE', 'NBPR', 'MCTR', 'MGL', 'MLRS', 'MNE', 'MPR', 'MSE', 
                                             'MSWR', 'MPCR', 'MPGL', 'MPNE', 'MPPR', 'MPSE', 'CCTR', 'CGL', 'CLRS', 'CNER', 'CPR', 'CSER', 'CLPC', 'CPGL', 'CPNE', 'CCUS', 'MLAA', 
                                             'MLLA', 'CHOU', 'CLES', 'CLVG', 'CPHL', 'CCCH', 'CFLD', 'MDVR', 'MSAC', 'CDVR', 'MCHI', 'MDLS', 'MDLS', 'MLBD', 'MOAK', 'MSAN', 'MLCD', 
                                             'MLHD', 'CMCB', 'CMIA', 'CNYK', 'CORL'))
                       GROUP BY CustId, Name, code_ID, descr, fiscalno
                       HAVING      (SUM(TTLHrs) <> 0) AND (CustId <> '1PGGEN')) AS a
					   
-- vw_RentHours_Allocate
SELECT     SUM(TTLHrs) AS RentHours, Type
FROM         dbo.Period_PL
WHERE     (NOT (code_ID IN ('WMFB', 'WMBL', 'WMBF', 'WKST', 'WFR', 'WEB', 'TOG', 'TIGM', 'SRN', 'SLK', 'SJSP', 'SJS', 'SFO', 'SAN', 'PTNR', 'PTL', 'PPO', 
                      'PLG', 'PHX', 'PGG', 'PBO', 'PAG', 'OOO', 'OCM', 'OAKP', 'OAK', 'NYK', 'NBN', 'MYF', 'MOF', 'MLI', 'MKI', 'MIV', 'MIE', 'MFT', 'MFB', 'MDAM', 'MAN', 
                      'LPD', 'LMB', 'LLA', 'LCD', 'KNA', 'KHA', 'IMS', 'FRT', 'FCB', 'EUN', 'EKN', 'DVR', 'DLS', 'DIG', 'DAR', 'CVP', 'CRST', 'CRP', 'COPR', 'CMV', 'CIZ', 'CIE', 
                      'CIC', 'CHG', 'CGS', 'CCOM', 'BWE', 'BMG', 'BLS', 'BHC', 'BFH', 'BCMA', 'ALL', '3RD'))) AND (Type = N'Direct') AND (CustId <> '1PGGEN')
GROUP BY Type

--vw_Rent_TOT_Hours_All
SELECT     SUM(RentHours) AS RentHours, Type
FROM         (SELECT     SUM(TTLHrs) AS RentHours, Type, CustId, code_ID
                       FROM          dbo.Period_PL
                       WHERE      (code_ID IN ('CPPR', 'CPSE', 'MCNO', 'NBGL', 'NBNE', 'NBPR', 'MCTR', 'MGL', 'MLRS', 'MNE', 'MPR', 'MSE', 'MSWR', 'MPCR', 'MPGL', 
                                              'MPNE', 'MPPR', 'MPSE', 'CCTR', 'CGL', 'CLRS', 'CNER', 'CPR', 'CSER', 'CLPC', 'CPGL', 'CPNE')) AND (SubAccount <> '1000')
                       GROUP BY Type, CustId, code_ID
                       UNION
                       SELECT     SUM(TTLHrs) AS RentHours, Type, CustId, code_ID
                       FROM         dbo.Period_PL AS Period_PL_1
                       WHERE     (NOT (code_ID IN ('CPPR', 'CPSE', 'MCNO', 'NBGL', 'NBNE', 'NBPR', 'MCTR', 'MGL', 'MLRS', 'MNE', 'MPR', 'MSE', 'MSWR', 'MPCR', 'MPGL', 
                                             'MPNE', 'MPPR', 'MPSE', 'CCTR', 'CGL', 'CLRS', 'CNER', 'CPR', 'CSER', 'CLPC', 'CPGL', 'CPNE', 'CCUS', 'MLAA', 'MLLA', 'CHOU', 'CLES', 
                                             'CLVG', 'CPHL', 'CCCH', 'CFLD', 'MDVR', 'MSAC', 'CDVR', 'MCHI', 'MDLS', 'MDLS', 'MLBD', 'MOAK', 'MSAN', 'MLCD', 'MLHD', 'CMCB', 'CMIA', 
                                             'CNYK', 'CORL')))
                       GROUP BY Type, CustId, code_ID) AS b
WHERE     (NOT (code_ID IN ('WMFB', 'WMBL', 'WMBF', 'WKST', 'WFR', 'WEB', 'TOG', 'TIGM', 'SRN', 'SLK', 'SJSP', 'SJS', 'SFO', 'SAN', 'PTNR', 'PTL', 'PPO', 
                      'PLG', 'PHX', 'PGG', 'PBO', 'PAG', 'OOO', 'OCM', 'OAKP', 'OAK', 'NYK', 'NBN', 'MYF', 'MOF', 'MLI', 'MKI', 'MIV', 'MIE', 'MFT', 'MFB', 'MDAM', 'MAN', 
                      'LPD', 'LMB', 'LLA', 'LCD', 'KNA', 'KHA', 'IMS', 'FRT', 'FCB', 'EUN', 'EKN', 'DVR', 'DLS', 'DIG', 'DAR', 'CVP', 'CRST', 'CRP', 'COPR', 'CMV', 'CIZ', 'CIE', 
                      'CIC', 'CHG', 'CGS', 'CCOM', 'BWE', 'BMG', 'BLS', 'BHC', 'BFH', 'BCMA', 'ALL', '3RD'))) AND (Type = N'Direct') AND (CustId <> '1PGGEN')
GROUP BY Type
	   
					   
-- vw_Period_ClientProd_Hours
SELECT     CustId, Name, code_ID, descr, SUM(TTLHrs) AS ProductHours, fiscalno
FROM         dbo.Period_PL
WHERE     (Type = N'Direct')
GROUP BY CustId, Name, code_ID, descr, fiscalno
HAVING      (SUM(TTLHrs) <> 0) AND (CustId <> '1PGGEN')


--- Last years Rent Allocation Fix
SELECT clntHrs.CustId
, clntHrs.Name
, clntHrs.code_ID
, clntHrs.descr
, clntHrs.fiscalno
, Sum(indrct.Amount) as 'amount'
, sum(clntHrs.ProductHours) as 'productHours'
, sum(clntHrs.ProductHours / rentHrs.RentHours * indrct.Amount) AS 'Allocation'
, indrct.Type
, sum(rentHrs.RentHours) as 'renthours'           
FROM vtbl_IndirectAll indrct CROSS JOIN
		(SELECT a.* FROM				
(SELECT CustId, Name, code_ID, descr, SUM(TTLHrs) AS ProductHours, fiscalno
			FROM Period_PL
			WHERE (Type = N'Direct')
			AND (code_ID IN ('CPPR','CPSE','MCNO','NBGL','NBNE','NBPR','MCTR','MGL','MLRS','MNE','MPR','MSE','MSWR','MPCR'
					,'MPGL','MPNE','MPPR','MPSE','CCTR','CGL','CLRS','CNER','CPR','CSER','CLPC','CPGL','CPNE') AND SubAccount <> '1000')
			GROUP BY CustId, Name, code_ID, descr, fiscalno
			HAVING (SUM(TTLHrs) <> 0) AND (CustId <> '1PGGEN')
			UNION 
SELECT CustId, Name, code_ID, descr, SUM(TTLHrs) AS ProductHours, fiscalno
			FROM Period_PL
			WHERE (Type = N'Direct')
			AND code_ID NOT IN ('CPPR','CPSE','MCNO','NBGL','NBNE','NBPR','MCTR','MGL','MLRS','MNE','MPR','MSE','MSWR','MPCR'
					,'MPGL','MPNE','MPPR','MPSE','CCTR','CGL','CLRS','CNER','CPR','CSER','CLPC','CPGL','CPNE','CCUS','MLAA','MLLA'
					,'CHOU','CLES','CLVG','CPHL','CCCH','CFLD','MDVR','MSAC','CDVR','MCHI','MDLS','MDLS','MLBD','MOAK','MSAN'
					,'MLCD','MLHD','CMCB','CMIA','CNYK','CORL')
			GROUP BY CustId, Name, code_ID, descr, fiscalno
			HAVING (SUM(TTLHrs) <> 0) AND (CustId <> '1PGGEN'))a) clntHrs CROSS JOIN
		(SELECT SUM(b.RentHours) as RentHours, b.Type FROM		
(SELECT SUM(TTLHrs) AS RentHours, Type, CustId, code_ID
			FROM Period_PL
			WHERE (code_ID IN ('CPPR','CPSE','MCNO','NBGL','NBNE','NBPR','MCTR','MGL','MLRS','MNE','MPR','MSE','MSWR','MPCR'
					,'MPGL','MPNE','MPPR','MPSE','CCTR','CGL','CLRS','CNER','CPR','CSER','CLPC','CPGL','CPNE') AND SubAccount <> '1000')
			GROUP BY Type, CustId, code_ID
UNION
SELECT SUM(TTLHrs) AS RentHours, Type, CustId, code_ID
			FROM Period_PL
			WHERE (NOT (code_ID IN ('CPPR','CPSE','MCNO','NBGL','NBNE','NBPR','MCTR','MGL','MLRS','MNE','MPR','MSE','MSWR','MPCR'
					,'MPGL','MPNE','MPPR','MPSE','CCTR','CGL','CLRS','CNER','CPR','CSER','CLPC','CPGL','CPNE','CCUS','MLAA','MLLA'
					,'CHOU','CLES','CLVG','CPHL','CCCH','CFLD','MDVR','MSAC','CDVR','MCHI','MDLS','MDLS','MLBD','MOAK','MSAN'
					,'MLCD','MLHD','CMCB','CMIA','CNYK','CORL'))) 
			GROUP BY Type, CustId, code_ID)b
			WHERE (NOT (b.code_ID IN ('WMFB', 'WMBL', 'WMBF', 'WKST', 'WFR', 'WEB', 'TOG', 'TIGM', 'SRN', 'SLK', 'SJSP', 'SJS'
					, 'SFO', 'SAN', 'PTNR', 'PTL', 'PPO', 'PLG', 'PHX', 'PGG', 'PBO', 'PAG', 'OOO', 'OCM', 'OAKP', 'OAK', 'NYK'
					, 'NBN', 'MYF', 'MOF', 'MLI', 'MKI', 'MIV', 'MIE', 'MFT', 'MFB', 'MDAM', 'MAN', 'LPD', 'LMB', 'LLA', 'LCD'
					, 'KNA', 'KHA', 'IMS', 'FRT', 'FCB', 'EUN', 'EKN', 'DVR', 'DLS', 'DIG', 'DAR', 'CVP', 'CRST', 'CRP', 'COPR'
					, 'CMV', 'CIZ', 'CIE', 'CIC', 'CHG', 'CGS', 'CCOM', 'BWE', 'BMG', 'BLS', 'BHC', 'BFH', 'BCMA', 'ALL', '3RD'))) 
			AND (b.Type = N'Direct') AND (b.CustId <> '1PGGEN')
			GROUP BY b.Type) rentHrs
WHERE (clntHrs.code_ID NOT IN ('WMFB', 'WMBL', 'WMBF', 'WKST', 'WFR', 'WEB', 'TOG', 'TIGM', 'SRN', 'SLK', 'SJSP', 'SJS'
					, 'SFO', 'SAN', 'PTNR', 'PTL', 'PPO', 'PLG', 'PHX', 'PGG', 'PBO', 'PAG', 'OOO', 'OCM', 'OAKP', 'OAK'
                    , 'NYK', 'NBN', 'MYF', 'MOF', 'MLI', 'MKI', 'MIV', 'MIE', 'MFT', 'MFB', 'MDAM', 'MAN', 'LPD', 'LMB', 'LLA'
                    , 'LCD', 'KNA', 'KHA', 'IMS', 'FRT', 'FCB', 'EUN', 'EKN', 'DVR', 'DLS', 'DIG', 'DAR', 'CVP', 'CRST', 'CRP'
                    , 'COPR', 'CMV', 'CIZ', 'CIE', 'CIC', 'CHG', 'CGS', 'CCOM', 'BWE', 'BMG', 'BLS', 'BHC', 'BFH', 'BCMA', 'ALL'
                    , '3RD')) 
                    AND (clntHrs.CustId <> '1PGGEN') AND (indrct.Group1 = N'Allocate') AND (indrct.Type = 'Rent')
					AND indrct.fiscalperiod LIKE '2011%'
GROUP BY clntHrs.CustId
, clntHrs.Name
, clntHrs.code_ID
, clntHrs.descr
, clntHrs.fiscalno
, indrct.Type
order by fiscalno, code_id