USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xJAProcessReport_Midwest]    Script Date: 12/21/2015 14:18:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xJAProcessReport_Midwest] 
/******************************************************************************************************
* Modified   Developer Description
* 2014-10-02 KWallace  Changed Billed amount to come from Transaction table, rather than derived Invoice table
* 2014-04-24 KWallace  Added Rate_Level 6 to rate logic
* 2013-13-05 DBERTRAM  added formula correction to the invoice query to determine the amount
* 2013-03-01 djohnson  Remove DISTINCT added with reservations on 02-27.
* 2013-02-27 djohnson  Eliminate duplicate invoice lines.
* 2013-02-21 djohnson  Sales Over/Under lines should show under Vendor unless pjt_entity LIKE '99%'
* 2013-02-20 djohnson  Hours may be negative
* 2013-02-11 djohnson  Filter hours to only include labor tasks (pjt_entity LIKE '99%').
* 2013-02-10 djohnson  Add Billable Rate logic for Midwest.
* 2013-02-07 djohnson  Add parameter for unbilled only.
* 2013-02-06 djohnson  Move Labor and Sales Over/Under
* 2013-02-01 djohnson  Use subquery for Sales Over/Under to prevent duplicates.
* 2013-01-29 djohnson  Added filter to Sales Over/Under query.
* 2013-01-16 djohnson  Add Sales Over/Under to work table and display as a fee.
* 2013-01-09 djohnson  Hide functions without activity unless they have a "locked estimate".
* 2013-01-09 djohnson  SuppressDfltDtl did nothing. Hide task '00000'.
* 2013-01-07 djohnson  Find employee hours for the job & function and display on same line as amount.
*******************************************************************************************************/
   @GUID                  varchar(255)
  ,@AgingDate             smalldatetime
  ,@ActiveChildrenOnly    smallint
  ,@SupressDfltDtl        smallint
  ,@UnbilledOnly          smallint
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
    ,CASE WHEN ISNULL(I.Invoice_type, '') <> '' AND ISNULL(I.Ih_id12, '') <> '' 
		THEN -T.amount ELSE T.amount END	-- Amount
    --,ISNULL(I.amount, 0)                  -- Billed Amount 
    ,CASE WHEN (T.acct = 'WRITE OFF FREELN' OR T.acct = 'WRITE OFF HOURS') AND A.acct_group_cd = 'FE' 
		THEN T.amount ELSE ISNULL(I.amount, 0) END	-- Billed Amount   -- ADDED 03/08/2013 DBERTRAM  -- Corrects the billed amount for fees not showing on the report
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
                          --,SUM(CASE WHEN D.acct = 'LABOR' THEN D.CuryOrig_amount - D.CuryHold_amount WHEN D.acct = 'SALES OVER/UNDER' THEN D.amount ELSE D.CuryOrig_amount END) as 'amount'
                          ,SUM(CASE WHEN D.acct = 'SALES OVER/UNDER' THEN D.amount ELSE D.CuryOrig_amount - D.CuryHold_amount END) as 'amount'  -- DAB 05/13/2013 - updated to account for all partial bills
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
    AND A.acct_group_cd IN ('FE', 'WA', 'PB') 
    AND T.batch_type <> 'GJ' 
  
  -- Start Midwest Modification, 13-01-07 dj
  /*DECLARE @TaskHours TABLE (
  employee varchar(10),
  project varchar(16),
  pjt_entity varchar(32),
  hourDate smalldatetime,
  units float)
 
  INSERT @TaskHours 
  SELECT T.employee, T.project, T.pjt_entity, T.trans_date, SUM(T.units)
  FROM #ListOfProjects P
  JOIN PJTran T ON P.project = t.project
  JOIN PJAcct A ON T.acct = A.acct
  WHERE A.acct_group_cd = 'LB'
    --AND T.units > 0 -- Units may be negative dj 2013-02-20
    AND T.Trans_date <= @AgingDate 
	AND T.pjt_entity LIKE '99%' -- Filter hours to only include labor tasks, 2013-02-11 dj
  GROUP BY T.employee, T.project, T.pjt_entity, T.trans_date 
  -- End Midwest Modification, 13-01-07 dj*/
  
  -- Start Billable Rate modification 13-02-10 dj
	DECLARE @BillableRate TABLE (
		project varchar(16),
		pjt_entity varchar(32),
		employee varchar(10),
		custId varchar(15),
		rate float)
  
	INSERT @BillableRate
	SELECT DISTINCT
		T.project,
		T.pjt_entity,
		T.employee,
		P.pm_id01 As custId,
		COALESCE(F.rate, E.rate,ProdRate.rate, C.rate) As rate
	FROM #ListOfProjects L
	JOIN PJTran T
	  ON L.project = T.project
	JOIN PJProj P
	  ON T.project = P.project
	
	LEFT JOIN PJRate F -- Function/Customer rate
	  ON F.rate_table_id = '0000'
	 AND F.rate_type_cd = 'MW' 
	 AND T.pjt_entity = F.rate_key_value1
	 AND P.pm_id01 = F.rate_key_value2 -- CustId
	 AND F.rate_level = 3
	 AND F.effect_date = 
	   (SELECT MAX(effect_date) 
		FROM PJRate R 
		WHERE R.rate_table_id = F.rate_table_id
		  AND R.rate_type_cd = F.rate_type_cd
		  AND R.rate_level = F.rate_level
		  AND R.rate_key_value1 = F.rate_key_value1
		  AND R.rate_key_value2 = F.rate_key_value2)
	
	LEFT JOIN PJRate E -- Employee/Customer rate
	  ON E.rate_table_id = '0000'
	 AND E.rate_type_cd = 'MW' 
	 AND T.employee = E.rate_key_value1
	 AND P.pm_id01 = E.rate_key_value2
	 AND E.rate_level = 5
	 AND E.effect_date = 
	   (SELECT MAX(effect_date) 
		FROM PJRate R 
		WHERE R.rate_table_id = E.rate_table_id
		  AND R.rate_type_cd = E.rate_type_cd
		  AND R.rate_level = E.rate_level
		  AND R.rate_key_value1 = E.rate_key_value1
		  AND R.rate_key_value2 = E.rate_key_value2)

	LEFT JOIN PJRate ProdRate -- Product rate
	  ON ProdRate.rate_table_id = '0000'
	 AND ProdRate.rate_type_cd = 'MW' 
	 AND P.pm_id02 = ProdRate.rate_key_value1
	 AND ProdRate.rate_level = 6
	 AND ProdRate.effect_date = 
	   (SELECT MAX(effect_date) 
		FROM PJRate R 
		WHERE R.rate_table_id = ProdRate.rate_table_id
		  AND R.rate_type_cd = ProdRate.rate_type_cd
		  AND R.rate_level = ProdRate.rate_level
		  AND R.rate_key_value1 = ProdRate.rate_key_value1
		  AND R.rate_key_value2 = ProdRate.rate_key_value2)
	
	LEFT JOIN PJRate C -- Customer rate
	  ON C.rate_table_id = '0000'
	 AND C.rate_type_cd = 'MW' 
	 AND P.pm_id01 = C.rate_key_value1
	 AND C.rate_level = 7
	 AND C.effect_date = 
	   (SELECT MAX(effect_date) 
		FROM PJRate R 
		WHERE R.rate_table_id = C.rate_table_id
		  AND R.rate_type_cd = C.rate_type_cd
		  AND R.rate_level = C.rate_level
		  AND R.rate_key_value1 = C.rate_key_value1
		  AND R.rate_key_value2 = C.rate_key_value2)
	WHERE T.pjt_entity LIKE '99%'

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
    ,Rate
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
    ,SUM(CASE WHEN A.Acct_group_cd = 'CM' THEN 0 ELSE CASE WHEN ISNULL(I.Invoice_type, '') <> '' AND ISNULL(I.Ih_id12, '') <> '' THEN 0 ELSE T.amount END END) -- Amount
    
    --,SUM(CASE WHEN A.Acct_group_cd = 'CM' THEN 0 ELSE CASE WHEN ISNULL(I.invoice_type, '') = 'REVD' THEN 0 ELSE ISNULL(I.amount, 0) END END) -- Billed Amount
    ,isnull(SUM(CASE WHEN A.Acct_group_cd = 'CM' THEN 0 ELSE CASE WHEN ISNULL(I.invoice_type, '') = 'REVD' THEN 0 
          ELSE CASE WHEN ISNULL(I.Invoice_num,'') <> '' THEN    ISNULL(T.amount, 0) END END END),0) -- Billed Amount [10/1/2014 changed KW and DJ]
  
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
    ,R.Rate                               -- Billable Rate Modification, 13-02-10 dj
    ,T.Trans_date
    ,''                                   -- TranType 
    ,T.Tr_comment                         -- Description
    ,T.Tr_id02                            -- InvoiceNbr
    ,T.Tr_id03                            -- PONbr
    ,T.Tr_id04                            -- Batch Number
    ,T.Tr_id08                            -- Invoice Date 
	--,ISNULL(H.Units, SUM(T.Units)) As Units    -- Units -- Midwest Modification, 13-01-07 dj
    --,ISNULL(H.Units, 0.0) As Units        -- Filter hours to only include labor tasks, 2013-02-11 dj  
    ,CASE WHEN P.Pjt_entity LIKE '99%' THEN ISNULL(SUM(T.units), 0) ELSE 0 END As Units 
    /*,CASE WHEN r.rate > 0 THEN 
		SUM(CASE WHEN A.Acct_group_cd = 'CM' THEN 0 ELSE CASE WHEN ISNULL(I.Invoice_type, '') <> '' AND ISNULL(I.Ih_id12, '') <> '' THEN 0 ELSE T.amount END END) / r.rate
		ELSE SUM(CASE WHEN P.Pjt_entity LIKE '99%' THEN ISNULL(T.units, 0) ELSE 0 END) 
		END as Units*/
    ,T.Vendor_num                         -- Vendor ID
    ,REPLACE(V.Name, '~',', ')            -- Vendor Name 
    ,ISNULL(P.user1, '') AS 'POLineItem' -- POLineItem --added 01/28/2011 MSB updated 02/18/2011 MSB
  FROM
    #ListOfProjects L INNER JOIN PJTran T ON L.Project = T.Project 
                      INNER JOIN PJProj J ON L.Project = J.Project
                      INNER JOIN PJPent P ON T.Pjt_entity = P.Pjt_entity AND
                                             T.Project = P.Project 
                      INNER JOIN PJAcct A ON T.Acct = A.Acct    
                      /*LEFT OUTER JOIN @TaskHours H                     -- Midwest Modification, 13-01-07 dj
								   ON T.employee = H.employee          -- Midwest Modification, 13-01-07 dj
							      AND T.project = H.project            -- Midwest Modification, 13-01-07 dj
							      AND T.pjt_entity = H.pjt_entity      -- Midwest Modification, 13-01-07 dj
							      AND T.trans_date = H.hourDate        -- Midwest Modification, 13-01-07 dj  
								  AND T.pjt_entity LIKE '99%'          -- Filter hours to only include labor tasks, 2013-02-11 dj*/
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
                          --,SUM(CASE WHEN D.acct = 'LABOR' THEN D.CuryOrig_amount - D.CuryHold_amount WHEN D.acct = 'SALES OVER/UNDER' THEN D.amount ELSE D.CuryOrig_amount END) as 'amount'
                          ,SUM(CASE WHEN D.acct = 'SALES OVER/UNDER' THEN D.amount ELSE D.CuryOrig_amount - D.CuryHold_amount END) as 'amount'  -- DAB 05/13/2013 - updated to account for all partial bills
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
				      LEFT OUTER JOIN @BillableRate R                    -- Billable Rate Modification, 13-02-10 dj
				                   ON T.project = R.project              -- Billable Rate Modification, 13-02-10 dj
				                  AND T.pjt_entity = R.pjt_entity        -- Billable Rate Modification, 13-02-10 dj
				                  AND T.employee = R.employee            -- Billable Rate Modification, 13-02-10 dj
				                  AND J.pm_id01 = R.custId               -- Billable Rate Modification, 13-02-10 dj
				                  AND T.pjt_entity LIKE '99%'            -- Billable Rate Modification, 13-02-10 dj
  WHERE T.Trans_date <= @AgingDate  
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
    ,R.Rate                               -- Billable Rate Modification, 13-02-10 dj
    ,T.Trans_date
    --,H.Units                              -- Midwest Modification, 13-01-07 dj
    ,T.units
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
	   ,CASE WHEN A.Acct_group_cd = 'CM' THEN 0 ELSE CASE WHEN ISNULL(I.invoice_type, '') = 'REVD' THEN 0 ELSE ISNULL(I.amount, 0) END END
--,isnull(CASE WHEN A.Acct_group_cd = 'CM' THEN 0 ELSE CASE WHEN ISNULL(I.invoice_type, '') = 'REVD' THEN 0 
   --       ELSE 
          --CASE WHEN ISNULL(I.Invoice_num,'') <> '' THEN   
     --      ISNULL(T.amount, 0) END END,0 ) -- Billed Amount [10/1/2014 changed KW and DJ]
  
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
     
  -- Add the Sales Over/Under lines for MidWest, dj 2013-01-16
  -- Add the Write Off lines for the Midwest report, DBERTRAM 03/08/2013
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
		,POLineItem)  
	  SELECT 
	  W.SessionGUID, 
	  'NA',
	  Case when D.amount = 0 then D.CuryOrig_amount else D.amount end As Amount,  -- added case to handle sales over/under - DBERTRAM 4.3.2013
	  Case when D.amount = 0 then D.CuryOrig_amount else D.amount end As BilledAmount,  -- added case to handle sales over/under - DBERTRAM 4.3.2013
	  NULL As Employee,
	  NULL As Emp_Name,
	  H.ih_id12,
	  H.inv_format_cd,
	  H.invoice_num,
	  H.invoice_type,
	  0.0 As MarkupAmount,
	  D.project,
	  D.pjt_entity,
	  T.pjt_entity_desc,
	  D.source_trx_date As Trans_date,
	  '' As TranType,
	  NULL As Tr_Comment,
	  NULL As Tr_id02,
	  NULL As Tr_id03,
	  NULL As Tr_id04,
	  NULL As Tr_id08,
	  D.units,
	  D.vendor_num,
	  REPLACE(V.Name, '~',', ') As Vendor_name,
	  NULL As POLineItem
	FROM -- Multiple rows for a task in xJAReportDetailWrk_IWT cause duplicates here. dj 2013-02-01
	  (SELECT DISTINCT SessionGuid, Invoice_num, project, pjt_entity 
	   FROM xJAReportDetailWrk_IWT 
       WHERE SessionGUID = @GUID) W -- Without this the join affects the entire work table. dj 2013-01-29
	JOIN PJINVHDR H
	  ON W.Invoice_num = H.invoice_num
	JOIN PJInvDet D
	  ON H.draft_num = D.draft_num
	 AND W.Project = D.project
	 AND W.Pjt_entity = D.pjt_entity
	JOIN PJPENT T
	  ON D.project = T.project
	 AND D.pjt_entity = T.pjt_entity
	JOIN PJAcct A 
	  ON D.Acct = A.Acct 
	LEFT JOIN Vendor V
	  ON D.vendor_num = V.VendId
	WHERE D.acct IN ('SALES OVER/UNDER','WRITE OFF HOURS','WRITE OFF FREELN')
  
  -- Delete the accrual tasks - we do this here BEFORE totals are calculated...  Jill does not want these
  -- anywhere on the report
  DELETE FROM
    xJAReportDetailWrk_IWT
  WHERE
    Pjt_entity = '99999'

  -- SuppressDfltDtl did nothing. Hide task '00000'. dj 2013-01-09
  IF @SupressDfltDtl = -1
      DELETE FROM
    xJAReportDetailWrk_IWT
  WHERE
    Pjt_entity = '00000'
                      
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
  -- Move Labor and Sales Over/Under to Labor Cost line (formerly known as WIPAPS..., dj 2013-02-06
  -- Added FE acct_group_cd to the labor costs when also the pjt_entity was like 99 and NOT LIKE 99 in the FE section,  DAN BERTRAM 03/18/13
SELECT     
     A.Project
    ,SUM(CASE WHEN A.Trantype = '' THEN CASE WHEN (A.Acct_group_cd = 'CM' OR (A.Acct_group_cd IN ('NA', 'WP','FE') AND NOT (A.Pjt_entity LIKE '99%' OR  A.Pjt_entity LIKE '77%'))) THEN (A.Amount + A.MarkupAmount) ELSE 0 END ELSE 0 END) AS VendorCost
    
    ,SUM(CASE WHEN A.Trantype = '' THEN CASE WHEN (A.Acct_group_cd = 'CM' OR (A.Acct_group_cd IN ('NA', 'WP','FE') AND NOT (A.Pjt_entity LIKE '99%' OR  A.Pjt_entity LIKE '77%'))) THEN A.BilledAmount ELSE 0 END ELSE 0 END) AS VendorBill
    ,SUM(CASE WHEN A.Trantype = 'PO' THEN A.Amount ELSE 0 END) AS POCost 
    
    ,SUM(CASE WHEN A.Trantype = '' THEN CASE WHEN A.Acct_group_cd = 'FE' AND NOT (A.Pjt_entity LIKE '99%' OR A.Pjt_entity LIKE '60%') THEN A.Amount ELSE 0 END ELSE 0 END) AS FeesCost 
    
    ,SUM(CASE WHEN A.Trantype = '' THEN CASE WHEN A.Acct_group_cd = 'FE' AND NOT (A.Pjt_entity LIKE '99%' OR A.Pjt_entity LIKE '60%') THEN A.BilledAmount ELSE 0 END ELSE 0 END) AS FeesBill
    
    ,SUM(CASE WHEN A.Trantype = '' THEN CASE WHEN (A.Acct_group_cd IN ('WA') OR (A.Acct_group_cd IN ('NA', 'WP', 'FE') AND A.Pjt_entity LIKE '99%')) THEN A.Amount ELSE 0 END ELSE 0 END) AS WIPAPSCost 
    
    ,SUM(CASE WHEN A.Trantype = '' THEN CASE WHEN (A.Acct_group_cd IN ('WA') OR (A.Acct_group_cd IN ('NA', 'WP', 'FE') AND A.Pjt_entity LIKE '99%')) THEN A.BilledAmount ELSE 0 END ELSE 0 END) AS WIPAPSBill
    
	,SUM(CASE WHEN rate > 0 THEN ISNULL(amount/rate,0) ELSE ISNULL(Units,0) END) AS [Hours]  -- ADDED 03/08/2013 DBERTRAM - Better Hours calculation
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
    ,Tot_Hours = ISNULL(T.[Hours],0)
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
    
  -- Added 3/6/2013 - DBERTRAM 
  -- Delete the duplicate record created by adding the 'SALES OVER/UNDER' account to the report for Voids/Reversals
  
  DELETE FROM 
    xJAReportDetailWrk_IWT
  WHERE 
    Acct_group_cd = 'NA' AND Invoice_type = 'REVR'
 
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

  -- Hide functions without activity unless they have a "locked estimate". dj 2013-01-09
  DELETE FROM
    xJAReportDetailWrk_IWT
  WHERE Amount IS NULL
    AND Estimate IS NULL
                                                                                                        
END
GO
