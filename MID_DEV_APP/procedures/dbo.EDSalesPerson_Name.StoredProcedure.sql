USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSalesPerson_Name]    Script Date: 12/21/2015 14:17:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSalesPerson_Name] @SlsPerId varchar(10) As
Select Name From SalesPerson Where SlsPerId = @SlsPerId
GO
