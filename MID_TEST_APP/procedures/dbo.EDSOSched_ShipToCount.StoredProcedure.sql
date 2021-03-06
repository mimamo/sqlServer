USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOSched_ShipToCount]    Script Date: 12/21/2015 15:49:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDSOSched_ShipToCount] @CpnyId varchar(10), @OrdNbr varchar(15) As
Select Count(Distinct ShipToId) + Sum(MarkFor) From SOSched Where CpnyId = @CpnyId And OrdNbr = @OrdNbr
GO
