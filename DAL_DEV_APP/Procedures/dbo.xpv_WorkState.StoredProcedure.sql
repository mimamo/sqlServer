USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xpv_WorkState]    Script Date: 12/21/2015 13:36:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[xpv_WorkState]
@parm1 char(3)
AS
SELECT * 
FROM [State] 
WHERE StateProvID LIKE @parm1 
ORDER BY StateProvID
GO
