USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_LotSerT_Delete]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_LotSerT_Delete]
		@CpnyID		varchar(10),
	@Batnbr		varchar(15),
	@RefNbr		varchar(15),
	@INTranLineRef  	varchar(5),
	@LotSerRef		varchar(5)
AS
	DELETE FROM LotSerT
	WHERE	CpnyID = @CpnyID AND
		BatNbr = @BatNbr AND
		RefNbr = @RefNbr AND
		INTranLineRef = @INTranLineRef AND
		LotSerRef = @LotSerRef
GO
