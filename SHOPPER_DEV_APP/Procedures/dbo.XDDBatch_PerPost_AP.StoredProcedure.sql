USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatch_PerPost_AP]    Script Date: 12/21/2015 14:34:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBatch_PerPost_AP]
  	@PerPost	varchar(6)
AS
  	Select 		*
  	from 		Batch B LEFT OUTER JOIN XDDBatch X
  			ON 'AP' = X.Module and B.BatNbr = X.BatNbr
  	where 		B.Module = 'AP'
  			and (	(B.EditScrnNbr = '03620'
  				 and B.Status = 'U'
  				 and (Select count(*) from APDoc A (nolock) where A.BatNbr = B.BatNbr and A.Status IN ('C','O')) > 0)
  			     or
  			    	(B.EditScrnNbr = '03030'
  			    	 and B.Status IN ('U', 'P', 'H')
  			    	 and B.OrigScrnNbr = 'DD520'
  			    	 and B.CuryCrTot <> 0)
  			    )
  			and B.PerPost >= @PerPost
	     		and ((X.FileType IS NOT NULL and X.FileType IN ('E', 'W')) or X.FileType IS NULL)  
  	order by 	B.Module, B.BatNbr DESC
GO
