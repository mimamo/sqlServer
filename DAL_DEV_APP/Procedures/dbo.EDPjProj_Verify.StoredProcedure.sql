USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDPjProj_Verify]    Script Date: 12/21/2015 13:35:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDPjProj_Verify] @ProjectId varchar(16) As
Select Count(*) From PjProj Where Project = @ProjectId
GO
