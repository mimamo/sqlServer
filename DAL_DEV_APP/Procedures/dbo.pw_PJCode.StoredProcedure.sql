USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pw_PJCode]    Script Date: 12/21/2015 13:35:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pw_PJCode]
	@Parm0 varchar(4), @Parm1 varchar(30) AS
exec("

	Select code_value_desc, data2  from pjcode 
		where code_type = '" + @Parm0 + "' and code_value = '" + @Parm1 + "'"

)
GO
