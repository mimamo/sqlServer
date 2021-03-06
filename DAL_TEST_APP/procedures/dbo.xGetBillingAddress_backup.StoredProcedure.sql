USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xGetBillingAddress_backup]    Script Date: 12/21/2015 13:57:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xGetBillingAddress_backup] (
@Project char(16)
)

AS 

DECLARE @ClientBillingAddress varchar(128)

SET @ClientBillingAddress = (SELECT CASE WHEN a.ProjectBillingAddress = '' AND a.CustomerBillingAddress = ' , , . '
										THEN a.CustomerAddress
										WHEN a.ProjectBillingAddress = ''
										THEN a.CustomerBillingAddress
										ELSE a.ProjectBillingAddress end as 'Address'
								FROM (
									SELECT p.project
										,  CASE WHEN ISNULL(a.addr1, '') = ''
												THEN ''
												WHEN a.addr_type_cd <> 'BI'
												THEN ''
												ELSE LTRIM(RTRIM(a.addr1)) + ' ' + LTRIM(RTRIM(a.addr2)) + ', ' + LTRIM(RTRIM(a.city)) + ', ' + LTRIM(RTRIM(a.[state])) + '. ' + LTRIM(RTRIM(a.zip)) end as 'ProjectBillingAddress'
												, LTRIM(RTRIM(c.BillAddr1)) + ' ' + LTRIM(RTRIM(c.BillAddr2)) + ', ' + LTRIM(RTRIM(c.BillCity)) + ', ' + LTRIM(RTRIM(c.BillState)) + '. ' + LTRIM(RTRIM(c.BillZip)) as 'CustomerBillingAddress'
												, LTRIM(RTRIM(c.Addr1)) + ' ' + LTRIM(RTRIM(c.Addr2)) + ', ' + LTRIM(RTRIM(c.City)) + ', ' + LTRIM(RTRIM(c.[State])) +  '. ' + LTRIM(RTRIM(c.Zip)) as 'CustomerAddress'
									FROM PJPROJ p JOIN PJBILL b ON p.project = b.project -- Needed to get current project
										LEFT JOIN PJADDR a ON b.project_billwith = a.addr_key 
										LEFT JOIN PJPROJ bp ON b.project_billwith = bp.project -- Billing Project to get billing customer
										LEFT JOIN Customer c ON bp.pm_id01 = c.CustId --Billing Customer
									Where p.project  ='04091211AGY'
										 AND a.addr_type_cd = 'BI'
										 ) a
									WHERE a.project = @Project )

SELECT @ClientBillingAddress as 'Address'
GO
