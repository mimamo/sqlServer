USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[Kit_Initialize_type]    Script Date: 12/21/2015 13:44:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[Kit_Initialize_type]
	@parm1 smalldatetime,
	@parm2 varchar (8),
	@parm3 varchar (10)
	as
	Update Kit set BomType = 'N',
		LUpd_DateTime = @parm1,
		LUpd_Prog = @parm2,
		LUpd_User = @parm3
	where Status <> 'O'
GO
