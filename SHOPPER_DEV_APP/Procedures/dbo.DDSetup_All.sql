USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DDSetup_All]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[DDSetup_All] as
    Select * from DDSetup ORDER by SetupId
GO
