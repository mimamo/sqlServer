USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEMPLOYXREFMSP_insert]    Script Date: 12/21/2015 13:35:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEMPLOYXREFMSP_insert] 
	@CpnyID				char(10),
	@Crtd_Prog			char(8),
	@Crtd_User			char(47),
	@Employee			char(10),
	@Employee_MSPName	char(60),
	@ProjectManager		char(1),
	@WindowsUserAcct	char(85)
as	
	If Not Exists (	Select employee From PJEMPLOYXREFMSP Where employee = @Employee )
		Begin
			INSERT INTO PJEMPLOYXREFMSP 
				(CpnyID, Crtd_DateTime, Crtd_Prog, Crtd_User, 
					Employee, Employee_MSPID,Employee_MSPName,					
					Lupd_DateTime, Lupd_Prog, Lupd_User, ProjectManager, WindowsUserAcct 
					)
				VALUES
				(@CpnyID, getdate(), @Crtd_Prog, @Crtd_User,
					@Employee, '', @Employee_MSPName,					
					getdate(), @Crtd_Prog, @Crtd_User, @ProjectManager, @WindowsUserAcct
					)
		End
GO
