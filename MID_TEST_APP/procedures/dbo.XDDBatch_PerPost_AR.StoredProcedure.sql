USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatch_PerPost_AR]    Script Date: 12/21/2015 15:49:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBatch_PerPost_AR]
  	@PerPost	varchar(6)
AS
  	Select 		*
  	from 		Batch B LEFT OUTER JOIN XDDBatch X
  			ON 'AR' = X.Module and ('R' = X.FileType or 'X' = X.FileType) and B.BatNbr = X.BatNbr
  	where 		B.Module = 'AR'
  			and B.Status = 'U'
  			and B.EditScrnNbr IN ('08010', '08520', 'BIREG')	-- Include Finance Charges
  			and B.PerPost >= @PerPost
  	order by 	B.Module, B.BatNbr DESC, X.BatSeq
GO
