USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[INSetup_SetupId]    Script Date: 12/21/2015 16:07:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.INSetup_SetupId    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.INSetup_SetupId    Script Date: 4/16/98 7:41:51 PM ******/
Create Proc [dbo].[INSetup_SetupId] @parm1 varchar ( 2) as
    Select * from INSetup where SetupId = @parm1 order by SetupId
GO
