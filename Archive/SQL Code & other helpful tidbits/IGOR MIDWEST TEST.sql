 
  -- Update the #ListOfProjects with all the project "Bill With" projects
  CREATE TABLE #ListOfProjects (Project char(16))
  INSERT INTO #ListOfProjects (
    Project)
  SELECT DISTINCT 
    Project
  FROM PJPROJ where project in ('00001212agy')
  
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

      declare @AgingDate date
  set @AgingDate = '10/30/2012'

  -- Clear out the list of project tables
  DELETE FROM #ListOfProjects
  
  -- Insert the complete list
  INSERT INTO #ListOfProjects (
    Project)
  SELECT DISTINCT 
    Project
  FROM
    #ListOfProjectsWrk

select 
A.Acct_group_cd                      -- Account Group 
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
    
    
select
'WP'                                 -- Account Group 
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