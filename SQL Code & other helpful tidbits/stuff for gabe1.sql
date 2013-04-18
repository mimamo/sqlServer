SELECT     /* Account*/ AAcctType = v.AccountAcctType, AAcctCat = v.AccountAcctCat, AActive = v.AccountActive, AClassID = v.AccountClassID, 
                      AConsolAcct = v.AccountConsolAcct, ADescr = v.AccountDescr, ARatioGrp = v.AccountRatioGrp, AUser1 = v.AccountUser1, AUser2 = v.AccountUser2, 
                      AUser3 = v.AccountUser3, AUser4 = v.AccountUser4, AUser5 = v.AccountUser5, AUser6 = v.AccountUser6, AUser7 = v.AccountUser7, 
                      AUser8 = v.AccountUser8, /* AcctHist Fields*/ AHAcct = v.AcctHistAcct, AHBalanceType = v.AcctHistBalanceType, AHCuryID = v.AcctHistCuryID, 
                      AHCpnyID = v.AcctHistCpnyID, AHFiscyr = v.AcctHistFiscyr, AHLedgerID = v.AcctHistLedgerID, AHSub = v.AcctHistSub, AHUser1 = v.AcctHistUser1, 
                      AHUser2 = v.AcctHistUser2, AHUser3 = v.AcctHistUser3, AHUser4 = v.AcctHistUser4, AHUser5 = v.AcctHistUser5, AHUser6 = v.AcctHistUser6, 
                      AHUser7 = v.AcctHistUser7, AHUser8 = v.AcctHistUser8, /* GLTran Fields*/ GLBaseCuryId = t .BaseCuryId, GLBatnbr = t .Batnbr, GLCrAmt = t .CrAmt, 
                      GLCrtdDateTime = t .Crtd_DateTime, GLCrtdProg = t .Crtd_Prog, GLCrtdUser = t .Crtd_User, GLDrAmt = t .DrAmt, GLEmployeeID = t .EmployeeID, 
                      GLExtRefNbr = t .ExtRefNbr, GLICDistribution = t .IC_Distribution, GLVendID = t .ID, GLJrnlType = t .JrnlType, GLLaborClassCd = t .Labor_Class_CD, 
                      GLLineNbr = t .LineNbr, GLLineRef = t .LineRef, GLLUpdDateTime = t .LUpd_DateTime, GLLUpdProg = t .LUpd_Prog, GLLUpdUser = t .Lupd_User, 
                      GLModule = t .Module, GLOrigAcct = t .OrigAcct, GLOrigBatNbr = t .OrigBatNbr, GLOrigCpnyID = t .OrigCpnyID, GLOrigSub = t .OrigSub, 
                      GLPCFlag = t .PC_Flag, GLPCStatus = t .PC_Status, GLPerEnt = t .PerEnt, GLPosted = t .Posted, GLProjectID = t .ProjectID, GLQty = t .Qty, 
                      GLRefnbr = t .RefNbr, GLTaskID = t .TaskID, GLTranDate = t .TranDate, GLTranDesc = t .TranDesc, GLARCustCode = Substring(t .TranDesc, 1, 6), 
                      GLARCustName = Substring(t .TranDesc, 8, 50), GLTranType = t .TranType, GLUnits = t .Units, GLUser1 = t .User1, GLUser2 = t .User2, 
                      GLUser3 = t .User3, GLUser4 = t .User4, GLUser5 = t .User5, GLUser6 = t .User6, GLUser7 = t .User7, GLUser8 = t .User8, 
                      /*GL Setup  */ GLRetEarnAcct = s.RetEarnAcct, GLYtdNetIncAcct = s.YtdNetIncAcct, GLCOAOrder = s.COAOrder, 
                      /* RPTCompany Fields*/ RptCpnyName = c.CpnyName, RptRI_ID = c.RI_ID, /* SubAcct Fields*/ SAActive = v.SubAcctActive, 
                      SAConSolSub = v.SubAcctConsolSub, SADescr = v.SubAcctDescr, SAUser1 = v.SubAcctUser1, SAUser2 = v.SubAcctUser2, SAUser3 = v.SubAcctUser3, 
                      SAUser4 = v.SubAcctUser4, SAUser5 = v.SubAcctUser5, SAUser6 = v.SubAcctUser6, SAUser7 = v.SubAcctUser7, SAUser8 = v.SubAcctUser8, 
                      /*View Specific Fields*/ ATOrder = v.AcctTypeOrder, 
                      ATDesc = CASE s.COAOrder WHEN 'A' THEN CASE v.AcctTypeOrder WHEN '1' THEN '1 - Assets' WHEN '2' THEN '2 - Liabilities' ELSE '3 - Income & Expense'
                       END WHEN 'B' THEN CASE v.AcctTypeOrder WHEN '1' THEN '1 - Assets' WHEN '2' THEN '2 - Liabilities' WHEN '3' THEN '3 - Income' ELSE '4 - Expense'
                       END WHEN 'C' THEN CASE v.AcctTypeOrder WHEN '1' THEN '1 - Income' WHEN '2' THEN '2 - Expense' WHEN '3' THEN '3 - Assets' ELSE '4 - Liabilities'
                       END WHEN 'D' THEN CASE v.AcctTypeOrder WHEN '1' THEN '1 - Income & Expense' WHEN '2' THEN '2 - Assets' ELSE '3 - Liabilities' END END, 
                      Fiscyr = v.AcctHistFiscyr, Month = v.Mon, StartingBalance = v.StartingBalance, StartingBalance1 = v.StartingBalance1, PeriodActivity = v.PeriodActivity,
                       PeriodPost = v.PeriodPost, EndingBalance = v.EndingBalance, TransFlag = 'G', ISNULL(p.pm_id01, '') AS 'ClientID', ISNULL(p.pm_id02, '') 
                      AS 'ProductID', ISNULL(p.pm_id04, '') AS 'Type', ISNULL(p.pm_id05, '') AS 'SubType', ISNULL(p.pm_id32, '') AS 'OfferNum', ISNULL(xc.CName, '') 
                      AS 'ClientContact', ISNULL(xc.EmailAddress, '') AS 'ContactEmailAddress', ISNULL(p.project_desc, '') AS 'JobDescription'
FROM         vr_01620_AcctHist v INNER JOIN
                      RptCompany c(NOLOCK) ON v.AcctHistCpnyID = c.CpnyID INNER JOIN
                      RptRuntime r(NOLOCK) ON r.RI_ID = c.RI_ID AND v.AcctHistFiscyr BETWEEN LEFT(r.BegPerNbr, 4) AND LEFT(r.EndPerNbr, 4) INNER LOOP JOIN
                      GLTran t WITH (INDEX (GLTRAN6)) ON v.AcctHistAcct = t .Acct AND v.AcctHistSub = t .Sub AND v.AcctHistLedgerID = t .LedgerID AND 
                      v.AcctHistFiscyr = t .Fiscyr AND v.PeriodPost = t .PerPost AND v.AcctHistCpnyID = t .CpnyId CROSS JOIN
                      GLSetUp s(NOLOCK) LEFT JOIN
                      PJPROJ p(NOLOCK) ON t .ProjectID = p.Project LEFT JOIN
                      xClientContact xc ON p.user2 = xc.EA_ID
WHERE     (t .Posted = 'P' AND t .Acct <> s.YtdNetIncAcct)
/* ******************************************************************************************************************/ UNION ALL
SELECT     /* Account*/ AAcctType = v.AccountAcctType, AAcctCat = v.AccountAcctCat, AActive = v.AccountActive, AClassID = v.AccountClassID, 
                      AConsolAcct = v.AccountConsolAcct, ADescr = v.AccountDescr, ARatioGrp = v.AccountRatioGrp, AUser1 = v.AccountUser1, AUser2 = v.AccountUser2, 
                      AUser3 = v.AccountUser3, AUser4 = v.AccountUser4, AUser5 = v.AccountUser5, AUser6 = v.AccountUser6, AUser7 = v.AccountUser7, 
                      AUser8 = v.AccountUser8, /* AcctHist Fields*/ AHAcct = v.AcctHistAcct, AHBalanceType = v.AcctHistBalanceType, AHCuryID = v.AcctHistCuryID, 
                      AHCpnyID = v.AcctHistCpnyID, AHFiscyr = v.AcctHistFiscyr, AHLedgerID = v.AcctHistLedgerID, AHSub = v.AcctHistSub, AHUser1 = v.AcctHistUser1, 
                      AHUser2 = v.AcctHistUser2, AHUser3 = v.AcctHistUser3, AHUser4 = v.AcctHistUser4, AHUser5 = v.AcctHistUser5, AHUser6 = v.AcctHistUser6, 
                      AHUser7 = v.AcctHistUser7, AHUser8 = v.AcctHistUser8, /* GLTran Fields*/ GLBaseCuryId = s.BaseCuryID, GLBatnbr = '', 
                      GLCrAmt = CASE WHEN (SUBSTRING(v.AccountAcctType, 2, 1) = 'A' AND v.PeriodActivity < 0.00) THEN (v.PeriodActivity * - 1) 
                      WHEN (SUBSTRING(v.AccountAcctType, 2, 1) = 'L' AND v.PeriodActivity >= 0.00) THEN (v.PeriodActivity) WHEN (SUBSTRING(v.AccountAcctType, 2, 1) 
                      = 'I' AND v.PeriodActivity >= 0.00) THEN (v.PeriodActivity) WHEN (SUBSTRING(v.AccountAcctType, 2, 1) = 'E' AND v.PeriodActivity < 0.00) 
                      THEN (v.PeriodActivity * - 1) ELSE 0.00 END, GLCrtdDateTime = '', GLCrtdProg = '', GLCrtdUser = '', 
                      GLDrAmt = CASE WHEN (SUBSTRING(v.AccountAcctType, 2, 1) = 'A' AND v.PeriodActivity >= 0.00) THEN (v.PeriodActivity) 
                      WHEN (SUBSTRING(v.AccountAcctType, 2, 1) = 'L' AND v.PeriodActivity < 0.00) THEN (v.PeriodActivity * - 1) WHEN (SUBSTRING(v.AccountAcctType, 2, 
                      1) = 'I' AND v.PeriodActivity < 0.00) THEN (v.PeriodActivity * - 1) WHEN (SUBSTRING(v.AccountAcctType, 2, 1) = 'E' AND v.PeriodActivity >= 0.00) 
                      THEN (v.PeriodActivity) ELSE 0.00 END, GLEmployeeID = '', GLExtRefNbr = '', GLICDistribution = '', GLVendID = t .ID, GLJrnlType = '', 
                      GLLaborClassCd = '', GLLineNbr = '', GLLineRef = '', GLLUpdDateTime = '', GLLUpdProg = '', GLLUpdUser = '', GLModule = '', GLOrigAcct = '', 
                      GLOrigBatNbr = '', GLOrigCpnyID = '', GLOrigSub = '', GLPCFlag = '', GLPCStatus = '', GLPerEnt = v.PeriodPost, GLPosted = '', GLProjectID = '', 
                      GLQty = '', GLRefnbr = '', GLTaskID = '', GLTranDate = '1900-01-01', GLTranDesc = '', GLARCustCode = '', GLARCustName = '', GLTranType = '', 
                      GLUnits = '', GLUser1 = '', GLUser2 = '', GLUser3 = '', GLUser4 = '', GLUser5 = '', GLUser6 = '', GLUser7 = '', GLUser8 = '', 
                      /*GL Setup  */ GLRetEarnAcct = s.RetEarnAcct, GLYtdNetIncAcct = s.YtdNetIncAcct, GLCOAOrder = s.COAOrder, 
                      /* RPTCompany Fields*/ RptCpnyName = c.CpnyName, RptRI_ID = c.RI_ID, /* SubAcct Fields*/ SAActive = v.SubAcctActive, 
                      SAConSolSub = v.SubAcctConsolSub, SADescr = v.SubAcctDescr, SAUser1 = v.SubAcctUser1, SAUser2 = v.SubAcctUser2, SAUser3 = v.SubAcctUser3, 
                      SAUser4 = v.SubAcctUser4, SAUser5 = v.SubAcctUser5, SAUser6 = v.SubAcctUser6, SAUser7 = v.SubAcctUser7, SAUser8 = v.SubAcctUser8, 
                      /*View Specific Fields*/ ATOrder = v.AcctTypeOrder, 
                      ATDesc = CASE s.COAOrder WHEN 'A' THEN CASE v.AcctTypeOrder WHEN '1' THEN '1 - Assets' WHEN '2' THEN '2 - Liabilities' ELSE '3 - Income & Expense'
                       END WHEN 'B' THEN CASE v.AcctTypeOrder WHEN '1' THEN '1 - Assets' WHEN '2' THEN '2 - Liabilities' WHEN '3' THEN '3 - Income' ELSE '4 - Expense'
                       END WHEN 'C' THEN CASE v.AcctTypeOrder WHEN '1' THEN '1 - Income' WHEN '2' THEN '2 - Expense' WHEN '3' THEN '3 - Assets' ELSE '4 - Liabilities'
                       END WHEN 'D' THEN CASE v.AcctTypeOrder WHEN '1' THEN '1 - Income & Expense' WHEN '2' THEN '2 - Assets' ELSE '3 - Liabilities' END END, 
                      Fiscyr = v.AcctHistFiscyr, Month = v.Mon, StartingBalance = v.StartingBalance, StartingBalance1 = v.StartingBalance1, PeriodActivity = v.PeriodActivity,
                       PeriodPost = v.PeriodPost, EndingBalance = v.EndingBalance, TransFlag = 'A', ISNULL(p.pm_id01, '') AS 'ClientID', ISNULL(p.pm_id02, '') 
                      AS 'ProductID', ISNULL(p.pm_id04, '') AS 'Type', ISNULL(p.pm_id05, '') AS 'SubType', ISNULL(p.pm_id32, '') AS 'OfferNum', ISNULL(xc.CName, '') 
                      AS 'ClientContact', ISNULL(xc.EmailAddress, '') AS 'ContactEmailAddress', ISNULL(p.project_desc, '') AS 'JobDescription'
FROM         vr_01620_AcctHist v CROSS JOIN
                      GLSetUp s(NOLOCK) INNER JOIN
                      RPTCompany c(NOLOCK) ON v.AcctHistCpnyID = c.CpnyID INNER JOIN
                      RptRuntime r(NOLOCK) ON r.RI_ID = c.RI_ID AND v.AcctHistFiscyr BETWEEN LEFT(r.BegPerNbr, 4) AND LEFT(r.EndPerNbr, 4) LEFT OUTER LOOP JOIN
                      GLTran t WITH (INDEX (GLTRAN6)) ON v.AcctHistAcct = t .Acct AND v.AcctHistSub = t .Sub AND v.AcctHistLedgerID = t .LedgerID AND 
                      v.AcctHistFiscyr = t .Fiscyr AND v.PeriodPost = t .PerPost AND v.AcctHistCpnyID = t .CpnyId AND t .Posted = 'P' AND 
                      v.AcctHistAcct <> s.YtdNetIncAcct LEFT JOIN
                      PJPROJ p(NOLOCK) ON t .ProjectID = p.Project LEFT JOIN
                      xClientContact xc ON p.user2 = xc.EA_ID
WHERE     ((v.AcctHistAcct = s.YtdNetIncAcct) OR
                      /* Include YTD Net Income Accounts*/ t .Acct IS NULL)