 SELECT
    B.project  
  FROM 
    PJPROJ L INNER JOIN PJBILL A ON L.Project = A.Project
                      INNER JOIN PJBILL B ON A.project_billwith = B.project_billwith 
  WHERE
    A.project_billwith <> ''  

    
    
 -- creates the working header   
 DECLARE @AgingDate as VARCHAR(15)
SET @AgingDate = '4/20/2012'  
    
 select P.project
	, P.Project_desc
    ,@AgingDate as 'AgingDate'
    ,REPLACE(E2.Emp_name, '~',', ') as ASName
    ,ISNULL(XC.CName, 'NO CLIENT CONTACT') as ClientName
    ,ISNULL(XC.EmailAddress, 'NO EMAIL') as ClientEMail
    ,P.CpnyID
    ,C.CustID
    ,C.Name
    ,CASE WHEN P.End_Date = '1/1/1900' THEN NULL ELSE P.End_Date END as End_Date
    ,0 as HasChildren
    ,B.Inv_format_cd
    ,P.Pm_id01
    ,P.Pm_id02
    ,CASE WHEN P.Pm_id08 = '1/1/1900' THEN NULL ELSE P.Pm_id08 END as Pm_id08
    ,CASE WHEN PE.Pm_id28 = '1/1/1900' THEN NULL ELSE PE.Pm_id28 END as Pm_id28
    ,P.Pm_id32
    ,REPLACE(E1.Emp_name, '~',', ') as PMName
    ,B.Project_BillWith
    ,X.descr as ProdCode
    ,P.Purchase_order_num
    ,CASE WHEN P.Start_Date = '1/1/1900' THEN NULL ELSE P.Start_Date END as Start_Date
    ,P.Status_pa
   -- , TemplateID = @TemplateID --added 03/17/2011 MSB
  FROM
    (SELECT
    B.project  
  FROM 
    PJPROJ L INNER JOIN PJBILL A ON L.Project = A.Project
                      INNER JOIN PJBILL B ON A.project_billwith = B.project_billwith 
  WHERE
    A.project_billwith <> '' ) H INNER JOIN PJProj P ON H.Project = P.Project
                             INNER JOIN PJProjEX PE ON H.Project = PE.Project
                             INNER JOIN Customer C ON P.pm_id01 = C.CustID
                             INNER JOIN PJBILL B ON H.Project = B.Project
                             LEFT OUTER JOIN xIGProdCode X ON P.pm_id02 = X.Code_ID
                             LEFT OUTER JOIN xClientContact XC ON P.User2 = XC.EA_ID
                             LEFT OUTER JOIN PJEmploy E1 ON P.manager1 = E1.employee
                             LEFT OUTER JOIN PJEmploy E2 ON P.manager2 = E2.employee 
                             
/******************************************************************************************************/
----- Gets all of the children projects from the table
/*****************************************************************************************************/
      SELECT
     B.Project_BillWith as Project
  FROM
    PJBILL B INNER JOIN (select P.project
	, P.Project_desc
    --,@AgingDate as 'AgingDate'
    ,REPLACE(E2.Emp_name, '~',', ') as ASName
    ,ISNULL(XC.CName, 'NO CLIENT CONTACT') as ClientName
    ,ISNULL(XC.EmailAddress, 'NO EMAIL') as ClientEMail
    ,P.CpnyID
    ,C.CustID
    ,C.Name
    ,CASE WHEN P.End_Date = '1/1/1900' THEN NULL ELSE P.End_Date END as End_Date
    ,0 as HasChildren
    ,B.Inv_format_cd
    ,P.Pm_id01
    ,P.Pm_id02
    ,CASE WHEN P.Pm_id08 = '1/1/1900' THEN NULL ELSE P.Pm_id08 END as Pm_id08
    ,CASE WHEN PE.Pm_id28 = '1/1/1900' THEN NULL ELSE PE.Pm_id28 END as Pm_id28
    ,P.Pm_id32
    ,REPLACE(E1.Emp_name, '~',', ') as PMName
    ,B.Project_BillWith
    ,X.descr as ProdCode
    ,P.Purchase_order_num
    ,CASE WHEN P.Start_Date = '1/1/1900' THEN NULL ELSE P.Start_Date END as Start_Date
    ,P.Status_pa
   -- , TemplateID = @TemplateID --added 03/17/2011 MSB
  FROM
    (SELECT
    B.project  
  FROM 
    PJPROJ L INNER JOIN PJBILL A ON L.Project = A.Project
                      INNER JOIN PJBILL B ON A.project_billwith = B.project_billwith 
  WHERE
    A.project_billwith <> '' ) H INNER JOIN PJProj P ON H.Project = P.Project
                             INNER JOIN PJProjEX PE ON H.Project = PE.Project
                             INNER JOIN Customer C ON P.pm_id01 = C.CustID
                             INNER JOIN PJBILL B ON H.Project = B.Project
                             LEFT OUTER JOIN xIGProdCode X ON P.pm_id02 = X.Code_ID
                             LEFT OUTER JOIN xClientContact XC ON P.User2 = XC.EA_ID
                             LEFT OUTER JOIN PJEmploy E1 ON P.manager1 = E1.employee
                             LEFT OUTER JOIN PJEmploy E2 ON P.manager2 = E2.employee) P ON B.Project_BillWith = P.Project 
                                                AND P.Project = P.Project_BillWith  
  GROUP BY 
    B.Project_BillWith
  HAVING
    COUNT(B.Project_BillWith) > 1