USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDSetup_All]    Script Date: 12/21/2015 15:37:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDSetup_All] AS
  Select * from XDDSetup ORDER by SetupId
GO
