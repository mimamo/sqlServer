USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDSetupEx_SetupID]    Script Date: 12/21/2015 13:57:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDSetupEx_SetupID] @parm1 varchar(2) AS
  Select * from XDDSetupEx where SetupID LIKE @parm1 ORDER by SetupId
GO
