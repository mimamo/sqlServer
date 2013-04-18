--Allocation view 
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
	



SELECT     dbo.vw_Period_ClientProd_Hours.CustId, dbo.vw_Period_ClientProd_Hours.Name, dbo.vw_Period_ClientProd_Hours.code_ID, 
                      dbo.vw_Period_ClientProd_Hours.descr, dbo.vw_Period_ClientProd_Hours.fiscalno, dbo.IndirectAllocation.Amount, 
                      dbo.vw_Period_ClientProd_Hours.ProductHours, dbo.vw_RentHours_Allocate.RentHours, dbo.IndirectAllocation.Amount,
                      dbo.vw_Period_ClientProd_Hours.ProductHours / dbo.vw_RentHours_Allocate.RentHours * dbo.IndirectAllocation.Amount AS Allocation, 
                      dbo.IndirectAllocation.Type, dbo.vw_RentHours_Allocate.RentHours
FROM         dbo.IndirectAllocation CROSS JOIN
                      dbo.vw_Period_ClientProd_Hours CROSS JOIN
                      dbo.vw_RentHours_Allocate
WHERE    (dbo.vw_Period_ClientProd_Hours.CustId <> '1PGGEN') AND (dbo.IndirectAllocation.Group1 = N'Allocate') 

and dbo.vw_Period_ClientProd_Hours.code_ID in ('C360','CCCH','CCUS','CDVR','CFLD','CHOU','CLES','CLVG','CMCB','CMES','CMIA','CNYK','COES','CORL','CPHL','MBES')


select rpt.code_id, rpt.descr, pg.group2, rpt.custid, rpt.name, rpt.total, rpt.hours from
[SQL2].EmployeeAllocation.dbo.vtbl_PeriodReportingAll rpt Left JOIN [SQL2].EmployeeAllocation.dbo.vtbl_ProductGrouping pg ON rpt.code_id = pg.ProductID
where rpt.fiscalno = '201109' and rpt.reportgroup = 'expense' and rpt.reportsort = '27' and pg.group2 like '%field%'


select rpt.code_id, rpt.descr, pg.group2, rpt.custid, rpt.name, rpt.total, rpt.hours, rpt.fiscalno from
[SQL2].EmployeeAllocation.dbo.vtbl_PeriodReportingAll rpt Left JOIN [SQL2].EmployeeAllocation.dbo.vtbl_ProductGrouping pg ON rpt.code_id = pg.ProductID
where rpt.fiscalno like '2011%' and rpt.reportgroup = 'expense' and rpt.reportsort = '27' and rpt.total <> '0'
order by rpt.code_id, rpt.fiscalno

and 


select * from dbo.vw_Period_ClientProd_Hours
('CCUS','MLAA','MLLA','CHOU','CLES','CLVG','CPHL','CCCH','CFLD','MDVR','MSAC','CDVR','MCHI','MDLS','MLBD'
,'MOAK','MSAN','MLCD','MLHD','CMCB','CMIA','CNYK','CORL')

select * from vtbl_indirectall where fiscalperiod like '2011%' and type = 'Rent' and group1 = 'Allocate'

select  * from vtbl_Period_PL_All where fiscalno like '2011%' and ttlhrs is not null 

select type, custid, code_id, sum(ttlhrs) as 'RentHours', fiscalno, * from vtbl_Period_PL_All where fiscalno like '2011%' and ttlhrs is not null 
group by type, custid, code_id, fiscalno
order by fiscalno


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
		(SELECT CustId, Name, code_ID, descr, SUM(TTLHrs) AS ProductHours, fiscalno
			FROM vtbl_Period_PL_All
			WHERE (Type = N'Direct') and fiscalno like '2011%'
			GROUP BY CustId, Name, code_ID, descr, fiscalno
			HAVING (SUM(TTLHrs) <> 0) AND (CustId <> '1PGGEN')) clntHrs CROSS JOIN
		(SELECT SUM(TTLHrs) AS RentHours, Type
			FROM vtbl_Period_PL_All
			WHERE (NOT (code_ID IN ('WMFB', 'WMBL', 'WMBF', 'WKST', 'WFR', 'WEB', 'TOG', 'TIGM', 'SRN', 'SLK', 'SJSP', 'SJS'
					, 'SFO', 'SAN', 'PTNR', 'PTL', 'PPO', 'PLG', 'PHX', 'PGG', 'PBO', 'PAG', 'OOO', 'OCM', 'OAKP', 'OAK', 'NYK'
					, 'NBN', 'MYF', 'MOF', 'MLI', 'MKI', 'MIV', 'MIE', 'MFT', 'MFB', 'MDAM', 'MAN', 'LPD', 'LMB', 'LLA', 'LCD'
					, 'KNA', 'KHA', 'IMS', 'FRT', 'FCB', 'EUN', 'EKN', 'DVR', 'DLS', 'DIG', 'DAR', 'CVP', 'CRST', 'CRP', 'COPR'
					, 'CMV', 'CIZ', 'CIE', 'CIC', 'CHG', 'CGS', 'CCOM', 'BWE', 'BMG', 'BLS', 'BHC', 'BFH', 'BCMA', 'ALL', '3RD'))) 
			AND (Type = N'Direct') AND (CustId <> '1PGGEN')
			GROUP BY Type) rentHrs
WHERE (clntHrs.code_ID NOT IN ('WMFB', 'WMBL', 'WMBF', 'WKST', 'WFR', 'WEB', 'TOG', 'TIGM', 'SRN', 'SLK', 'SJSP', 'SJS'
					, 'SFO', 'SAN', 'PTNR', 'PTL', 'PPO', 'PLG', 'PHX', 'PGG', 'PBO', 'PAG', 'OOO', 'OCM', 'OAKP', 'OAK'
                    , 'NYK', 'NBN', 'MYF', 'MOF', 'MLI', 'MKI', 'MIV', 'MIE', 'MFT', 'MFB', 'MDAM', 'MAN', 'LPD', 'LMB', 'LLA'
                    , 'LCD', 'KNA', 'KHA', 'IMS', 'FRT', 'FCB', 'EUN', 'EKN', 'DVR', 'DLS', 'DIG', 'DAR', 'CVP', 'CRST', 'CRP'
                    , 'COPR', 'CMV', 'CIZ', 'CIE', 'CIC', 'CHG', 'CGS', 'CCOM', 'BWE', 'BMG', 'BLS', 'BHC', 'BFH', 'BCMA', 'ALL'
                    , '3RD')) 
                    AND (clntHrs.CustId <> '1PGGEN') AND (indrct.Group1 = N'Allocate') AND indrct.Type = 'Rent'
GROUP BY clntHrs.CustId
, clntHrs.Name
, clntHrs.code_ID
, clntHrs.descr
, clntHrs.fiscalno
, indrct.Type
order by fiscalno, code_id


code_id in ('C360','CCCH','CCUS','CDVR','CFLD','CHOU','CLES','CLVG','CMCB','CMES','CMIA','CNYK','COES','CORL','CPHL','MBES')

                     
    