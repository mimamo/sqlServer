USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pw_PJCode_SHFT_PV]    Script Date: 12/21/2015 14:06:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pw_PJCode_SHFT_PV]
	@Parm0 varchar(30), @Parm1 varchar(1), @ParmEmployee varchar(10), @SortCol varchar(60) AS
exec("
	Select 'Shift'=Code_Value , Description=Code_Value_Desc 
	from PJCODE 
	where Code_Type = 'SHFT' and Code_Value like '%" + @Parm0 + "%'
	Order by " + @SortCol  
)
GO
