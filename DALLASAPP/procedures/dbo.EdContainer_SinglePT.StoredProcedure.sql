USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EdContainer_SinglePT]    Script Date: 12/21/2015 13:44:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EdContainer_SinglePT] @parm1 varchar(10)  AS SELECT * FROM EdContainer WHERE containerid = @parm1  ORDER BY ContainerID
GO
