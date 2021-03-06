USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pp_WrkReleaseRec]    Script Date: 12/21/2015 16:07:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[pp_WrkReleaseRec]
	@BatNbr char(10),
	@Module char(2),
	@UserAddress char(21),
	@Direction int AS

SET NOCOUNT ON

IF @Direction = 0
	DELETE WrkRelease
		WHERE Module = @Module AND BatNbr = @BatNbr AND UserAddress = @UserAddress
ELSE
      INSERT WrkRelease
       select @BatNbr,@Module,@UserAddress,  NULL
       WHERE (SELECT COUNT(BatNbr)
                FROM WrkRelease w2
               WHERE w2.Module = @Module AND w2.BatNbr = @BatNbr) = 0
GO
