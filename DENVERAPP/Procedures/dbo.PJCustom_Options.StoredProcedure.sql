USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJCustom_Options]    Script Date: 12/21/2015 15:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJCustom_Options] 
	@Parm0 varchar(10), @Parm1 varchar(10), @Parm2 varchar(4) AS

	Select * from PJCUSTOM P, PJCustomOptions O
		Where P.applicationID like @parm0
			and P.FieldID like @Parm1
			and P.Type like @Parm2
			and P.applicationID = O.applicationID
			and P.FieldID = O.FieldID
		Order by Tab
GO
