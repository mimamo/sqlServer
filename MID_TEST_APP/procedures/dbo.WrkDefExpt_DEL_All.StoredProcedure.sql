USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WrkDefExpt_DEL_All]    Script Date: 12/21/2015 15:49:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[WrkDefExpt_DEL_All] @parm1 smallint as
Delete from WrkDefExpt
where RI_ID = @parm1
GO
