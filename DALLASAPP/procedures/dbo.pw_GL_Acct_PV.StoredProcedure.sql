USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[pw_GL_Acct_PV]    Script Date: 12/21/2015 13:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pw_GL_Acct_PV] 
	@Parm0 varchar(10), @Parm1 varchar(10), @ParmEmployee varchar(10), @SortCol varchar(60) AS
exec("
	
	Select 'Account'=rtrim(A.Acct), 'Description'=rtrim(A.Descr)
		From Account A, PJ_Account P
		Where
			A.Acct = P.gl_Acct
			and A.Acct like '%" + @Parm0 + "%'
			and A.Active = 1 
		Order by " + @SortCol  
)
GO
