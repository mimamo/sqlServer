USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOHeader_Cancel]    Script Date: 12/21/2015 15:36:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOHeader_Cancel] @CpnyId varchar(10), @OrdNbr varchar(15) As
Update SOHeader Set Cancelled = 1, CancelDate = GetDate() Where CpnyId = @CpnyId And OrdNbr = @OrdNbr
GO
