USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Sched_EDIPOID]    Script Date: 12/21/2015 16:07:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850Sched_EDIPOID]
 @parm1 varchar( 10 )
AS
 SELECT *
 FROM ED850Sched
 WHERE EDIPOID LIKE @parm1
 ORDER BY EDIPOID
GO
