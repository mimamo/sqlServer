USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Sched_EntityId]    Script Date: 12/21/2015 15:42:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850Sched_EntityId]
 @parm1 varchar( 80 )
AS
 SELECT *
 FROM ED850Sched
 WHERE EntityId LIKE @parm1
 ORDER BY EntityId
GO
