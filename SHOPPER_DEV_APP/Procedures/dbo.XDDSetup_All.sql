USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDSetup_All]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDSetup_All] AS
  Select * from XDDSetup ORDER by SetupId
GO
