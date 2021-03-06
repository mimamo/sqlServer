USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBank_All]    Script Date: 12/21/2015 14:34:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBank_All]
	@parm1		varchar(10),
	@parm2 		varchar(10),
	@parm3 		varchar(24)
AS
  	Select 		*
  	from 		XDDBank
  	where 		CpnyID LIKE @parm1
  			and Acct like @parm2
  			and Sub like @parm3
  	ORDER by 	CpnyID, Acct, Sub
GO
