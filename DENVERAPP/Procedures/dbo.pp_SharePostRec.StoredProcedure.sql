USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[pp_SharePostRec]    Script Date: 12/21/2015 15:43:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[pp_SharePostRec]
	@BatNbr char(10),
	@Module char(2),
	@UserAddress char(21),
	@Direction int AS

IF @Direction = 0
	DELETE WrkPost
		WHERE Module = @Module AND BatNbr = @BatNbr AND UserAddress = @UserAddress
ELSE
	INSERT WrkPost
	 select @BatNbr, @Module, @UserAddress, NULL
       WHERE (SELECT COUNT(batNbr)
                FROM WrkPost w
               WHERE w.Module = @Module AND w.BatNbr = @BatNbr) = 0
GO
