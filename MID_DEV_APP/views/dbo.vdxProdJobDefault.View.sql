USE [MID_DEV_APP]
GO
/****** Object:  View [dbo].[vdxProdJobDefault]    Script Date: 12/21/2015 14:17:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[vdxProdJobDefault]
As
Select * from xProdJobDefault x
Where Product = (Select Max(Product) from xProdJobDefault where CustId=X.CustId)
GO
