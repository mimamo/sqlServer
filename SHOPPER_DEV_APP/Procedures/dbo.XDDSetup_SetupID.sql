USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDSetup_SetupID]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDSetup_SetupID] @parm1 varchar(2) AS
  Select * from XDDSetup where SetupID LIKE @parm1 ORDER by SetupId
GO
