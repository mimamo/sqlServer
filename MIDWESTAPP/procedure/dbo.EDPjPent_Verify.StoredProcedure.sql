USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDPjPent_Verify]    Script Date: 12/21/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDPjPent_Verify] @ProjectId varchar(16), @TaskId varchar(32) As
Select Count(*) From PjPent Where Project = @ProjectId And pjt_entity = @TaskId
GO
