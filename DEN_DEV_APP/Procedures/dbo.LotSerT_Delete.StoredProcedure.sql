USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerT_Delete]    Script Date: 12/21/2015 14:06:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[LotSerT_Delete]
	@CpnyID varchar( 10 ),
	@BatNbr varchar( 10 ),
	@RefNbr varchar( 15 ),
	@TranType varchar( 3 )
as

Delete From LotSerT
Where CpnyID = @CpnyID
	and BatNbr = @BatNbr
	and RefNbr = @RefNbr
	and TranType = @TranType
GO
