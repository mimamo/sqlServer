USE [SHOPPER_TEST_APP]
GO
/****** Object:  View [dbo].[xvw_ClientGroupings]    Script Date: 12/21/2015 16:06:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvw_ClientGroupings] with schemabinding
AS
SELECT     TOP (100) PERCENT c.User6 AS ClassGroup, pjc.code_value_desc AS GroupDesc, c.ClassId, cc.Descr, c.CustId, c.Name, c.Status
FROM         dbo.Customer AS c LEFT OUTER JOIN
                      dbo.CustClass AS cc ON c.ClassId = cc.ClassId LEFT OUTER JOIN
                      dbo.PJCODE AS pjc ON c.User6 = pjc.code_value
ORDER BY ClassGroup, c.ClassId, c.CustId
GO
