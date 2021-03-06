USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[WOCheckAccount_Acct]    Script Date: 12/21/2015 13:45:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[WOCheckAccount_Acct]
   	@Account	varchar(10),	-- GL Account
   	@Acct		varchar(16)	-- PA Account Category
as

	if exists(	SELECT * from PJ_Account (nolock)
			WHERE	gl_acct = @Account
				and acct = @Acct)
		Select	1
	else
		Select 	0
GO
