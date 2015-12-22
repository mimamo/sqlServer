USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[xJAProcessReport_IWT]    Script Date: 03/06/2012 09:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[xJAProcessReport_IWT] 
   @GUID                  varchar(255)
  ,@AgingDate             smalldatetime
  ,@ActiveChildrenOnly    smallint
  ,@SupressDfltDtl        smallint
 -- , @TemplateID smallint --added 03/17/2011 MSB
  
AS

BEGIN
  SET NOCOUNT ON

/******************************************************************************************************
*** SETUP TABLES ***
*******************************************************************************************************/

  EXEC xJADeleteWrkTables_IWT @GUID

/******************************************************************************************************
*** HEADER RECORD PROCESSING ***
*******************************************************************************************************/

  -- Update the #ListOfProjects with all the project "Bill With" projects
  CREATE TABLE #ListOfProjectsWrk (Project char(16))
  
  -- Determine all the Bill Withs for the selected projects
  INSERT INTO #ListOfProjectsWrk (
    Project)
  SELECT
    B.project  
  FROM 
    #ListOfProjects L INNER JOIN PJBILL A ON L.Project = A.Project
                      INNER JOIN PJBILL B ON A.project_billwith = B.project_billwith 
  WHERE
    A.project_billwith <> ''             -- Note: This addresses an issue with bad billwith records in PJBill 12/3/2010 LGB
    

  -- Clear out the list of project tables
  DELETE FROM #ListOfProjects
  
  -- Insert the complete list
  INSERT INTO #ListOfProjects (
    Project)
  SELECT DISTINCT 
    Project
  FROM
    #ListOfProjectsWrk
  
  -- Insert the Header records
  INSERT INTO xJAReportHeaderWrk_IWT (
     SessionGUID
    ,Project)
  SELECT
     @GUID
    ,Project
  FROM
    #ListOfProjects
       
  -- Update the Header Information
  UPDATE 
    xJAReportHeaderWrk_IWT
  SET 
     Project_desc = P.Project_desc
    ,AgingDate = @AgingDate
    ,ASName = REPLACE(E2.Emp_name, '~',', ')
    ,ClientName = ISNULL(XC.CName, 'NO CLIENT CONTACT')
    ,ClientEMail = ISNULL(XC.EmailAddress, 'NO EMAIL')
    ,CpnyID = P.CpnyID
    ,CustID = C.CustID
    ,CustomerName = C.Name
    ,End_Date = CASE WHEN P.End_Date = '1/1/1900' THEN NULL ELSE P.End_Date END
    ,HasChildren = 0
    ,Inv_format_cd = B.Inv_format_cd
    ,Pm_id01 = P.Pm_id01
    ,Pm_id02 = P.Pm_id02
    ,Pm_id08 = CASE WHEN P.Pm_id08 = '1/1/1900' THEN NULL ELSE P.Pm_id08 END 
    ,Pm_id28 = CASE WHEN PE.Pm_id28 = '1/1/1900' THEN NULL ELSE PE.Pm_id28 END  
    ,Pm_id32 = P.Pm_id32
    ,PMName = REPLACE(E1.Emp_name, '~',', ')
    ,Project_BillWith = B.Project_BillWith
    ,ProdCode = X.descr
    ,Purchase_order_num = P.Purchase_order_num
    ,Start_Date = CASE WHEN P.Start_Date = '1/1/1900' THEN NULL ELSE P.Start_Date END 
    ,Status_pa = P.Status_pa
   -- , TemplateID = @TemplateID --added 03/17/2011 MSB
  FROM
    xJAReportHeaderWrk_IWT H INNER JOIN PJProj P ON H.Project = P.Project
                             INNER JOIN PJProjEX PE ON H.Project = PE.Project
                             INNER JOIN Customer C ON P.pm_id01 = C.CustID
                             INNER JOIN PJBILL B ON H.Project = B.Project
                             LEFT OUTER JOIN xIGProdCode X ON P.pm_id02 = X.Code_ID
                             LEFT OUTER JOIN xClientContact XC ON P.User2 = XC.EA_ID
                             LEFT OUTER JOIN PJEmploy E1 ON P.manager1 = E1.employee
                             LEFT OUTER JOIN PJEmploy E2 ON P.manager2 = E2.employee
  WHERE
    SessionGUID = @GUID
    
  -- Get a temp table with a list of the parent projects 
  -- Note: You must do this as a temp table because you cannot perform an aggregate function on an expression containing an aggregate or a subquery
  SELECT
     B.Project_BillWith as Project
  INTO
    #ListOfParentsWithChildren
  FROM
    PJBILL B INNER JOIN xJAReportHeaderWrk_IWT P ON B.Project_BillWith = P.Project 
                                                AND P.SessionGUID = @GUID 
                                                AND P.Project = P.Project_BillWith  
  GROUP BY 
    B.Project_BillWith
  HAVING
    COUNT(B.Project_BillWith) > 1
   
  UPDATE
    xJAReportHeaderWrk_IWT
  SET
    HasChildren = 1
  FROM
    xJAReportHeaderWrk_IWT INNER JOIN #ListOfParentsWithChildren L ON xJAReportHeaderWrk_IWT.Project = L.Project
  WHERE
    xJAReportHeaderWrk_IWT.SessionGUID = @GUID
     

/******************************************************************************************************
*** DETAIL RECORD PROCESSING ***
*******************************************************************************************************/

  INSERT INTO xJAReportDetailWrk_IWT (
     SessionGUID
    ,Acct_group_cd
    ,Amount
    ,BilledAmount
    ,Employee
    ,Emp_name
    ,Ih_id12
    ,Inv_format_cd
    ,Invoice_num
    ,Invoice_type
    ,MarkupAmount
    ,Project
    ,Pjt_entity
    ,Pjt_entity_desc
    ,Trans_date
    ,TranType
    ,Tr_comment
    ,Tr_id02
    ,Tr_id03
    ,Tr_id04
    ,Tr_id08
    ,Units
    ,Vendor_num
    ,Vendor_name
    , POLineItem) --added 1/28/2011 MSB
  SELECT
     @GUID
    ,A.Acct_group_cd                      -- Account Group 
    ,CASE WHEN ISNULL(I.Invoice_type, '') <> '' AND ISNULL(I.Ih_id12, '') <> '' THEN -T.amount ELSE T.amount END
    ,ISNULL(I.amount, 0)                  -- Billed Amount 
    ,T.Employee                           -- Employee ID 
    ,REPLACE(E.Emp_name, '~',', ')        -- Employee Name 
    ,I.Ih_id12                            -- Original Invoice Number
    ,I.Inv_format_cd                      -- Invoice Format Code
    ,I.Invoice_num                        -- Client Invoice Number
    ,I.Invoice_type                       -- Invoice Type 
    ,0                                    -- Markup Amount
    ,L.Project
    ,P.Pjt_entity
    ,P.Pjt_entity_desc
    ,T.Trans_date
    ,''                                   -- TranType 
    ,T.Tr_comment                         -- Description
    ,T.Tr_id02                            -- InvoiceNbr
    ,T.Tr_id04                            -- Batch Number
    ,T.Tr_id03                            -- PONbr
    ,T.Tr_id08                            -- Invoice Date 
    ,CASE A.Acct_group_cd WHEN 'LB' THEN T.Units ELSE 0 END   -- Units
    ,T.Vendor_num                         -- Vendor ID
    ,REPLACE(V.Name, '~',', ')            -- Vendor Name 
    , ISNULL(P.user1, '') AS 'POLineItem' -- POLineItem --added 01/28/2011 MSB updated 02/18/2011 MSB
  FROM
    #ListOfProjects L INNER JOIN PJTran T ON L.Project = T.Project 
                      INNER JOIN PJPent P ON T.Pjt_entity = P.Pjt_entity AND
                                             T.Project = P.Project 
                      INNER JOIN PJAcct A ON T.Acct = A.Acct                       
                      LEFT OUTER JOIN PJEmploy E ON T.Employee = E.Employee
                      LEFT OUTER JOIN Vendor V ON T.Vendor_num = V.VendID
                      LEFT OUTER JOIN (
                        -- Associated Invoice Information as Derived Table
                        SELECT 
                           P.Project
                          ,T.user2 AS 'tr_id12'
                          ,MAX(H.invoice_num) as 'invoice_num'
                          ,MIN(H.ih_id12) as 'ih_id12'
                          ,MIN(H.invoice_date) as 'invoice_date'
                          ,SUM(D.amount) as 'amount'
                          ,MAX(H.inv_format_cd) as 'inv_format_cd'
                          ,MAX(H.invoice_type) as 'invoice_type'
                        FROM
                          #ListOfProjects P INNER JOIN PJTran T ON P.Project = T.project
                                            INNER JOIN PJInvDet D ON T.tr_id23 = D.in_id12 
                                            INNER JOIN PJInvHdr H ON D.draft_num = H.draft_num 
                        WHERE
                              T.user2 <> '' 
                          AND D.bill_status = 'B'                     
                        GROUP BY
                           P.Project 
                          ,T.user2 ) AS I ON I.tr_id12 = T.user2  
  WHERE  
        T.Trans_date <= @AgingDate  
    AND A.acct_group_cd IN ('FE', 'WA', 'LB', 'PB')  
    
  -- 'WP' and related 'CM' amounts
  INSERT INTO xJAReportDetailWrk_IWT (
     SessionGUID
    ,Acct_group_cd
    ,Amount
    ,BilledAmount
    ,Employee
    ,Emp_name
    ,Ih_id12
    ,Inv_format_cd
    ,Invoice_num
    ,Invoice_type
    ,MarkupAmount
    ,Project
    ,Pjt_entity
    ,Pjt_entity_desc
    ,Trans_date
    ,TranType
    ,Tr_comment
    ,Tr_id02
    ,Tr_id03
    ,Tr_id04
    ,Tr_id08
    ,Units
    ,Vendor_num
    ,Vendor_name
    , POLineItem) --added 01/28/2011 MSB
  SELECT
     @GUID
    ,'WP'                                 -- Account Group 
    ,SUM(CASE WHEN A.Acct_group_cd = 'CM' THEN 0 ELSE CASE WHEN ISNULL(I.Invoice_type, '') <> '' AND ISNULL(I.Ih_id12, '') <> '' THEN 0 ELSE T.amount END END)
    ,SUM(CASE WHEN A.Acct_group_cd = 'CM' THEN 0 ELSE CASE WHEN ISNULL(I.invoice_type, '') = 'REVD' THEN 0 ELSE ISNULL(I.amount, 0) END END)                  -- Billed Amount 
    ,T.Employee                           -- Employee ID 
    ,REPLACE(E.Emp_name, '~',', ')        -- Employee Name 
    ,I.Ih_id12                            -- Original Invoice Number
    ,I.Inv_format_cd                      -- Invoice Format Code
    ,I.Invoice_num                        -- Client Invoice Number
    ,I.Invoice_type                       -- Invoice Type 
    ,SUM(CASE WHEN A.acct_group_cd = 'CM' THEN T.amount ELSE 0 END)    -- Markup Amount
    ,L.Project
    ,P.Pjt_entity
    ,P.Pjt_entity_desc
    ,T.Trans_date
    ,''                                   -- TranType 
    ,T.Tr_comment                         -- Description
    ,T.Tr_id02                            -- InvoiceNbr
    ,T.Tr_id03                            -- PONbr
    ,T.Tr_id04                            -- Batch Number
    ,T.Tr_id08                            -- Invoice Date 
    ,SUM(T.Units)                         -- Units
    ,T.Vendor_num                         -- Vendor ID
    ,REPLACE(V.Name, '~',', ')            -- Vendor Name 
    , ISNULL(P.user1, '') AS 'POLineItem' -- POLineItem --added 01/28/2011 MSB updated 02/18/2011 MSB
  FROM
    #ListOfProjects L INNER JOIN PJTran T ON L.Project = T.Project 
                      INNER JOIN PJPent P ON T.Pjt_entity = P.Pjt_entity AND
                                             T.Project = P.Project 
                      INNER JOIN PJAcct A ON T.Acct = A.Acct                       
                      LEFT OUTER JOIN PJEmploy E ON T.Employee = E.Employee
                      LEFT OUTER JOIN Vendor V ON T.Vendor_num = V.VendID
                      LEFT OUTER JOIN (
                        -- Associated Invoice Information as Derived Table
                        SELECT 
                           P.Project
                          ,T.user2 AS 'tr_id12'
                          ,MAX(H.invoice_num) as 'invoice_num'
                          ,MIN(H.ih_id12) as 'ih_id12'
                          ,MIN(H.invoice_date) as 'invoice_date'
                          ,SUM(D.amount) as 'amount'
                          ,MAX(H.inv_format_cd) as 'inv_format_cd'
                          ,MAX(H.invoice_type) as 'invoice_type'
                        FROM
                          #ListOfProjects P INNER JOIN PJTran T ON P.Project = T.project
                                            INNER JOIN PJInvDet D ON T.tr_id23 = D.in_id12 
                                            INNER JOIN PJInvHdr H ON D.draft_num = H.draft_num 
                        WHERE
                              T.user2 <> '' 
                          AND D.bill_status = 'B'                     
                        GROUP BY
                           P.Project 
                          ,T.user2 ) AS I ON I.tr_id12 = T.user2  
  WHERE  
        T.Trans_date <= @AgingDate  
    AND A.acct_group_cd IN ('WP', 'CM')
  GROUP BY
     T.Employee                           -- Employee ID 
    ,REPLACE(E.Emp_name, '~',', ')        -- Employee Name 
    ,I.Ih_id12                            -- Original Invoice Number
    ,I.Inv_format_cd                      -- Invoice Format Code
    ,I.Invoice_num                        -- Client Invoice Number
    ,I.Invoice_type                       -- Invoice Type 
    ,L.Project
    ,P.Pjt_entity
    ,P.Pjt_entity_desc
    ,T.Trans_date
    ,T.Tr_comment                         -- Description
    ,T.Tr_id02                            -- InvoiceNbr
    ,T.Tr_id03                            -- PONbr
    ,T.Tr_id04                            -- Batch Number
    ,T.Tr_id08                            -- Invoice Date 
    ,T.User2                              -- User2
    ,T.Vendor_num                         -- Vendor ID
    ,T.Voucher_Num                        -- Voucher Number
    ,T.Voucher_Line                       -- Voucher Line
    ,REPLACE(V.Name, '~',', ')            -- Vendor Name 
	, P.user1						  -- POLineItem --added 01/28/2011 MSB
  -- 'PO' amounts
  INSERT INTO xJAReportDetailWrk_IWT (
     SessionGUID
    ,Acct_group_cd
    ,Amount
    ,BilledAmount
    ,Employee
    ,Emp_name
    ,Ih_id12
    ,Inv_format_cd
    ,Invoice_num
    ,Invoice_type
    ,MarkupAmount
    ,Project
    ,Pjt_entity
    ,Pjt_entity_desc
    ,Trans_date
    ,TranType
    ,Tr_comment
    ,Tr_id02
    ,Tr_id03
    ,Tr_id04
    ,Tr_id08
    ,Units
    ,Vendor_num
    ,Vendor_name
    , POLineItem) --added 01/28/2011 MSB
  SELECT     
     @GUID
    ,A.acct_group_cd 
    ,C.Amount
    ,0
    ,''
    ,''
    ,''
    ,''
    ,''
    ,''
    ,0
    ,C.Project
    ,C.Pjt_entity
    ,P.Pjt_entity_desc
    ,C.PO_Date
    ,'PO'
    ,C.Tr_comment
    ,''
    ,C.Purchase_order_num 
    ,''
    ,''
    ,0
    ,C.Vendor_num
    ,REPLACE(V.Name, '~',', ')
    , ISNULL(P.user1, '') AS 'POLineItem' -- POLineItem --added 01/28/2011 MSB updated 02/18/2011 MSB
  FROM 
    #ListOfProjects L INNER JOIN PJComDet C ON L.Project = C.Project 
                      INNER JOIN PJAcct A ON C.Acct = A.Acct
                      INNER JOIN PJPent P ON C.Pjt_entity = P.Pjt_entity AND
                                             C.Project = P.Project 
                      LEFT OUTER JOIN Vendor V ON C.Vendor_num = V.VendID                      
  WHERE
    C.PO_Date <= @AgingDate  
                      
  -- Enter the tasks for these projects that didn't have activity
  INSERT INTO xJAReportDetailWrk_IWT (                 
     SessionGUID
    ,Acct_group_cd
    ,Project
    ,Pjt_entity
    ,Pjt_entity_desc
    , POLineItem) --added 02/18/2011 MSB
  SELECT
     @GUID
    ,'WP'
    ,P.Project
    ,P.Pjt_entity
    ,P.Pjt_entity_desc
    , ISNULL(p.user1, '') as 'POLineItem' --added 02/18/2011 MSB
  FROM
    #ListOfProjects L INNER JOIN PJPent P ON L.Project = P.Project 
                      LEFT OUTER JOIN xJAReportDetailWrk_IWT X ON X.Project = P.Project
                                                              AND X.Pjt_entity = P.Pjt_entity
                                                              AND X.SessionGUID = @GUID
  WHERE
    X.Pjt_entity IS NULL    
  
  -- Delete the accrual tasks - we do this here BEFORE totals are calculated...  Jill does not want these
  -- anywhere on the report
  DELETE FROM
    xJAReportDetailWrk_IWT
  WHERE
    Pjt_entity = '99999'
                      
/******************************************************************************************************
*** BILLING HISTORY RECORD PROCESSING ***
*******************************************************************************************************/

  -- Insert Bill History - AR
  INSERT INTO xJAReportBillHistWrk_IWT (
     SessionGUID
    ,Project
    ,Amount
    ,DocDate
    ,DocType
    ,InvoiceNbr
    ,Payment
    ,Source)
  SELECT     
     @GUID
    ,A.ProjectID
    ,CASE WHEN A.DocType IN ('IN','DM','FI','SC','CS') THEN A.OrigDocAmt ELSE -A.OrigDocAmt END
    ,A.DocDate
    ,A.DocType 
    ,A.RefNbr
    ,CASE WHEN A.DocType = 'CS' THEN A.OrigDocAmt ELSE 0 END
    ,'ARDoc'
  FROM         
    #ListOfProjects L INNER JOIN ARDoc A ON L.Project = A.ProjectID 
  WHERE     
        A.DocDate <= @AgingDate
    AND A.DocType IN ('IN', 'DM', 'CM', 'FI', 'SB', 'SC', 'CS') 

  -- Insert Bill History - PJ
  INSERT INTO xJAReportBillHistWrk_IWT (
     SessionGUID
    ,Project
    ,Amount
    ,CheckNumber
    ,DocDate
    ,DocType
    ,InvoiceNbr
    ,Payment
    ,Source)
  SELECT
     @GUID
    ,L.Project
    ,0
    ,D.AdjgRefNbr
    ,D.AdjgDocDate
    ,D.AdjgDocType
    ,P.Invoice_refnbr
    ,D.CuryAdjgAmt
    ,'PJARPay'
  FROM     
    #ListOfProjects L INNER JOIN ARDoc A ON L.Project = A.ProjectID   
                      INNER JOIN PJARPay P ON P.custid = A.custid 
                                          AND P.invoice_type = A.doctype 
                                          AND P.invoice_refnbr = A.refnbr 
                      INNER JOIN ARADJUST D ON P.custid = D.custid 
                                           AND P.invoice_type = D.AdjdDocType 
                                           AND P.invoice_refnbr = D.AdjdRefNbr
  WHERE      
        D.AdjgDocDate <= @AgingDate 
    AND P.DocType = 'PA'
                       
/******************************************************************************************************
*** BILLING SUMMARY RECORD PROCESSING ***
*******************************************************************************************************/

  -- Payment info into a Temp Table 
  -- Note: You must do this as a temp table because you cannot perform an aggregate function on an expression containing an aggregate or a subquery
  SELECT
     L.Project
    ,SUM(D.CuryAdjgAmt) AS Payments 
  INTO 
    #PJPaymentInfo
  FROM     
    #ListOfProjects L INNER JOIN ARDoc A ON L.Project = A.ProjectID   
                      INNER JOIN PJARPay P ON P.custid = A.custid 
                                          AND P.invoice_type = A.doctype 
                                          AND P.invoice_refnbr = A.refnbr 
                      INNER JOIN ARADJUST D ON P.custid = D.custid 
                                           AND P.invoice_type = D.AdjdDocType 
                                           AND P.invoice_refnbr = D.AdjdRefNbr
  WHERE      
        D.AdjgDocDate <= @AgingDate 
    AND P.DocType = 'PA'
  GROUP BY
    L.Project

  -- Estimate info into a Temp Table (by project)
  -- Note: You must do this as a temp table because you cannot perform an aggregate function on an expression containing an aggregate or a subquery
  SELECT     
     P.Project
    ,SUM(P.eac_amount) AS Estimate
  INTO 
    #PJEstimates  
  FROM         
    #ListOfProjects L INNER JOIN PJPTDROL P ON L.Project = P.Project 
  WHERE     
    P.Acct IN ('ESTIMATE', 'ESTIMATE TAX')
  GROUP BY 
    P.Project

  -- Task Level Estimate info into a Temp Table 
  -- Note: You must do this as a temp table because you cannot perform an aggregate function on an expression containing an aggregate or a subquery
  SELECT     
     P.Project
    ,P.Pjt_entity  
    ,SUM(P.eac_amount) AS Estimate
  INTO 
    #PJTaskEstimates  
  FROM         
    #ListOfProjects L INNER JOIN PJPTDSUM P ON L.Project = P.Project 
  WHERE     
    P.Acct IN ('ESTIMATE', 'ESTIMATE TAX')
  GROUP BY 
    P.Project
   ,P.Pjt_entity 
      
  -- Get the billing information summed up from the detail table                                 
  -- Note: You must do this as a temp table because you cannot perform an aggregate function on an expression containing an aggregate or a subquery
  SELECT     
     A.Project
    ,SUM(CASE WHEN A.Trantype = '' THEN CASE WHEN A.Acct_group_cd IN ('WP', 'CM') THEN (A.Amount + A.MarkupAmount) ELSE 0 END ELSE 0 END) AS VendorCost
    ,SUM(CASE WHEN A.Trantype = '' THEN CASE WHEN A.Acct_group_cd IN ('WP', 'CM') THEN A.BilledAmount ELSE 0 END ELSE 0 END) AS VendorBill
    ,SUM(CASE WHEN A.Trantype = 'PO' THEN A.Amount ELSE 0 END) AS POCost 
    ,SUM(CASE WHEN A.Trantype = '' THEN CASE WHEN A.Acct_group_cd = 'FE' THEN A.Amount ELSE 0 END ELSE 0 END) AS FeesCost 
    ,SUM(CASE WHEN A.Trantype = '' THEN CASE WHEN A.Acct_group_cd = 'FE' THEN A.BilledAmount ELSE 0 END ELSE 0 END) AS FeesBill
    ,SUM(CASE WHEN A.Trantype = '' THEN CASE WHEN A.Acct_group_cd = 'WA' THEN A.Amount ELSE 0 END ELSE 0 END) AS WIPAPSCost 
    ,SUM(CASE WHEN A.Trantype = '' THEN CASE WHEN A.Acct_group_cd = 'WA' THEN A.BilledAmount ELSE 0 END ELSE 0 END) AS WIPAPSBill
    ,SUM(CASE WHEN A.Trantype = '' THEN CASE WHEN A.Acct_group_cd = 'LB' THEN A.Units ELSE 0 END ELSE 0 END) AS Hours 
    ,SUM(CASE WHEN A.Trantype = '' THEN CASE WHEN A.Acct_group_cd = 'PB' THEN A.Amount ELSE 0 END ELSE 0 END) AS Prebill
  INTO
    #PJTotals
  FROM 
    xJAReportDetailWrk_IWT A      
  WHERE
    A.SessionGUID = @GUID                    
  GROUP BY 
    A.project
    

  -- Current Unlocked Estimate Amount info into a Temp Table 
  -- Note: You must do this as a temp table because you cannot perform an aggregate function on an expression containing an aggregate or a subquery
  -- added 1/27/2011 MSB
  SELECT     
     E.Project
    ,SUM(ISNULL(E.ULEAmount, 0)) AS 'ULEAmount'
  INTO 
    #PJULEAmount  
  FROM         
    #ListOfProjects L LEFT JOIN xvr_Est_ULE_Project E ON L.Project = E.Project 
  GROUP BY 
    E.Project
    
    
  -- Now Update the project headers with the aggregate data from above 3 temp tables.
  UPDATE
    xJAReportHeaderWrk_IWT
  SET
     Tot_Estimate = ISNULL(E.Estimate,0)
    ,Tot_FeesCost = ISNULL(T.FeesCost,0)
    ,Tot_FeesBill = ISNULL(T.FeesBill,0)
    ,Tot_Hours = ISNULL(T.Hours,0)
    ,Tot_Payments = ISNULL(P.Payments,0)
    ,Tot_PreBill = ISNULL(T.PreBill,0)
    ,Tot_POCost = ISNULL(T.POCost,0)
    ,Tot_VendorBill = ISNULL(T.VendorBill,0)
    ,Tot_VendorCost = ISNULL(T.VendorCost,0)
    ,Tot_WIPAPSBill = ISNULL(T.WIPAPSBill,0)
    ,Tot_WIPAPSCost = ISNULL(T.WIPAPSCost,0)
  FROM
    xJAReportHeaderWrk_IWT H LEFT OUTER JOIN #PJTotals T ON H.Project = T.Project
                             LEFT OUTER JOIN #PJPaymentInfo P ON H.Project = P.Project 
                             LEFT OUTER JOIN #PJEstimates E ON H.Project = E.Project  
  WHERE
    H.SessionGUID = @GUID
    
                                                                    
      
/******************************************************************************************************
*** INSERT PARENT SUMMARY INFORMATION ***
*******************************************************************************************************/

  -- Enter Sum of the children tasks and roll up to parent project
  INSERT INTO xJAReportDetailWrk_IWT (
     SessionGUID
    ,Acct_group_cd
    ,Amount
    ,BilledAmount
    ,MarkupAmount
    ,Project
    ,Pjt_entity
    ,Pjt_entity_desc
    ,TranType
    ,Units
    ,Vendor_num
    ,Vendor_name)
  SELECT     
     @GUID
    ,D.Acct_group_cd
    ,SUM(ISNULL(D.Amount,0))
    ,SUM(ISNULL(D.BilledAmount,0))
    ,SUM(ISNULL(D.MarkupAmount,0))
    ,H.Project_BillWith
    ,D.Pjt_entity
    ,D.Pjt_entity_desc
    ,'**'                                       -- We have to put something in the TranType - the RPT suppresses lines that have a NULL TranType
    ,SUM(ISNULL(D.Units,0))
    ,'*** '                                     -- We are using the Vendor Fields to Show the Summary line to display nicely on the report
    ,CASE D.TranType WHEN 'PO' THEN 'Sum of POs ' + H.Project ELSE 'Sum of ' + H.Project END
  FROM 
    xJAReportHeaderWrk_IWT H INNER JOIN xJAReportDetailWrk_IWT D ON H.SessionGUID = D.SessionGUID
                                                                AND H.Project = D.Project
  WHERE
        H.SessionGUID = @GUID
    AND H.Project <> H.Project_BillWith 
  GROUP BY
     D.Acct_group_cd
    ,H.Project_BillWith
    ,D.Pjt_entity 
    ,D.Pjt_entity_desc
    ,CASE D.TranType WHEN 'PO' THEN 'Sum of POs ' + H.Project ELSE 'Sum of ' + H.Project END
  HAVING
       SUM(ISNULL(D.Amount,0)) <> 0                 -- We only want summary entries if there are values - the zero $ entries should be ignored
    OR SUM(ISNULL(D.BilledAmount,0)) <> 0
    OR SUM(ISNULL(D.MarkupAmount,0)) <> 0
    OR SUM(ISNULL(D.Units,0)) <> 0


 -- Now Update the project details with the aggregate data from above 3 temp tables.
 -- Moved location from other 2 temp tables to here to fix update and inserting of summary information.
 --   this is due to no longer updating the parent with TOTAL estimates of all children.  Must come after the children summary of costs onto the parent.
  UPDATE
    xJAReportDetailWrk_IWT
  SET
    Estimate = IsNull(E.Estimate,0) 
  FROM
    xJAReportDetailWrk_IWT D INNER JOIN #PJTaskEstimates E ON D.Project = E.Project
                                                          AND D.Pjt_entity = E.Pjt_entity    
  WHERE
    D.SessionGUID = @GUID                   



  -- We are going to summarize the Project Total information for all the kids (and parent) and roll it up to the parent project
  
  -- Commented out Estimate to remove rollup of estimates for parent jobs - 04/18/2011 - apatten
  
  SELECT
     H.Project_BillWith AS Project
   -- ,SUM(H.Tot_Estimate) AS Tot_Estimate
    ,SUM(H.Tot_FeesCost) AS Tot_FeesCost
    ,SUM(H.Tot_FeesBill) AS Tot_FeesBill
    ,SUM(H.Tot_Hours) AS Tot_Hours
    ,SUM(H.Tot_Payments) AS Tot_Payments
    ,SUM(H.Tot_PreBill) AS Tot_PreBill
    ,SUM(H.Tot_POCost) AS Tot_POCost
    ,SUM(H.Tot_VendorBill) AS Tot_VendorBill
    ,SUM(H.Tot_VendorCost) AS Tot_VendorCost
    ,SUM(H.Tot_WIPAPSBill) AS Tot_WIPAPSBill
    ,SUM(H.Tot_WIPAPSCost) AS Tot_WIPAPSCost
  INTO 
    #ProjectRollUpTotals
  FROM
    xJAReportHeaderWrk_IWT H 
  WHERE
    H.SessionGUID = @GUID
  GROUP BY
    H.Project_BillWith
    
  -- Now update the parent project info with this aggregate data
 -- Commented out Estimate to remove rollup of estimates for parent jobs - 04/18/2011 - apatten
 
   UPDATE
    xJAReportHeaderWrk_IWT
  SET
  --   Tot_Estimate = ISNULL(T.Tot_Estimate,0)
    Tot_FeesCost = ISNULL(T.Tot_FeesCost,0)
    ,Tot_FeesBill = ISNULL(T.Tot_FeesBill,0)
    ,Tot_Hours = ISNULL(T.Tot_Hours,0)
    ,Tot_Payments = ISNULL(T.Tot_Payments,0)
    ,Tot_PreBill = ISNULL(T.Tot_PreBill,0)
    ,Tot_POCost = ISNULL(T.Tot_POCost,0)
    ,Tot_VendorBill = ISNULL(T.Tot_VendorBill,0)
    ,Tot_VendorCost = ISNULL(T.Tot_VendorCost,0)
    ,Tot_WIPAPSBill = ISNULL(T.Tot_WIPAPSBill,0)
    ,Tot_WIPAPSCost = ISNULL(T.Tot_WIPAPSCost,0)
  FROM
    xJAReportHeaderWrk_IWT H INNER JOIN #ProjectRollUpTotals T ON H.Project = T.Project
  WHERE
    H.SessionGUID = @GUID 
    
  -- update the parent project info with Current Locked Estimate 
  -- added 1/27/2011 MSB
  UPDATE
    xJAReportHeaderWrk_IWT
  SET
     CurrentLockedEstimate = ISNULL(E.ULEAmount ,0)
  FROM
    xJAReportHeaderWrk_IWT H LEFT JOIN #PJULEAmount E ON H.Project = E.Project
  WHERE
    H.SessionGUID = @GUID                            
    
/******************************************************************************************************
*** DETAIL CLEANUP PROCESSING ***
*******************************************************************************************************/
  
  -- Now that we've calculated the billing totals, etc. we want to remove the PB records from the details that 
  -- display in the report
  DELETE FROM 
    xJAReportDetailWrk_IWT
  WHERE 
    Acct_group_cd = 'PB'
 
  -- We are going to remove the detail and headers for the Inactive children.  We are doing this last because we still want the roll-up
  -- to occur and we need the details which affect the totals.
  IF @ActiveChildrenOnly <> 0 BEGIN
    DELETE 
      xJAReportDetailWrk_IWT
    FROM 
      xJAReportDetailWrk_IWT D INNER JOIN xJAReportHeaderWrk_IWT H ON D.SessionGUID = H.SessionGUID 
                                                                  AND D.Project = H.Project
    WHERE 
          H.SessionGUID = @GUID
      AND H.Status_pa = 'I'
      AND H.Project <> H.Project_BillWith 
    
    DELETE FROM
      xJAReportHeaderWrk_IWT
    WHERE 
          SessionGUID = @GUID
      AND Status_pa = 'I'
      AND Project <> Project_BillWith 
  END
                                                                                                        
END
