USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipLine_VerifyCntr]    Script Date: 12/21/2015 13:44:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOShipLine_VerifyCntr] @CpnyId varchar(10), @ShipperId varchar(15) As
Select Count(*) From SOShipLine Where CpnyId = @CpnyId And ShipperId = @ShipperId And LotSerCntr = 0
GO
