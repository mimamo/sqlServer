USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[WorkLoc_sall]    Script Date: 12/21/2015 15:43:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure  [dbo].[WorkLoc_sall] @parm1 varchar ( 6) as
       Select * from WorkLoc
           where WrkLocId LIKE @parm1
           order by WrkLocId
GO
