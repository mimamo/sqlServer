USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCOMDET_delete]    Script Date: 12/21/2015 15:37:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJCOMDET_delete] @parm1 varchar (06)  as
Delete from PJCOMDET
where fiscalno <= @parm1
GO
