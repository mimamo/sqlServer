USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_LotSerT_Delete]    Script Date: 12/21/2015 13:44:42 ******/
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
