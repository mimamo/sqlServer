USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBank_Acct_Sub]    Script Date: 12/21/2015 13:36:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBank_Acct_Sub]
	@parm1		varchar(10),
	@parm2 		varchar(10),
	@parm3 		varchar(24)
AS
  	Select 		*
  	from 		XDDBank
  	where 		CpnyID = @parm1
  			and Acct = @parm2
  			and Sub = @parm3
GO
