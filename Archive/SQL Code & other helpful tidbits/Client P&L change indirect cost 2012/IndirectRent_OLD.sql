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
			WHERE (Type = N'Direct') and fiscalno like '201101'
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


select * from vtbl_indirectall where fiscalperiod like '2011%' and type = 'Rent' and group1 = 'Allocate'

select  * from vtbl_Period_PL_All where fiscalno like '2011%' and ttlhrs is not null 

select type, custid, code_id, sum(ttlhrs) as 'RentHours', fiscalno, * from vtbl_Period_PL_All where fiscalno like '2011%' and ttlhrs is not null 
group by type, custid, code_id, fiscalno
order by fiscalno





select rpt.code_id, rpt.descr, pg.group2, rpt.custid, rpt.name, rpt.total, rpt.hours, rpt.fiscalno from
[SQL2].EmployeeAllocation.dbo.vtbl_PeriodReportingAll rpt Left JOIN [SQL2].EmployeeAllocation.dbo.vtbl_ProductGrouping pg ON rpt.code_id = pg.ProductID
where rpt.fiscalno like '2011%' and rpt.reportgroup = 'expense' and rpt.reportsort = '27' and rpt.total <> '0'
order by rpt.code_id, rpt.fiscalno

and 


select * from dbo.vw_Period_ClientProd_Hours
('CCUS','MLAA','MLLA','CHOU','CLES','CLVG','CPHL','CCCH','CFLD','MDVR','MSAC','CDVR','MCHI','MDLS','MLBD'
,'MOAK','MSAN','MLCD','MLHD','CMCB','CMIA','CNYK','CORL')