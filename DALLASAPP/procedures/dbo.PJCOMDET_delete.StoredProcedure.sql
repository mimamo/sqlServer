USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJCOMDET_delete]    Script Date: 12/21/2015 13:44:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJCOMDET_delete] @parm1 varchar (06)  as
Delete from PJCOMDET
where fiscalno <= @parm1
GO
