USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDSalesPerson_Name]    Script Date: 12/21/2015 15:42:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSalesPerson_Name] @SlsPerId varchar(10) As
Select Name From SalesPerson Where SlsPerId = @SlsPerId
GO
