USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xEstRevInq_dbnav]    Script Date: 12/21/2015 15:37:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xEstRevInq_dbnav] 
	@parm1 Varchar (16), 
--	@parm2 Varchar (10) 
	@parm3 Varchar (32) 
AS
	SELECT * FROM xEstRevInq WHERE
 		Project = @parm1 AND
		PJT_ENTITY  Like @parm3
	order by Project,PJT_ENTITY
GO
