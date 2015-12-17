USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatch_BatNbr_BatSeq_BatEFTGrp]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBatch_BatNbr_BatSeq_BatEFTGrp]
	@Module		varchar( 2 ),
	@BatNbr		varchar( 10 ),
	@FileType	varchar( 1 ),
	@BatSeq		smallint,
	@BatEFTGrp	smallint
AS
  	Select 		*
  	FROM 		XDDBatch
  	WHERE 		Module = @Module
  			and BatNbr = @BatNbr
  			and FileType = @FileType
  			and BatSeq = @BatSeq
  			and BatEFTGrp = @BatEFTGrp
GO
