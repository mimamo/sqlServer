USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDWrkContPrint_SingAccessNbr]    Script Date: 12/21/2015 16:07:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[EDWrkContPrint_SingAccessNbr]
	@AccessNbr Integer,
	@ShipperID VarChar(30)
As
Select * From EDWrkContPrint Where AccessNbr = @AccessNbr and ShipperID Like @ShipperID Order By AccessNbr, ShipperID
GO
