USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipTicket_Nav]    Script Date: 12/21/2015 16:07:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDShipTicket_Nav] @BOLNbr varchar(20), @ShipperID Varchar(15), @CpnyId VarChar(10) As
Select * From EDShipTicket Where BOLNbr = @BOLNbr AND ShipperID LIKE  @shipperID AND CpnyId LIKE @CpnyId
GO
