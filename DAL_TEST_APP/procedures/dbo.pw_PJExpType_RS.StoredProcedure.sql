USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pw_PJExpType_RS]    Script Date: 12/21/2015 13:57:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pw_PJExpType_RS]
	@Parm0 varchar(4) AS
exec("
	Select E.desc_exp, E.default_rate, A.gl_acct, E.Units_flag, E.gl_acct from pjexptyp E, Pj_Account A
		where E.exp_type = '" + @Parm0 + "' and E.gl_acct *= A.gl_acct"
)
GO
