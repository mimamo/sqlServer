USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEMPLOYXREFMSP_delete]    Script Date: 12/21/2015 16:07:12 ******/
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
