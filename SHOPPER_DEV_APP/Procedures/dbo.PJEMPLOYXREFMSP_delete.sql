USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEMPLOYXREFMSP_delete]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEMPLOYXREFMSP_delete] 
	@Employee			char(10)
as	
	If Exists (	Select employee From PJEMPLOYXREFMSP Where employee = @Employee )
		begin	
			DELETE FROM PJEMPLOYXREFMSP WHERE Employee = @Employee 
		end
GO
