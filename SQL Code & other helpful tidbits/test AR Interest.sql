select * from wk_Aged Where InterestBal >0
	and InterestDays >0 
	
SELECT     CustID, ProdCode, SUM(InterestAmt) AS Interest
FROM         dbo.wk_Aged
GROUP BY CustID, ProdCode
HAVING      (SUM(InterestAmt) <> 0)
	
SELECT     'Direct' AS Type, 'Expense' AS ReportGroup, '32' AS ReportSort, vw_InterestSummary.CustID, vtbl_ProductGrouping.Group1, 
                      vtbl_ProductGrouping.Group2, vw_InterestSummary.ProdCode, vtbl_ProductGrouping.ProdDescr, 'EX' AS acct_typ, 'AR Interest Expense' AS acct, 
                      ROUND(vw_InterestSummary.Interest * - 1, 2) AS Interest, '201201' AS Fiscal, 'Denver' AS Profit, '0' AS Hrs
FROM         vw_InterestSummary LEFT OUTER JOIN vtbl_ProductGrouping ON vw_InterestSummary.ProdCode = vtbl_ProductGrouping.ProductId
