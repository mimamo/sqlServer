
-- Client P&L indirect Rent Allocation
INSERT INTO [SQL2].EmployeeAllocation.dbo.PeriodReporting
				(Type, ReportGroup, CustId, Name, code_ID, descr, acct_type, acct, Total, fiscalno, ProfitCenter)
SELECT     'Direct' AS Expr1, 'Indirect' AS Expr2, CustId, Name, code_ID, descr, 'EX' AS Expr3, 'Indirect Rent Expense' AS Expr4, SUM(Allocation)*-1 AS TTLRent, 
                      '201112' AS Expr5, 'Denver' as ProfitCenter
FROM         [SQL2].EmployeeAllocation.dbo.vw_RentAllocation
GROUP BY  Type, CustId, code_ID, descr, Name
HAVING      (Type = 'Rent')
	And Code_id not in ('WMFB', 'WMBL', 'WMBF', 'WKST', 'WFR', 'WEB', 'TOG', 'TIGM', 'SRN', 'SLK', 'SJSP', 'SJS', 'SFO', 'SAN', 'PTNR', 'PTL', 'PPO', 'PLG', 'PHX', 'PGG', 'PBO', 'PAG', 'OOO', 'OCM', 'OAKP', 'OAK', 'NYK', 'NBN', 'MYF', 'MOF', 'MLI', 'MKI', 'MIV', 'MIE', 'MFT', 'MFB', 'MDAM', 'MAN', 'LPD', 'LMB', 'LLA', 'LCD', 'KNA', 'KHA', 'IMS', 'FRT', 'FCB', 'EUN', 'EKN', 'DVR', 'DLS', 'DIG', 'DAR', 'CVP', 'CRST', 'CRP', 'COPR', 'CMV', 'CIZ', 'CIE', 'CIC', 'CHG', 'CGS', 'CCOM', 'BWE', 'BMG', 'BLS', 'BHC', 'BFH', 'BCMA', 'ALL', '3RD')
	
