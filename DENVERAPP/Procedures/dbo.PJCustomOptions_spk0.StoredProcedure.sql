USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJCustomOptions_spk0]    Script Date: 12/21/2015 15:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJCustomOptions_spk0] 
	@Parm0 varchar(10), @Parm1 varchar(10) As

	Select * from PJCustomOptions
		Where applicationID like @parm0
			and FieldID like @Parm1
GO
