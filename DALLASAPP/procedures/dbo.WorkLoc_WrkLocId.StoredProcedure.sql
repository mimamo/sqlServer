USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[WorkLoc_WrkLocId]    Script Date: 12/21/2015 13:45:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[WorkLoc_WrkLocId] @parm1 varchar ( 6) as
       Select * from WorkLoc
           where WrkLocId LIKE @parm1
           order by WrkLocId
GO
