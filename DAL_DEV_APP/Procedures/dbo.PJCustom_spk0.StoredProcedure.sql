USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCustom_spk0]    Script Date: 12/21/2015 13:35:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJCustom_spk0] 
	@Parm0 varchar(10), @Parm1 varchar(10), @Parm2 varchar(4) AS

	Select * from PJCUSTOM
		Where applicationID like @parm0
			and FieldID like @Parm1
			and Type like @Parm1
		Order by Type, Tab
GO
