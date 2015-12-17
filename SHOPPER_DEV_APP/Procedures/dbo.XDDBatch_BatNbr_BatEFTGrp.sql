USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatch_BatNbr_BatEFTGrp]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBatch_BatNbr_BatEFTGrp]
	@Module		varchar( 2 ),
	@FileType	varchar( 1 ),
	@BatNbr		varchar( 10 ),
	@BatSeq		smallint,
	@BatEFTGrp	smallint
AS
  	Select 		*
  	FROM 		XDDBatch
  	WHERE 		Module = @Module
  			and FileType = @FileType
  			and BatNbr = @BatNbr
  			and BatSeq = @BatSeq
  			and BatEFTGrp LIKE @BatEFTGrp
  	ORDER BY	BatNbr DESC, BatSeq DESC, BatEFTGrp DESC
GO
