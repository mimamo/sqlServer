USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Sched_EntityId]    Script Date: 12/16/2015 15:55:19 ******/
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
