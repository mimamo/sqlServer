USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJUTLROL_delete]    Script Date: 12/21/2015 15:37:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJUTLROL_delete] @parm1 varchar (06)  as
Delete from PJUTLROL
where fiscalno <= @parm1
GO
