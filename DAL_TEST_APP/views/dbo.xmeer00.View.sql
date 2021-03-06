USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xmeer00]    Script Date: 12/21/2015 13:56:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------------------------------------------------------------
-- MAG 1/13/11                                                                                    --                                                                          --
-- Created this simple view to read APDOC for employee expense reimbursement checks               --
-- Got the select statement from the Check Register report                                        --
--------------------------------------------------------------------------------------------------------------------


CREATE view [dbo].[xmeer00] 
as
SELECT Vendor.RemitName AS 'Employee', Vendor.VendId AS 'Vendor_ID',
  apdoc.refnbr AS 'Check_Number', apdoc.doctype AS 'Doc_Type',
  apdoc.docdate AS 'Check_Date' ,
  apdoc.origdocamt AS 'Check_Amount' FROM Vendor
 LEFT OUTER JOIN apdoc ON Vendor.VendId = apdoc.VendID
 WHERE (Vendor.ClassID = 'EMP') AND
  apdoc.doctype in ('CK', 'HC', 'ZC', 'MC', 'SC', 'VC') AND
  apdoc.rlsed = 1
GO
