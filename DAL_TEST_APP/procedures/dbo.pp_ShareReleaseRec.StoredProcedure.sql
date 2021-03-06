USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pp_ShareReleaseRec]    Script Date: 12/21/2015 13:57:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[pp_ShareReleaseRec]
	@BatNbr char(10),
	@Module char(2),
	@UserAddress char(21),
	@Direction int = 1 AS

IF @Direction = 0
	DELETE WrkRelease
		WHERE Module = @Module AND BatNbr = @BatNbr AND UserAddress = @UserAddress
ELSE
	IF (SELECT COUNT(BatNbr) FROM WrkRelease
	    WHERE Module = @Module AND BatNbr = @BatNbr and UserAddress=@UserAddress) = 0

		INSERT WrkRelease VALUES (@BatNbr, @Module, @UserAddress, null)
GO
