USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDWrkContPrint_SingAccessNbr]    Script Date: 12/16/2015 15:55:22 ******/
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
