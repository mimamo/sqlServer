USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[pw_PJCode_LABC_PV]    Script Date: 12/21/2015 13:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pw_PJCode_LABC_PV] 
	@Parm0 varchar(30), @Parm1 varchar(1), @ParmEmployee varchar(10), @SortCol varchar(10) AS
exec("
	Select 'Labor Class'=Code_Value, Description=Code_Value_Desc 
	from PJCODE 
	where Code_Type = 'LABC' and Code_Value like '%" + @Parm0 + "%'
	Order by " + @SortCol  
)
GO
